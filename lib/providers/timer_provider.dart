import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/timer_mode.dart';
import '../models/meditation_session.dart';
import '../services/persistence_service.dart';
import '../services/audio_service.dart';
import '../services/vibration_service.dart';
import '../services/database_service.dart';
import '../services/alarm_service.dart';
import '../utils/constants.dart';

enum TimerState { idle, delaying, running, paused, completed }

class TimerProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();
  final VibrationService _vibrationService = VibrationService();
  final AlarmService _alarmService = AlarmService();

  TimerMode _timerMode = TimerMode.timed;
  int _durationMinutes = AppConstants.defaultTimerDurationMinutes;
  int _endAtHour = 0;
  int _endAtMinute = 0;

  TimerState _state = TimerState.idle;
  int _elapsedSeconds = 0;
  int _remainingSeconds = 0;
  int _totalDurationSeconds = 0;
  late DateTime _startTime;
  DateTime? _endTime;
  int _pauseDurationSeconds = 0;
  late DateTime _pauseStartTime;
  String? _currentSessionId;

  int _lastIntervalMinute = -1;
  int _lastBellMinute = -1;

  int intervalMinutes = 0;
  int bellIntervalMinutes = 0;
  String startSound = 'none';
  String endSound = 'BowlStrong';
  String intervalSound = 'Bowl';
  String bellSound = 'Bowl';
  String startVibration = 'none';
  String endVibration = 'none';
  String intervalVibration = 'none';
  int volume = 80;

  int sessionDelaySeconds = 10;
  int _delayRemainingSeconds = 0;
  Timer? _delayTimer;

  Timer? _tickTimer;
  bool _alarmFired = false;

  TimerState get state => _state;
  TimerMode get timerMode => _timerMode;
  int get durationMinutes => _durationMinutes;
  int get elapsedSeconds => _elapsedSeconds;
  int get remainingSeconds => _remainingSeconds;
  int get totalDurationSeconds => _totalDurationSeconds;
  DateTime get startTime => _startTime;
  DateTime? get endTime => _endTime;
  int get pauseDurationSeconds => _pauseDurationSeconds;
  int get endAtHour => _endAtHour;
  int get endAtMinute => _endAtMinute;
  int get delayRemainingSeconds => _delayRemainingSeconds;
  String? get currentSessionId => _currentSessionId;

  void configure({
    TimerMode? mode,
    int? durationMinutes,
    int? endAtHour,
    int? endAtMinute,
  }) {
    if (mode != null) _timerMode = mode;
    if (durationMinutes != null) _durationMinutes = durationMinutes;
    if (endAtHour != null) _endAtHour = endAtHour;
    if (endAtMinute != null) _endAtMinute = endAtMinute;
    notifyListeners();
  }

  String get displayTime {
    switch (_state) {
      case TimerState.delaying:
      case TimerState.idle:
        if (_timerMode == TimerMode.timed) {
          final minutes = _durationMinutes;
          final hours = minutes ~/ 60;
          final mins = minutes % 60;
          if (hours > 0) {
            return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:00';
          }
          return '${mins.toString().padLeft(2, '0')}:00';
        } else if (_timerMode == TimerMode.endAt) {
          final hour = _endAtHour == 0
              ? 12
              : (_endAtHour > 12 ? _endAtHour - 12 : _endAtHour);
          final amPm = _endAtHour >= 12 ? 'PM' : 'AM';
          return '$hour:${_endAtMinute.toString().padLeft(2, '0')} $amPm';
        }
        return '--:--';
      case TimerState.running:
      case TimerState.paused:
      case TimerState.completed:
        if (_timerMode == TimerMode.timed) {
          final hours = _remainingSeconds ~/ 3600;
          final minutes = (_remainingSeconds % 3600) ~/ 60;
          final seconds = _remainingSeconds % 60;
          if (hours > 0) {
            return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
          }
          return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        } else {
          final hours = _elapsedSeconds ~/ 3600;
          final minutes = (_elapsedSeconds % 3600) ~/ 60;
          final seconds = _elapsedSeconds % 60;
          if (hours > 0) {
            return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
          }
          return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        }
    }
  }

  String get elapsedDisplay {
    final hours = _elapsedSeconds ~/ 3600;
    final minutes = (_elapsedSeconds % 3600) ~/ 60;
    final seconds = _elapsedSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> startSession() async {
    _currentSessionId = const Uuid().v4();
    _startTime = DateTime.now();
    _elapsedSeconds = 0;
    _pauseDurationSeconds = 0;
    _lastIntervalMinute = -1;
    _lastBellMinute = -1;
    _alarmFired = false;

    switch (_timerMode) {
      case TimerMode.timed:
        _totalDurationSeconds = _durationMinutes * 60;
        _remainingSeconds = _totalDurationSeconds;
        _endTime = _startTime.add(Duration(seconds: _totalDurationSeconds));
        break;
      case TimerMode.endAt:
        final now = DateTime.now();
        _endTime = DateTime(
          now.year,
          now.month,
          now.day,
          _endAtHour,
          _endAtMinute,
        );
        if (_endTime!.isBefore(now)) {
          _endTime = _endTime!.add(const Duration(days: 1));
        }
        _totalDurationSeconds = _endTime!.difference(now).inSeconds;
        _remainingSeconds = _totalDurationSeconds;
        break;
      case TimerMode.unlimited:
        _totalDurationSeconds = 0;
        _remainingSeconds = -1;
        _endTime = null;
        break;
    }

    // If a session delay is configured, enter the delaying state first.
    if (sessionDelaySeconds > 0) {
      _delayRemainingSeconds = sessionDelaySeconds;
      _state = TimerState.delaying;
      notifyListeners();
      _startDelayCountdown();
      return;
    }

    await _beginRunning();
  }

  /// Called after the delay countdown completes, or immediately if no delay.
  Future<void> _beginRunning() async {
    _state = TimerState.running;

    await _audioService.setVolume(volume / 100.0);
    await _audioService.playSound(startSound);
    await _vibrationService.vibrate(startVibration);

    // Acquire CPU wake lock to keep Dart timer running when screen is off
    await _alarmService.acquireCpuWakeLock();

    // Schedule a native AlarmManager alarm as a backup (wakes from doze)
    if (_endTime != null) {
      final remainingMs = _endTime!.millisecondsSinceEpoch;
      await _alarmService.scheduleEndAlarm(
        endTimeMillis: remainingMs,
        requestCode: _timerMode == TimerMode.timed
            ? 1001
            : 1002,
        soundPath: endSound,
      );
    }

    await _persistSessionState();
    _startTick();
    notifyListeners();
  }

  void _startDelayCountdown() {
    _delayTimer?.cancel();
    _delayTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _delayRemainingSeconds--;
      if (_delayRemainingSeconds <= 0) {
        _delayTimer?.cancel();
        _delayTimer = null;
        _beginRunning();
      } else {
        notifyListeners();
      }
    });
  }

  /// Skip the delay and start the session immediately.
  /// The user can call this by tapping the start button again.
  Future<void> skipDelay() async {
    if (_state != TimerState.delaying) return;
    _delayTimer?.cancel();
    _delayTimer = null;
    _delayRemainingSeconds = 0;
    await _beginRunning();
  }

  Future<void> pauseSession() async {
    if (_state != TimerState.running) return;
    _state = TimerState.paused;
    _pauseStartTime = DateTime.now();
    _stopTick();
    // Cancel the native alarm while paused - will reschedule on resume
    await _alarmService.cancelEndAlarm(
      requestCode: _timerMode == TimerMode.timed ? 1001 : 1002,
    );
    await _alarmService.releaseCpuWakeLock();
    await _persistSessionState();
    notifyListeners();
  }

  Future<void> resumeSession() async {
    if (_state != TimerState.paused) return;
    final pauseDuration = DateTime.now().difference(_pauseStartTime);
    _pauseDurationSeconds += pauseDuration.inSeconds;

    if (_endTime != null) {
      _endTime = _endTime!.add(pauseDuration);
    }

    _state = TimerState.running;
    _alarmFired = false;

    // Re-acquire CPU wake lock and reschedule alarm
    await _alarmService.acquireCpuWakeLock();
    if (_endTime != null) {
      await _alarmService.scheduleEndAlarm(
        endTimeMillis: _endTime!.millisecondsSinceEpoch,
        requestCode: _timerMode == TimerMode.timed ? 1001 : 1002,
        soundPath: endSound,
      );
    }

    _startTick();
    await _persistSessionState();
    notifyListeners();
  }

  Future<void> stopSession({bool completed = true}) async {
    _stopTick();

    // Cancel any pending alarms and release CPU wake lock
    await _alarmService.cancelAllAlarms();
    await _alarmService.releaseCpuWakeLock();

    final now = DateTime.now();
    _elapsedSeconds = _calculateElapsedSeconds(now);
    _state = TimerState.completed;

    await _audioService.playSound(endSound);
    await _vibrationService.vibrate(endVibration);

    final session = MeditationSession(
      id: _currentSessionId ?? const Uuid().v4(),
      startTime: _startTime,
      endTime: now,
      durationSeconds: _elapsedSeconds,
      targetDurationSeconds: _totalDurationSeconds,
      timerMode: _timerMode.asString,
      completed: completed,
    );
    await DatabaseService.insertSession(session);

    await PersistenceService.clearActiveSession();

    notifyListeners();
  }

  int _calculateElapsedSeconds(DateTime now) {
    final totalElapsed = now.difference(_startTime).inSeconds;
    return totalElapsed - _pauseDurationSeconds;
  }

  Future<void> restoreSession(Map<String, int> sessionData) async {
    final settings = await PersistenceService.loadSettings();
    sessionDelaySeconds = settings.sessionDelaySeconds;
    intervalMinutes = settings.soundConfig.intervalMinutes;
    bellIntervalMinutes = settings.soundConfig.bellIntervalMinutes;
    startSound = settings.soundConfig.startSound;
    endSound = settings.soundConfig.endSound;
    intervalSound = settings.soundConfig.intervalSound;
    bellSound = settings.soundConfig.bellSound;
    startVibration = settings.vibrationConfig.startVibration;
    endVibration = settings.vibrationConfig.endVibration;
    intervalVibration = settings.vibrationConfig.intervalVibration;
    volume = settings.soundConfig.volume;

    final startTimeMs = sessionData['startTime']!;
    final durationSeconds = sessionData['durationSeconds']!;
    final pauseDuration = sessionData['pauseDuration'] ?? 0;
    final endTimeMs = sessionData['endTime']!;

    _startTime = DateTime.fromMillisecondsSinceEpoch(startTimeMs);
    _endTime = DateTime.fromMillisecondsSinceEpoch(
      endTimeMs > 0 ? endTimeMs : 0,
    );
    _totalDurationSeconds = durationSeconds;
    _pauseDurationSeconds = pauseDuration;
    _currentSessionId = const Uuid().v4();
    _alarmFired = false;

    final modeStr = await PersistenceService.loadActiveSessionMode();
    _timerMode = TimerMode.fromString(modeStr ?? 'timed');

    final isPaused = await PersistenceService.loadActiveSessionIsPaused();
    _state = isPaused ? TimerState.paused : TimerState.running;

    final now = DateTime.now();
    _elapsedSeconds = _calculateElapsedSeconds(now);

    if (_timerMode == TimerMode.timed && _endTime != null) {
      _remainingSeconds = _endTime!.difference(now).inSeconds;
    }

    _lastIntervalMinute = -1;
    _lastBellMinute = -1;

    if (!isPaused) {
      // Re-acquire CPU wake lock and reschedule alarm on restore
      await _alarmService.acquireCpuWakeLock();
      if (_endTime != null && _endTime!.millisecondsSinceEpoch > 0) {
        await _alarmService.scheduleEndAlarm(
          endTimeMillis: _endTime!.millisecondsSinceEpoch,
          requestCode: _timerMode == TimerMode.timed ? 1001 : 1002,
          soundPath: endSound,
        );
      }
      _startTick();
    }

    notifyListeners();
  }

  Future<void> _persistSessionState() async {
    await PersistenceService.saveActiveSession(
      startTime: _startTime.millisecondsSinceEpoch,
      durationSeconds: _totalDurationSeconds,
      mode: _timerMode.asString,
      isPaused: _state == TimerState.paused,
      pauseDuration: _pauseDurationSeconds,
      endTime: _endTime?.millisecondsSinceEpoch ?? 0,
    );
  }

  void _startTick() {
    _stopTick();
    _tickTimer = Timer.periodic(
      const Duration(milliseconds: AppConstants.timerTickIntervalMs),
      (_) => _onTick(),
    );
  }

  void _stopTick() {
    _tickTimer?.cancel();
    _tickTimer = null;
  }

  void _onTick() {
    final now = DateTime.now();
    _elapsedSeconds = _calculateElapsedSeconds(now);

    switch (_timerMode) {
      case TimerMode.timed:
        if (_endTime != null) {
          final remaining = _endTime!.difference(now).inSeconds;
          _remainingSeconds = remaining < 0 ? 0 : remaining;
          if (_remainingSeconds <= 0) {
            _onSessionComplete();
            return;
          }
        }
        break;
      case TimerMode.endAt:
        if (_endTime != null) {
          final remaining = _endTime!.difference(now).inSeconds;
          _remainingSeconds = remaining < 0 ? 0 : remaining;
          if (_remainingSeconds <= 0) {
            _onSessionComplete();
            return;
          }
        }
        break;
      case TimerMode.unlimited:
        _remainingSeconds = -1;
        break;
    }

    _checkIntervalSounds(now);
    notifyListeners();
  }

  void _checkIntervalSounds(DateTime now) {
    final currentMinute = (_elapsedSeconds ~/ 60);

    if (intervalMinutes > 0) {
      final interval = currentMinute ~/ intervalMinutes;
      if (interval > _lastIntervalMinute &&
          currentMinute % intervalMinutes == 0) {
        _lastIntervalMinute = interval;
        _audioService.playSound(intervalSound);
        _vibrationService.vibrate(intervalVibration);
      }
    }

    if (bellIntervalMinutes > 0) {
      final bellInterval = currentMinute ~/ bellIntervalMinutes;
      if (bellInterval > _lastBellMinute &&
          currentMinute % bellIntervalMinutes == 0) {
        _lastBellMinute = bellInterval;
        _audioService.playSound(bellSound);
      }
    }
  }

  Future<void> _onSessionComplete() async {
    _stopTick();
    
    // Cancel native alarm (already triggered but clean up)
    await _alarmService.cancelAllAlarms();
    await _alarmService.releaseCpuWakeLock();

    _state = TimerState.completed;

    final now = DateTime.now();
    _elapsedSeconds = _totalDurationSeconds;

    await _audioService.playSound(endSound);
    await _vibrationService.vibrate(endVibration);

    final session = MeditationSession(
      id: _currentSessionId ?? const Uuid().v4(),
      startTime: _startTime,
      endTime: now,
      durationSeconds: _elapsedSeconds,
      targetDurationSeconds: _totalDurationSeconds,
      timerMode: _timerMode.asString,
      completed: true,
    );
    await DatabaseService.insertSession(session);

    await PersistenceService.clearActiveSession();

    notifyListeners();
  }

  Future<bool> hasActiveSession() async {
    final session = await PersistenceService.loadActiveSession();
    return session != null;
  }

  void reset() {
    _delayTimer?.cancel();
    _delayTimer = null;
    _stopTick();
    _alarmService.cancelAllAlarms();
    _alarmService.releaseCpuWakeLock();
    _state = TimerState.idle;
    _elapsedSeconds = 0;
    _remainingSeconds = 0;
    _totalDurationSeconds = 0;
    _pauseDurationSeconds = 0;
    _delayRemainingSeconds = 0;
    _currentSessionId = null;
    _lastIntervalMinute = -1;
    _lastBellMinute = -1;
    _alarmFired = false;
    notifyListeners();
  }

  /// Called when the native AlarmManager fires (detected via EventChannel).
  void onNativeAlarmFired(int requestCode) {
    if (_alarmFired) return; // Prevent double-fire
    _alarmFired = true;

    debugPrint('TimerProvider: Native alarm fired with code $requestCode');

    // The native alarm fired while in doze - complete the session
    if (_state == TimerState.running) {
      // Play end sound via native side as a backup (works even in deep sleep)
      _alarmService.playEndSound(soundPath: endSound);
      _onSessionComplete();
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _delayTimer = null;
    _stopTick();
    _alarmService.cancelAllAlarms();
    _alarmService.releaseCpuWakeLock();
    super.dispose();
  }
}
