import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/timer_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/session_provider.dart';
import 'services/persistence_service.dart';
import 'services/widget_action_handler.dart';
import 'services/alarm_service.dart';
import 'services/translation_service.dart';
import 'theme/app_theme.dart';
import 'theme/colors.dart';
import 'screens/home_screen.dart';
import 'screens/meditation_screen.dart';

class MeditationTimerApp extends StatefulWidget {
  const MeditationTimerApp({super.key});

  @override
  State<MeditationTimerApp> createState() => _MeditationTimerAppState();
}

class _MeditationTimerAppState extends State<MeditationTimerApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;
  Map<String, Map<String, String>> _translations = {};
  String _locale = 'en';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (!mounted) return;

    // Load translations first
    try {
      _translations = await TranslationService.loadTranslations();
    } catch (_) {
      _translations = {};
    }

    if (!mounted) return;

    final settingsProvider = context.read<SettingsProvider>();
    await settingsProvider.loadSettings();

    if (!mounted) return;

    _locale = settingsProvider.locale;

    switch (settingsProvider.themeMode) {
      case 'light':
        _themeMode = ThemeMode.light;
      case 'dark':
        _themeMode = ThemeMode.dark;
      default:
        _themeMode = ThemeMode.system;
    }

    final sessionProvider = context.read<SessionProvider>();
    await sessionProvider.loadSessions();

    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const _SplashScreen(),
      );
    }

    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        switch (settings.themeMode) {
          case 'light':
            _themeMode = ThemeMode.light;
          case 'dark':
            _themeMode = ThemeMode.dark;
          default:
            _themeMode = ThemeMode.system;
        }

        if (settings.locale != _locale && _translations.isNotEmpty) {
          _locale = settings.locale;
        }

        final t = TranslationService(
          translations: _translations,
          locale: _locale,
          child: MaterialApp(
            title: 'ekaTimer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _themeMode,
            locale: ui.Locale(_locale),
            home: const _AppEntry(),
          ),
        );

        return t;
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.self_improvement,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'ekaTimer',
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppEntry extends StatefulWidget {
  const _AppEntry();

  @override
  State<_AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<_AppEntry> with WidgetsBindingObserver {
  bool _checkingSession = true;
  bool _hasActiveSession = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkForActiveSession();

    // Wire up native alarm fired callback to handle timer completion
    // even when phone was in deep sleep (doze mode)
    final alarmService = AlarmService();
    alarmService.onAlarmFired = (requestCode) {
      final timerProvider = context.read<TimerProvider>();
      timerProvider.onNativeAlarmFired(requestCode);
    };

    // Listen for exact alarm permission changes (Android 12+)
    // When user grants permission in Settings, retry scheduling the alarm
    alarmService.onPermissionChanged = (hasPermission) {
      if (hasPermission && mounted) {
        final timerProvider = context.read<TimerProvider>();
        timerProvider.onExactAlarmPermissionGranted();
      }
    };

    // Listen for immediate widget action notifications from iOS
    // (triggers even when app is already foregrounded)
    WidgetActionHandler.setupListener(
      context,
      onSessionStarted: () {
        if (mounted) setState(() => _hasActiveSession = true);
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_checkingSession && mounted) {
      // Re-check for widget actions when app returns to foreground
      // (e.g. user tapped a quick-start widget while app was backgrounded)
      WidgetActionHandler.handleWidgetAction(context).then((handled) {
        if (handled && mounted) {
          setState(() => _hasActiveSession = true);
        }
      });
    }
  }

  Future<void> _checkForActiveSession() async {
    final timerProvider = context.read<TimerProvider>();
    final hasSession = await timerProvider.hasActiveSession();

    if (hasSession && mounted) {
      final sessionData = await PersistenceService.loadActiveSession();
      if (sessionData != null && mounted) {
        await timerProvider.restoreSession(sessionData);
        setState(() {
          _hasActiveSession = true;
          _checkingSession = false;
        });
        return;
      }
    }

    if (mounted) {
      // Check if app was launched by a widget tap (quick-start action)
      final handledWidgetAction = await WidgetActionHandler.handleWidgetAction(
        context,
      );
      if (handledWidgetAction) {
        setState(() {
          _hasActiveSession = true;
          _checkingSession = false;
        });
        return;
      }
    }

    if (mounted) {
      setState(() => _checkingSession = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingSession) {
      return const _SplashScreen();
    }

    if (_hasActiveSession) {
      return const MeditationScreen();
    }

    return const MeditationHomeScreen();
  }
}
