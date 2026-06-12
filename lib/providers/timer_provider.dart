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

  int intervalMinutes = 0;
  String startSound = 'none';
  String endSound = 'ThreeBowl';
  String intervalSound = 'Bowl';
  String startVibration = 'none';
  String endVibration = 'none';
  String intervalVibration = 'none';
  int volume = 80;

  int sessionDelaySeconds = 0;
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
        } else if (_timerMode == TimerMode.endAt) {
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

    if (_endTime != null) {
      final alarmId = _timerMode == TimerMode.timed ? 1001 : 1002;
      await _alarmService.scheduleEndAlarm(
        id: alarmId,
        dateTime: _endTime!,
        assetAudioPath: _assetPath(endSound),
        vibrate: endVibration != 'none',
        volume: volume / 100.0,
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
    final alarmId = _timerMode == TimerMode.timed ? 1001 : 1002;
    await _alarmService.cancelAlarm(alarmId);
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

    if (_endTime != null) {
      final alarmId = _timerMode == TimerMode.timed ? 1001 : 1002;
      await _alarmService.scheduleEndAlarm(
        id: alarmId,
        dateTime: _endTime!,
        assetAudioPath: _assetPath(endSound),
        vibrate: endVibration != 'none',
        volume: volume / 100.0,
      );
    }

    _startTick();
    await _persistSessionState();
    notifyListeners();
  }

  Future<void> stopSession({bool completed = true}) async {
    _stopTick();

    await _alarmService.cancelAllAlarms();

    final now = DateTime.now();
    _elapsedSeconds = _calculateElapsedSeconds(now);
    _state = TimerState.completed;

    // When user stops early (completed: false), skip end sound/vibration
    // so they can leave quietly (e.g., in a group meditation).
    if (completed) {
      await _audioService.playSound(endSound);
      await _vibrationService.vibrate(endVibration);
    }

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
    startSound = settings.soundConfig.startSound;
    endSound = settings.soundConfig.endSound;
    intervalSound = settings.soundConfig.intervalSound;
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

    if (isPaused) {
      _pauseStartTime = DateTime.now();
    }

    final now = DateTime.now();
    _elapsedSeconds = _calculateElapsedSeconds(now);

    if (_timerMode == TimerMode.timed && _endTime != null) {
      _remainingSeconds = _endTime!.difference(now).inSeconds;
    }

    _lastIntervalMinute = -1;

    if (!isPaused) {
      if (_endTime != null && _endTime!.millisecondsSinceEpoch > 0) {
        if (_endTime!.isBefore(DateTime.now())) {
          await _onSessionComplete(silent: true);
          return;
        }

        final alarmId = _timerMode == TimerMode.timed ? 1001 : 1002;
        await _alarmService.scheduleEndAlarm(
          id: alarmId,
          dateTime: _endTime!,
          assetAudioPath: _assetPath(endSound),
          vibrate: endVibration != 'none',
          volume: volume / 100.0,
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
    if (_alarmFired) return;

    final now = DateTime.now();
    _elapsedSeconds = _calculateElapsedSeconds(now);

    switch (_timerMode) {
      case TimerMode.timed:
        if (_endTime != null) {
          final remaining = _endTime!.difference(now).inSeconds;
          _remainingSeconds = remaining < 0 ? 0 : remaining;
          if (_remainingSeconds <= 0) {
            _onSessionComplete(silent: false);
            return;
          }
        }
        break;
      case TimerMode.endAt:
        if (_endTime != null) {
          final remaining = _endTime!.difference(now).inSeconds;
          _remainingSeconds = remaining < 0 ? 0 : remaining;
          if (_remainingSeconds <= 0) {
            _onSessionComplete(silent: false);
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

  /// Convert a bare sound name (e.g. "ThreeBowl") to the asset path
  /// expected by [AlarmService].
  String? _assetPath(String soundName) {
    if (soundName.isEmpty || soundName == 'none') return null;
    return 'assets/sounds/$soundName.wav';
  }

  void _checkIntervalSounds(DateTime now) {
    if (intervalMinutes <= 0) return;

    final currentMinute = (_elapsedSeconds ~/ 60);

    // Do not play interval sounds at the very start (minute 0).
    // They should only play after the configured interval has elapsed
    // (e.g., a 3-minute interval first plays at minute 3, not minute 0).
    if (currentMinute == 0) return;

    // Auto-disable: interval won't fire if it's >= total session duration (timed mode).
    if (_timerMode == TimerMode.timed && _durationMinutes > 0 &&
        intervalMinutes >= _durationMinutes) {
      return;
    }

    final interval = currentMinute ~/ intervalMinutes;
    if (interval > _lastIntervalMinute &&
        currentMinute % intervalMinutes == 0) {
      _lastIntervalMinute = interval;
      _audioService.playSound(intervalSound);
      _vibrationService.vibrate(intervalVibration);
    }
  }

  Future<void> _onSessionComplete({bool silent = false}) async {
    if (_alarmFired) return;
    _alarmFired = true;

    _stopTick();

    _state = TimerState.completed;

    final now = DateTime.now();
    _elapsedSeconds = _totalDurationSeconds;

    if (!silent) {
      await _audioService.playSound(endSound);
      await _vibrationService.vibrate(endVibration);
      await _alarmService.cancelAllAlarms();
    }

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

  void reset({bool cancelAlarms = true}) {
    _delayTimer?.cancel();
    _delayTimer = null;
    _stopTick();
    if (cancelAlarms) {
      _alarmService.cancelAllAlarms();
    }
    _state = TimerState.idle;
    _elapsedSeconds = 0;
    _remainingSeconds = 0;
    _totalDurationSeconds = 0;
    _pauseDurationSeconds = 0;
    _delayRemainingSeconds = 0;
    _currentSessionId = null;
    _lastIntervalMinute = -1;
    _alarmFired = false;
    notifyListeners();
  }

  Future<void> stopSounds() async {
    await _audioService.stop();
    await _vibrationService.cancel();
  }

  /// Called when the alarm package fires (Alarm.ringing stream).
  /// The alarm package handles audio & vibration natively — just record completion.
  void onNativeAlarmFired(int requestCode) {
    debugPrint('TimerProvider: Native alarm fired with code $requestCode');

    if (_state == TimerState.running) {
      _onSessionComplete(silent: true);
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _delayTimer = null;
    _stopTick();
    _alarmService.cancelAllAlarms();
    super.dispose();
  }
}
