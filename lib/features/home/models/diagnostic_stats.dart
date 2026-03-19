class DiagnosticStats {
  final int totalDevices;
  final int totalDiagnostics;
  final Map<String, int> devicesByCategory;

  const DiagnosticStats({
    required this.totalDevices,
    required this.totalDiagnostics,
    required this.devicesByCategory,
  });

  factory DiagnosticStats.fromJson(Map<String, dynamic> json) {
    return DiagnosticStats(
      totalDevices: json['totalDevices'] ?? 0,
      totalDiagnostics: json['totalDiagnostics'] ?? 0,
      devicesByCategory: Map<String, int>.from(json['devicesByCategory'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalDevices': totalDevices,
      'totalDiagnostics': totalDiagnostics,
      'devicesByCategory': devicesByCategory,
    };
  }

  factory DiagnosticStats.empty() {
    return const DiagnosticStats(
      totalDevices: 0,
      totalDiagnostics: 0,
      devicesByCategory: {},
    );
  }
}
