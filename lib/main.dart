import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/timer_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/session_provider.dart';
import 'services/audio_service.dart';
import 'services/vibration_service.dart';
import 'services/notification_service.dart';
import 'services/alarm_service.dart';
import 'services/widget_data_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await AudioService().init();
  await VibrationService().init();
  await NotificationService().init();
  await AlarmService().init();

  // Request permissions on startup
  await _requestPermissions();

  // Initialize widget data service for home screen / lock screen widgets
  await WidgetDataService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
      ],
      child: const MeditationTimerApp(),
    ),
  );
}

Future<void> _requestPermissions() async {
  try {
    // Request notification permission for Android 13+
    final notificationService = NotificationService();
    await notificationService.requestPermissions();

    // Check and request exact alarm permission
    final alarmService = AlarmService();
    final hasPermission = await alarmService.hasExactAlarmPermission();
    if (!hasPermission) {
      debugPrint('main: Exact alarm permission not granted, requesting...');
      await alarmService.requestExactAlarmPermission();
    }
  } catch (e) {
    debugPrint('main: Failed to request permissions: $e');
  }
}
