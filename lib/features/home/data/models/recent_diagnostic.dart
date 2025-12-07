/// Modelo de datos para diagnósticos recientes
/// Fácil de mapear desde Firebase/BD cuando se implemente
class RecentDiagnostic {
  final String id;
  final String deviceName;
  final String deviceType;
  final DateTime date;
  final DiagnosticStatus status;
  final String? issueFound;

  const RecentDiagnostic({
    required this.id,
    required this.deviceName,
    required this.deviceType,
    required this.date,
    required this.status,
    this.issueFound,
  });

  /// Constructor desde JSON para facilitar integración con Firebase
  factory RecentDiagnostic.fromJson(Map<String, dynamic> json) {
    return RecentDiagnostic(
      id: json['id'] ?? '',
      deviceName: json['deviceName'] ?? '',
      deviceType: json['deviceType'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      status: DiagnosticStatus.fromString(json['status'] ?? 'pending'),
      issueFound: json['issueFound'],
    );
  }

  /// Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'date': date.toIso8601String(),
      'status': status.toString(),
      'issueFound': issueFound,
    };
  }
}

/// Estado del diagnóstico
enum DiagnosticStatus {
  success,
  warning,
  error,
  pending;

  static DiagnosticStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'success':
        return DiagnosticStatus.success;
      case 'warning':
        return DiagnosticStatus.warning;
      case 'error':
        return DiagnosticStatus.error;
      default:
        return DiagnosticStatus.pending;
    }
  }

  @override
  String toString() {
    switch (this) {
      case DiagnosticStatus.success:
        return 'success';
      case DiagnosticStatus.warning:
        return 'warning';
      case DiagnosticStatus.error:
        return 'error';
      case DiagnosticStatus.pending:
        return 'pending';
    }
  }
}

