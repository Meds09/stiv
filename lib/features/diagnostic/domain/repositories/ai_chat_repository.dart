import 'package:stiv/features/diagnostic/domain/entities/chat_message.dart';

/// Contrato del repositorio de chat con IA.
///
/// El datasource que implementa este contrato se comunica con la API de
/// Gemini; la capa de dominio no sabe nada de HTTP ni de claves de API.
abstract class AiChatRepository {
  /// Envía [userText] junto con el [history] previo y retorna la respuesta
  /// completa de la IA como un [Stream<String>] de tokens parciales.
  Stream<String> sendMessage({
    required List<ChatMessage> history,
    required String userText,
    required String systemPrompt,
  });
}
