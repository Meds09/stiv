/// Modelo de datos para las estadísticas del home
/// Fácil de mapear desde Firebase/BD cuando se implemente
class HomeStats {
  final int cameras;
  final int electricalSupport;
  final int accessControl;
  final List<int> camerasHistory;
  final List<int> electricalHistory;
  final List<int> accessControlHistory;
  final double readinessPercentage;
  final List<double> readinessHistory;

  const HomeStats({
    required this.cameras,
    required this.electricalSupport,
    required this.accessControl,
    required this.camerasHistory,
    required this.electricalHistory,
    required this.accessControlHistory,
    required this.readinessPercentage,
    required this.readinessHistory,
  });

  /// Constructor desde JSON para facilitar integración con Firebase
  factory HomeStats.fromJson(Map<String, dynamic> json) {
    return HomeStats(
      cameras: json['cameras'] ?? 0,
      electricalSupport: json['electricalSupport'] ?? 0,
      accessControl: json['accessControl'] ?? 0,
      camerasHistory: (json['camerasHistory'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      electricalHistory: (json['electricalHistory'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      accessControlHistory: (json['accessControlHistory'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      readinessPercentage: (json['readinessPercentage'] ?? 0.0).toDouble(),
      readinessHistory: (json['readinessHistory'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }

  /// Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'cameras': cameras,
      'electricalSupport': electricalSupport,
      'accessControl': accessControl,
      'camerasHistory': camerasHistory,
      'electricalHistory': electricalHistory,
      'accessControlHistory': accessControlHistory,
      'readinessPercentage': readinessPercentage,
      'readinessHistory': readinessHistory,
    };
  }

  /// Constructor vacío para estado inicial
  factory HomeStats.empty() {
    return const HomeStats(
      cameras: 0,
      electricalSupport: 0,
      accessControl: 0,
      camerasHistory: [],
      electricalHistory: [],
      accessControlHistory: [],
      readinessPercentage: 0.0,
      readinessHistory: [],
    );
  }
}

