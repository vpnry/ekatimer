class SoundConfig {
  final String startSound;
  final String endSound;
  final String intervalSound;
  final int intervalMinutes;
  final int volume; // 0-100

  const SoundConfig({
    this.startSound = 'none',
    this.endSound = 'ThreeBowl',
    this.intervalSound = 'Bowl',
    this.intervalMinutes = 0,
    this.volume = 80,
  });

  SoundConfig copyWith({
    String? startSound,
    String? endSound,
    String? intervalSound,
    int? intervalMinutes,
    int? volume,
  }) {
    return SoundConfig(
      startSound: startSound ?? this.startSound,
      endSound: endSound ?? this.endSound,
      intervalSound: intervalSound ?? this.intervalSound,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      volume: volume ?? this.volume,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startSound': startSound,
      'endSound': endSound,
      'intervalSound': intervalSound,
      'intervalMinutes': intervalMinutes,
      'volume': volume,
    };
  }

  factory SoundConfig.fromMap(Map<String, dynamic> map) {
    return SoundConfig(
      startSound: map['startSound'] as String? ?? 'none',
      endSound: map['endSound'] as String? ?? 'ThreeBowl',
      intervalSound: map['intervalSound'] as String? ?? 'Bowl',
      intervalMinutes: map['intervalMinutes'] as int? ?? 0,
      volume: map['volume'] as int? ?? 80,
    );
  }
}
