import 'user_profile.dart';

class MeditationSession {
  final String id;
  final String profileId;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;
  final int targetDurationSeconds;
  final String timerMode;
  final bool completed;
  final String? quality;
  final String? notes;

  MeditationSession({
    required this.id,
    this.profileId = UserProfile.defaultId,
    required this.startTime,
    this.endTime,
    required this.durationSeconds,
    this.targetDurationSeconds = 0,
    this.timerMode = 'timed',
    this.completed = true,
    this.quality,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileId': profileId,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'durationSeconds': durationSeconds,
      'targetDurationSeconds': targetDurationSeconds,
      'timerMode': timerMode,
      'completed': completed ? 1 : 0,
      'quality': quality,
      'notes': notes,
    };
  }

  factory MeditationSession.fromMap(Map<String, dynamic> map) {
    return MeditationSession(
      id: map['id'] as String,
      profileId: map['profileId'] as String? ?? UserProfile.defaultId,
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      endTime: map['endTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int)
          : null,
      durationSeconds: map['durationSeconds'] as int,
      targetDurationSeconds: map['targetDurationSeconds'] as int? ?? 0,
      timerMode: map['timerMode'] as String? ?? 'timed',
      completed: (map['completed'] as int?) == 1,
      quality: map['quality'] as String?,
      notes: map['notes'] as String?,
    );
  }

  /// [clearQuality]/[clearNotes] exist because `copyWith(quality: null)`
  /// is indistinguishable from "don't change quality" — the named flag is
  /// the only way to explicitly blank a nullable field via copyWith.
  MeditationSession copyWith({
    String? id,
    String? profileId,
    DateTime? startTime,
    DateTime? endTime,
    int? durationSeconds,
    int? targetDurationSeconds,
    String? timerMode,
    bool? completed,
    String? quality,
    bool clearQuality = false,
    String? notes,
    bool clearNotes = false,
  }) {
    return MeditationSession(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      targetDurationSeconds:
          targetDurationSeconds ?? this.targetDurationSeconds,
      timerMode: timerMode ?? this.timerMode,
      completed: completed ?? this.completed,
      quality: clearQuality ? null : quality ?? this.quality,
      notes: clearNotes ? null : notes ?? this.notes,
    );
  }
}
