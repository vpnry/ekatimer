import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Service that interfaces with native platform alarm mechanisms.
///
/// **Android**: Uses AlarmManager with setExactAndAllowWhileIdle() + PARTIAL_WAKE_LOCK
/// to wake the device from doze mode when the timer ends.
///
/// **iOS**: Uses background audio task + local notification + BGTaskScheduler
/// to handle timer end when app is backgrounded or screen is off.
class AlarmService {
  static const MethodChannel _channel =
      MethodChannel('org.tipitakapali.ekatimer/alarm');

  static const EventChannel _eventChannel =
      EventChannel('org.tipitakapali.ekatimer/alarm_events');

  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  bool _initialized = false;
  StreamSubscription<dynamic>? _eventSubscription;

  /// Callback invoked when a native alarm fires (e.g., end timer reached).
  void Function(int requestCode)? onAlarmFired;

  Future<void> init() async {
    if (_initialized) return;

    // Listen for native alarm events (AlarmManager on Android wakes from doze)
    _eventSubscription = _eventChannel
        .receiveBroadcastStream()
        .listen((dynamic event) {
      if (event is Map) {
        final requestCode = event['requestCode'] as int?;
        if (requestCode != null && onAlarmFired != null) {
          onAlarmFired!(requestCode);
        }
      }
    }, onError: (dynamic error) {
      debugPrint('AlarmService: EventChannel error: $error');
    });

    _initialized = true;
  }

  /// Acquire a PARTIAL_WAKE_LOCK (Android) or background task (iOS)
  /// so the CPU stays on even when screen is off.
  Future<bool> acquireCpuWakeLock() async {
    try {
      await _channel.invokeMethod('acquireCpuWakeLock');
      return true;
    } catch (e) {
      debugPrint('AlarmService: acquireCpuWakeLock failed: $e');
      return false;
    }
  }

  /// Release the CPU wake lock / background task.
  Future<bool> releaseCpuWakeLock() async {
    try {
      await _channel.invokeMethod('releaseCpuWakeLock');
      return true;
    } catch (e) {
      debugPrint('AlarmService: releaseCpuWakeLock failed: $e');
      return false;
    }
  }

  /// Schedule an exact alarm that wakes the device from doze mode.
  ///
  /// [delaySeconds] - seconds from now to fire the alarm.
  /// [endTimeMillis] - absolute epoch millis for when to fire (alternative to delay).
  /// [requestCode] - unique integer to identify this alarm.
  /// [soundPath] - path to the end sound to play natively when alarm fires (Android only).
  Future<bool> scheduleEndAlarm({
    int? delaySeconds,
    int? endTimeMillis,
    int requestCode = 1001,
    String soundPath = '',
  }) async {
    try {
      await _channel.invokeMethod('scheduleEndAlarm', {
        'delaySeconds': delaySeconds ?? 0,
        'endTimeMillis': endTimeMillis ?? 0,
        'requestCode': requestCode,
        'soundPath': soundPath,
      });
      return true;
    } catch (e) {
      debugPrint('AlarmService: scheduleEndAlarm failed: $e');
      return false;
    }
  }

  /// Cancel a previously scheduled alarm.
  Future<bool> cancelEndAlarm({int requestCode = 1001}) async {
    try {
      await _channel.invokeMethod('cancelEndAlarm', {
        'requestCode': requestCode,
      });
      return true;
    } catch (e) {
      debugPrint('AlarmService: cancelEndAlarm failed: $e');
      return false;
    }
  }

  /// Cancel all scheduled alarms.
  Future<bool> cancelAllAlarms() async {
    try {
      await _channel.invokeMethod('cancelAllAlarms');
      return true;
    } catch (e) {
      debugPrint('AlarmService: cancelAllAlarms failed: $e');
      return false;
    }
  }

  /// Play the end sound natively (works even when app is in background).
  Future<bool> playEndSound({String soundPath = ''}) async {
    try {
      await _channel.invokeMethod('playEndSound', {
        'soundPath': soundPath,
      });
      return true;
    } catch (e) {
      debugPrint('AlarmService: playEndSound failed: $e');
      return false;
    }
  }

  void dispose() {
    _eventSubscription?.cancel();
    _eventSubscription = null;
  }
}