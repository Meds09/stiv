/// Rol del mensaje en la conversación.
enum ChatRole { user, model }

/// Entidad inmutable que representa un mensaje de chat.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
  });

  final String id;
  final ChatRole role;
  final String text;
  final DateTime timestamp;

  ChatMessage copyWith({String? text}) => ChatMessage(
        id: id,
        role: role,
        text: text ?? this.text,
        timestamp: timestamp,
      );

  bool get isUser => role == ChatRole.user;
  bool get isModel => role == ChatRole.model;
}
