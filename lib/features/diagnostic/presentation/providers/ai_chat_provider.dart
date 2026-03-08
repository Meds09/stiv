import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:stiv/features/auth/providers/auth_provider.dart';
import 'package:stiv/features/diagnostic/data/datasources/gemini_chat_datasource.dart';
import 'package:stiv/features/diagnostic/data/repositories/ai_chat_repository_impl.dart';
import 'package:stiv/features/diagnostic/domain/entities/ai_chat_context.dart';
import 'package:stiv/features/diagnostic/domain/entities/chat_message.dart';
import 'package:stiv/features/diagnostic/domain/repositories/ai_chat_repository.dart';

// ─── Providers de infraestructura ────────────────────────────────────────────

final _geminiDatasourceProvider = Provider<GeminiChatDatasource>(
  (_) => GeminiChatDatasource(),
);

final aiChatRepositoryProvider = Provider<AiChatRepository>((ref) {
  return AiChatRepositoryImpl(ref.read(_geminiDatasourceProvider));
});

// ─── Estado del chat ──────────────────────────────────────────────────────────

class AiChatState {
  const AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.errorMessage,
    this.streamingMessageId,
  });

  final List<ChatMessage> messages;

  /// true mientras la IA está generando una respuesta.
  final bool isLoading;

  /// Mensaje de error si la llamada a Gemini falló.
  final String? errorMessage;

  /// ID del mensaje que está siendo construido por el stream (permite actualizar
  /// la burbuja en tiempo real sin añadir mensajes duplicados).
  final String? streamingMessageId;

  AiChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? errorMessage,
    String? streamingMessageId,
    bool clearError = false,
    bool clearStreamingId = false,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      streamingMessageId: clearStreamingId
          ? null
          : (streamingMessageId ?? this.streamingMessageId),
    );
  }
}

// ─── System prompt de conocimiento previo ────────────────────────────────────

String _buildSystemPrompt(AiChatContext ctx) => '''
Eres STIV, un asistente de diagnóstico técnico especializado en sistemas de seguridad electrónica para técnicos de campo. Tu misión es ayudar a diagnosticar y solucionar fallas de manera rápida y precisa.

DISPOSITIVO EN DIAGNÓSTICO: ${ctx.deviceType}
${ctx.symptomLabel != null ? 'SÍNTOMA REPORTADO: ${ctx.symptomLabel}' : ''}
TÉCNICO: ${ctx.userName}

REGLAS ESTRICTAS:
1. Responde SOLO sobre seguridad electrónica: CCTV, DVR/NVR, control de acceso, redes IP, UPS, energía. Rechaza educadamente temas ajenos.
2. Haz máximo UNA pregunta de diagnóstico por turno — específica y técnica.
3. Cuando tengas suficiente información, da un diagnóstico concreto con pasos numerados (máx. 4 pasos).
4. Usa vocabulario técnico pero claro. Sin dramatismos, sin redondeos, solo hechos.
5. Respuestas cortas: máximo 120 palabras por turno.
6. Si el problema requiere escalación a fábrica o especialista, indícalo directamente.

Inicia el diagnóstico haciendo la primera pregunta técnica relacionada con el dispositivo y síntoma indicados.
''';

// ─── Notifier ────────────────────────────────────────────────────────────────

class AiChatNotifier extends StateNotifier<AiChatState> {
  AiChatNotifier(this._repository, this._context) : super(const AiChatState()) {
    _startConversation();
  }

  final AiChatRepository _repository;
  final AiChatContext _context;
  final _uuid = const Uuid();
  StreamSubscription<String>? _streamSub;

  /// Genera el saludo inicial de la IA al abrir el chat.
  Future<void> _startConversation() async {
    final welcomeId = _uuid.v4();
    state = state.copyWith(
      isLoading: true,
      streamingMessageId: welcomeId,
      messages: [
        ChatMessage(
          id: welcomeId,
          role: ChatRole.model,
          text: '',
          timestamp: DateTime.now(),
        ),
      ],
    );

    final systemPrompt = _buildSystemPrompt(_context);
    final openingQuery =
        'Inicia el diagnóstico con la primera pregunta técnica.';

    StringBuffer buffer = StringBuffer();
    try {
      _streamSub = _repository
          .sendMessage(
            history: const [],
            userText: openingQuery,
            systemPrompt: systemPrompt,
          )
          .listen(
        (chunk) {
          buffer.write(chunk);
          final updated = state.messages.map((m) {
            if (m.id == welcomeId) return m.copyWith(text: buffer.toString());
            return m;
          }).toList();
          state = state.copyWith(messages: updated);
        },
        onDone: () {
          state = state.copyWith(
            isLoading: false,
            clearStreamingId: true,
            clearError: true,
          );
        },
        onError: (e) {
          final errorStr = e.toString().toLowerCase();
          final errorMsg = errorStr.contains('quota')
              ? 'Has excedido el límite de tu API Key de Gemini. Verifica tu cuota en Google AI Studio.'
              : 'Error: ${e.toString()}';
          state = state.copyWith(
            isLoading: false,
            clearStreamingId: true,
            errorMessage: errorMsg,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        clearStreamingId: true,
        errorMessage: 'Error inesperado: $e',
      );
    }
  }

  /// Envía un mensaje del usuario y procesa la respuesta de Gemini en streaming.
  Future<void> sendMessage(String userText) async {
    if (userText.trim().isEmpty || state.isLoading) return;

    // 1. Añadir mensaje del usuario
    final userMsg = ChatMessage(
      id: _uuid.v4(),
      role: ChatRole.user,
      text: userText.trim(),
      timestamp: DateTime.now(),
    );

    // 2. Preparar burbuja de IA vacía (se llenará en streaming)
    final aiMsgId = _uuid.v4();
    final aiMsg = ChatMessage(
      id: aiMsgId,
      role: ChatRole.model,
      text: '',
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg, aiMsg],
      isLoading: true,
      streamingMessageId: aiMsgId,
      clearError: true,
    );

    // 3. Historial sin la burbuja vacía recién creada
    final historyForApi = state.messages
        .where((m) => m.id != aiMsgId)
        .toList();

    final systemPrompt = _buildSystemPrompt(_context);
    StringBuffer buffer = StringBuffer();

    try {
      await _streamSub?.cancel();
      _streamSub = _repository
          .sendMessage(
            history: historyForApi,
            userText: userText.trim(),
            systemPrompt: systemPrompt,
          )
          .listen(
        (chunk) {
          buffer.write(chunk);
          final updated = state.messages.map((m) {
            if (m.id == aiMsgId) return m.copyWith(text: buffer.toString());
            return m;
          }).toList();
          state = state.copyWith(messages: updated);
        },
        onDone: () {
          state = state.copyWith(
            isLoading: false,
            clearStreamingId: true,
          );
        },
        onError: (e) {
          final errorStr = e.toString().toLowerCase();
          final errorMsg = errorStr.contains('quota')
              ? 'Has excedido el límite de tu API Key de Gemini. Verifica tu cuota en Google AI Studio.'
              : 'Error: ${e.toString()}';
          state = state.copyWith(
            isLoading: false,
            clearStreamingId: true,
            errorMessage: errorMsg,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        clearStreamingId: true,
        errorMessage: 'Error inesperado: $e',
      );
    }
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    super.dispose();
  }
}

// ─── Provider family (autoDispose) ───────────────────────────────────────────

final aiChatProvider = StateNotifierProvider.autoDispose
    .family<AiChatNotifier, AiChatState, AiChatContext>(
  (ref, ctx) {
    final repository = ref.read(aiChatRepositoryProvider);
    return AiChatNotifier(repository, ctx);
  },
);

// ─── Provider de contexto construido desde el usuario autenticado ────────────

final aiChatContextProvider = Provider.family<AiChatContext, AiChatContext>(
  (ref, passedCtx) => passedCtx,
);

/// Helper: provider que construye el contexto del usuario logeado.
final defaultAiContextProvider = Provider<AiChatContext>((ref) {
  final user = ref.watch(currentUserProvider);
  final name = user?.displayName?.split(' ').first ?? 'Técnico';
  return AiChatContext(
    deviceType: 'No especificado',
    userName: name,
  );
});
