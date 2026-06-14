class AppConstants {
  AppConstants._();

  static const String appName = 'ekaTimer';
  static const String appVersion = '1.0.0';

  static const int defaultTimerDurationMinutes = 60;
  static const int minTimerDurationMinutes = 1;
  static const int maxTimerDurationMinutes = 600;
  static const int timerTickIntervalMs = 500;

  static const String databaseName = 'meditation_timer.db';
  static const int databaseVersion = 1;

  static const String prefTimerMode = 'timer_mode';
  static const String prefTimerDuration = 'timer_duration';
  static const String prefScreenControl = 'screen_control_preference';
  static const String prefThemeMode = 'theme_mode_preference';
  static const String prefStartSound = 'start_sound';
  static const String prefEndSound = 'end_sound';
  static const String prefIntervalSound = 'interval_sound';
  static const String prefIntervalMinutes = 'interval_minutes';
  static const String prefStartVibration = 'start_vibration';
  static const String prefEndVibration = 'end_vibration';
  static const String prefIntervalVibration = 'interval_vibration';
  static const String prefVibrationIntervalMinutes = 'vibration_interval_minutes';
  static const String prefLocale = 'locale';
  static const String prefSessionDelay = 'session_delay';
  static const String prefSessionVolume = 'session_volume';
  static const String prefActiveSession = 'active_session';
  static const String prefRecentDurations = 'recent_durations';
  static const String prefFixedHourPresets = 'fixed_hour_presets';
  static const String prefTransparentWidget = 'transparent_widget';

  static const String sessionStateStartTime = 'session_start_time';
  static const String sessionStateDuration = 'session_duration';
  static const String sessionStateMode = 'session_mode';
  static const String sessionStateIsPaused = 'session_is_paused';
  static const String sessionStatePauseDuration = 'session_pause_duration';
  static const String sessionStateEndTime = 'session_end_time';

  static const List<String> builtInSounds = [
    'Sadhu',
    'Bowl',
    'ThreeBowl',
    'BowlStrong',
    'Gong',
    'GardenBird',
    'Bell',
    'Watch',
  ];

  static const Map<String, String> soundLabels = {
    'Sadhu': 'Sādhu',
    'Bowl': 'Bowl',
    'ThreeBowl': 'Three Bowl',
    'BowlStrong': 'Strong Bowl',
    'Gong': 'Gong',
    'GardenBird': 'Garden Bird',
    'Bell': 'Bell',
    'Watch': 'Watch',
    'none': 'None',
  };

  static const List<String> vibrationOptions = [
    'none',
    'short',
    'medium',
    'long',
    'double',
  ];

  static const Map<String, String> vibrationLabels = {
    'none': 'None',
    'short': 'Short',
    'medium': 'Medium',
    'long': 'Long',
    'double': 'Double',
  };

  static const Map<String, String> screenControlLabels = {
    'deviceTimeOut': 'Device Settings',
    'on': 'Stay On',
    'dim': 'Dim',
  };

  static const Map<String, String> themeModeLabels = {
    'deviceTheme': 'Device Theme',
    'light': 'Light',
    'dark': 'Dark',
  };

  static const List<int> intervalOptions = [1, 2, 3, 5, 10, 15, 20, 30, 45, 60];
  static const List<int> durationPresets = [5, 10, 15, 20, 30, 45, 60];
}
