class MeditationSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;
  final int targetDurationSeconds;
  final String timerMode;
  final bool completed;
  final String? notes;

  MeditationSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.durationSeconds,
    this.targetDurationSeconds = 0,
    this.timerMode = 'timed',
    this.completed = true,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'durationSeconds': durationSeconds,
      'targetDurationSeconds': targetDurationSeconds,
      'timerMode': timerMode,
      'completed': completed ? 1 : 0,
      'notes': notes,
    };
  }

  factory MeditationSession.fromMap(Map<String, dynamic> map) {
    return MeditationSession(
      id: map['id'] as String,
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      endTime: map['endTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int)
          : null,
      durationSeconds: map['durationSeconds'] as int,
      targetDurationSeconds: map['targetDurationSeconds'] as int? ?? 0,
      timerMode: map['timerMode'] as String? ?? 'timed',
      completed: (map['completed'] as int?) == 1,
      notes: map['notes'] as String?,
    );
  }

  MeditationSession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? durationSeconds,
    int? targetDurationSeconds,
    String? timerMode,
    bool? completed,
    String? notes,
  }) {
    return MeditationSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      targetDurationSeconds: targetDurationSeconds ?? this.targetDurationSeconds,
      timerMode: timerMode ?? this.timerMode,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
    );
  }
}
