import 'package:stiv/features/diagnostic/data/datasources/gemini_chat_datasource.dart';
import 'package:stiv/features/diagnostic/domain/entities/chat_message.dart';
import 'package:stiv/features/diagnostic/domain/repositories/ai_chat_repository.dart';

/// Implementación concreta del [AiChatRepository] que delega al datasource
/// de Gemini. La capa de dominio y presentación nunca dependen de esta clase
/// directamente — acceden a ella a través de la abstracción [AiChatRepository].
class AiChatRepositoryImpl implements AiChatRepository {
  AiChatRepositoryImpl(this._datasource);

  final GeminiChatDatasource _datasource;

  @override
  Stream<String> sendMessage({
    required List<ChatMessage> history,
    required String userText,
    required String systemPrompt,
  }) =>
      _datasource.streamChat(
        history: history,
        userText: userText,
        systemPrompt: systemPrompt,
      );
}
