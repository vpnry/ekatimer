class VibrationConfig {
  final String startVibration;
  final String endVibration;
  final String intervalVibration;
  final int intervalMinutes;

  const VibrationConfig({
    this.startVibration = 'none',
    this.endVibration = 'medium',
    this.intervalVibration = 'none',
    this.intervalMinutes = 0,
  });

  VibrationConfig copyWith({
    String? startVibration,
    String? endVibration,
    String? intervalVibration,
    int? intervalMinutes,
  }) {
    return VibrationConfig(
      startVibration: startVibration ?? this.startVibration,
      endVibration: endVibration ?? this.endVibration,
      intervalVibration: intervalVibration ?? this.intervalVibration,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startVibration': startVibration,
      'endVibration': endVibration,
      'intervalVibration': intervalVibration,
      'intervalMinutes': intervalMinutes,
    };
  }

  factory VibrationConfig.fromMap(Map<String, dynamic> map) {
    return VibrationConfig(
      startVibration: map['startVibration'] as String? ?? 'none',
      endVibration: map['endVibration'] as String? ?? 'none',
      intervalVibration: map['intervalVibration'] as String? ?? 'none',
      intervalMinutes: map['intervalMinutes'] as int? ?? 0,
    );
  }
}
