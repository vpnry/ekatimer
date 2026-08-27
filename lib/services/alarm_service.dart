import 'dart:async';
import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';
import 'package:alarm/alarm.dart';

class AlarmService {
  static const int _timedAlarmId = 1001;
  static const int _endAtAlarmId = 1002;
  static const int _unlimitedKeepAliveAlarmId = 1003;

  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  bool _initialized = false;
  StreamSubscription<dynamic>? _ringingSubscription;

  void Function(int alarmId)? onAlarmFired;

  Future<void> init() async {
    if (_initialized) return;
    await Alarm.init();
    _ringingSubscription = Alarm.ringing.listen((dynamic alarmSet) {
      // alarmSet is an AlarmSet instance from the alarm package
      final alarms = alarmSet?.alarms;
      if (alarms == null) return;
      for (final alarm in alarms) {
        debugPrint('AlarmService: alarm ringing id=${alarm.id}');
        onAlarmFired?.call(alarm.id as int);
      }
    });
    _initialized = true;
  }

  Future<bool> scheduleEndAlarm({
    required int id,
    required DateTime dateTime,
    double volume = 0.8,
    String? assetAudioPath,
    bool vibrate = true,
  }) async {
    try {
      final alarmSettings = AlarmSettings(
        id: id,
        dateTime: dateTime,
        assetAudioPath: assetAudioPath,
        loopAudio: false,
        vibrate: vibrate,
        warningNotificationOnKill: true,
        androidFullScreenIntent: true,
        androidStopAlarmOnTermination: false,
        allowAlarmOverlap: true,
        volumeSettings: VolumeSettings.fixed(volume: volume),
        notificationSettings: const NotificationSettings(
          title: 'Meditation Complete',
          body: 'Your meditation session has ended.',
          // Without this the package falls back to the launcher icon, which
          // Android reduces to its alpha channel and draws as a solid white
          // block. See res/drawable/ic_lotus.xml.
          icon: 'ic_lotus',
          iconColor: Color(0xFF176B6B),
        ),
      );
      await Alarm.set(alarmSettings: alarmSettings);
      return true;
    } catch (e) {
      debugPrint('AlarmService: scheduleEndAlarm failed: $e');
      return false;
    }
  }

  Future<void> cancelAlarm(int id) async {
    try {
      await Alarm.stop(id);
    } catch (e) {
      debugPrint('AlarmService: cancelAlarm($id) failed: $e');
    }
  }

  Future<void> cancelAllAlarms() async {
    await cancelAlarm(_timedAlarmId);
    await cancelAlarm(_endAtAlarmId);
    await cancelAlarm(_unlimitedKeepAliveAlarmId);
  }

  void dispose() {
    _ringingSubscription?.cancel();
    _ringingSubscription = null;
    _initialized = false;
  }
}
