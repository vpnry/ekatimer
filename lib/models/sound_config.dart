class SoundConfig {
  final String startSound;
  final String endSound;
  final String intervalSound;
  final String bellSound;
  final int intervalMinutes;
  final int bellIntervalMinutes;
  final int volume; // 0-100

  const SoundConfig({
    this.startSound = 'none',
    this.endSound = 'BowlStrong',
    this.intervalSound = 'Bowl',
    this.bellSound = 'Bowl',
    this.intervalMinutes = 0,
    this.bellIntervalMinutes = 0,
    this.volume = 80,
  });

  SoundConfig copyWith({
    String? startSound,
    String? endSound,
    String? intervalSound,
    String? bellSound,
    int? intervalMinutes,
    int? bellIntervalMinutes,
    int? volume,
  }) {
    return SoundConfig(
      startSound: startSound ?? this.startSound,
      endSound: endSound ?? this.endSound,
      intervalSound: intervalSound ?? this.intervalSound,
      bellSound: bellSound ?? this.bellSound,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      bellIntervalMinutes: bellIntervalMinutes ?? this.bellIntervalMinutes,
      volume: volume ?? this.volume,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startSound': startSound,
      'endSound': endSound,
      'intervalSound': intervalSound,
      'bellSound': bellSound,
      'intervalMinutes': intervalMinutes,
      'bellIntervalMinutes': bellIntervalMinutes,
      'volume': volume,
    };
  }

  factory SoundConfig.fromMap(Map<String, dynamic> map) {
    return SoundConfig(
      startSound: map['startSound'] as String? ?? 'none',
      endSound: map['endSound'] as String? ?? 'BowlStrong',
      intervalSound: map['intervalSound'] as String? ?? 'Bowl',
      bellSound: map['bellSound'] as String? ?? 'Bowl',
      intervalMinutes: map['intervalMinutes'] as int? ?? 0,
      bellIntervalMinutes: map['bellIntervalMinutes'] as int? ?? 0,
      volume: map['volume'] as int? ?? 80,
    );
  }
}
