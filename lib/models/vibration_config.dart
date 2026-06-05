class VibrationConfig {
  final String startVibration;
  final String endVibration;
  final String intervalVibration;

  const VibrationConfig({
    this.startVibration = 'none',
    this.endVibration = 'none',
    this.intervalVibration = 'none',
  });

  VibrationConfig copyWith({
    String? startVibration,
    String? endVibration,
    String? intervalVibration,
  }) {
    return VibrationConfig(
      startVibration: startVibration ?? this.startVibration,
      endVibration: endVibration ?? this.endVibration,
      intervalVibration: intervalVibration ?? this.intervalVibration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startVibration': startVibration,
      'endVibration': endVibration,
      'intervalVibration': intervalVibration,
    };
  }

  factory VibrationConfig.fromMap(Map<String, dynamic> map) {
    return VibrationConfig(
      startVibration: map['startVibration'] as String? ?? 'none',
      endVibration: map['endVibration'] as String? ?? 'none',
      intervalVibration: map['intervalVibration'] as String? ?? 'none',
    );
  }
}
