import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:stiv/features/diagnostic/domain/entities/chat_message.dart';

/// Datasource que se comunica con Gemini usando el paquete oficial google_generative_ai.

class GeminiChatDatasource {
  String get _apiKey {
    final key = dotenv.maybeGet('GEMINI_API_KEY');
    if (key == null || key.isEmpty) {
      throw Exception('GEMINI_API_KEY no configurada');
    }
    return key;
  }

  /// Manda el historial + el nuevo mensaje a Gemini con streaming
  /// y retorna un [Stream<String>] de fragmentos de texto parciales.
  Stream<String> streamChat({
    required List<ChatMessage> history,
    required String userText,
    required String systemPrompt,
  }) async* {
    final model = GenerativeModel(
      model: 'gemini-2.5-flash-lite',
      apiKey: _apiKey,
      systemInstruction: Content.system(systemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.3,
        maxOutputTokens: 512,
        topP: 0.8,
      ),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
      ],
    );

    final chatHistory = history.map((msg) {
      if (msg.isUser) {
        return Content.text(msg.text);
      } else {
        return Content.model([TextPart(msg.text)]);
      }
    }).toList();

    // Agregar el mensaje actual del usuario
    chatHistory.add(Content.text(userText));

    final stream = model.generateContentStream(chatHistory);

    await for (final chunk in stream) {
      final text = chunk.text;
      if (text != null && text.isNotEmpty) {
        yield text;
      }
    }
  }
}
