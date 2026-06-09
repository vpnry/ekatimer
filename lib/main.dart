import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
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

  // Request notification permission on startup
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
    final notificationService = NotificationService();
    await notificationService.requestPermissions();

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.scheduleExactAlarm.status;
      if (status.isDenied) {
        debugPrint('main: SCHEDULE_EXACT_ALARM not granted, requesting...');
        await Permission.scheduleExactAlarm.request();
      }
    }
  } catch (e) {
    debugPrint('main: Failed to request permissions: $e');
  }
}
