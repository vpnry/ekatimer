import 'timer_mode.dart';
import 'sound_config.dart';
import 'vibration_config.dart';

class AppSettings {
  final TimerMode defaultTimerMode;
  final int defaultDurationMinutes;
  final String screenControl;
  final String themeMode;
  final String locale;
  final SoundConfig soundConfig;
  final VibrationConfig vibrationConfig;
  final bool transparentWidget;
  final int sessionDelaySeconds;
  const AppSettings({
    this.defaultTimerMode = TimerMode.timed,
    this.defaultDurationMinutes = 60,
    this.screenControl = 'deviceTimeOut',
    this.themeMode = 'deviceTheme',
    this.locale = 'system',
    this.soundConfig = const SoundConfig(),
    this.vibrationConfig = const VibrationConfig(),
    this.transparentWidget = true,
    this.sessionDelaySeconds = 0,
  });

  AppSettings copyWith({
    TimerMode? defaultTimerMode,
    int? defaultDurationMinutes,
    String? screenControl,
    String? themeMode,
    String? locale,
    SoundConfig? soundConfig,
    VibrationConfig? vibrationConfig,
    bool? transparentWidget,
    int? sessionDelaySeconds,
  }) {
    return AppSettings(
      defaultTimerMode: defaultTimerMode ?? this.defaultTimerMode,
      defaultDurationMinutes:
          defaultDurationMinutes ?? this.defaultDurationMinutes,
      screenControl: screenControl ?? this.screenControl,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      soundConfig: soundConfig ?? this.soundConfig,
      vibrationConfig: vibrationConfig ?? this.vibrationConfig,
      transparentWidget: transparentWidget ?? this.transparentWidget,
      sessionDelaySeconds: sessionDelaySeconds ?? this.sessionDelaySeconds,
    );
  }
}
