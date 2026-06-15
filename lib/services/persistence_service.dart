import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';
import '../models/timer_mode.dart';
import '../models/sound_config.dart';
import '../models/vibration_config.dart';
import '../utils/constants.dart';

class PersistenceService {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  static Future<AppSettings> loadSettings() async {
    final p = await prefs;

    return AppSettings(
      defaultTimerMode: TimerMode.fromString(
        p.getString(AppConstants.prefTimerMode) ?? 'timed',
      ),
      defaultDurationMinutes:
          p.getInt(AppConstants.prefTimerDuration) ??
          AppConstants.defaultTimerDurationMinutes,
      screenControl:
          p.getString(AppConstants.prefScreenControl) ?? 'deviceTimeOut',
      themeMode: p.getString(AppConstants.prefThemeMode) ?? 'deviceTheme',
      soundConfig: SoundConfig(
        startSound: p.getString(AppConstants.prefStartSound) ?? 'none',
        endSound: p.getString(AppConstants.prefEndSound) ?? 'ThreeBowl',
        intervalSound: p.getString(AppConstants.prefIntervalSound) ?? 'Bowl',
        intervalMinutes: p.getInt(AppConstants.prefIntervalMinutes) ?? 0,
        volume: p.getInt(AppConstants.prefSessionVolume) ?? 80,
      ),
      vibrationConfig: VibrationConfig(
        startVibration: p.getString(AppConstants.prefStartVibration) ?? 'none',
        endVibration: p.getString(AppConstants.prefEndVibration) ?? 'medium',
        intervalVibration:
            p.getString(AppConstants.prefIntervalVibration) ?? 'none',
        intervalMinutes:
            p.getInt(AppConstants.prefVibrationIntervalMinutes) ?? 0,
      ),
      transparentWidget: p.getBool(AppConstants.prefTransparentWidget) ?? false,
      sessionDelaySeconds: p.getInt(AppConstants.prefSessionDelay) ?? 0,
      locale: p.getString(AppConstants.prefLocale) ?? 'system',

    );
  }

  static Future<void> saveString(String key, String value) async {
    final p = await prefs;
    await p.setString(key, value);
  }

  static Future<void> saveInt(String key, int value) async {
    final p = await prefs;
    await p.setInt(key, value);
  }

  static Future<void> saveBool(String key, bool value) async {
    final p = await prefs;
    await p.setBool(key, value);
  }

  static Future<void> setTimerMode(String mode) async =>
      saveString(AppConstants.prefTimerMode, mode);

  static Future<void> setTimerDuration(int minutes) async =>
      saveInt(AppConstants.prefTimerDuration, minutes);

  static Future<void> setScreenControl(String control) async =>
      saveString(AppConstants.prefScreenControl, control);

  static Future<void> setThemeMode(String mode) async =>
      saveString(AppConstants.prefThemeMode, mode);

  static Future<void> setSessionDelay(int seconds) async =>
      saveInt(AppConstants.prefSessionDelay, seconds);

  static Future<void> setStartSound(String sound) async =>
      saveString(AppConstants.prefStartSound, sound);

  static Future<void> setEndSound(String sound) async =>
      saveString(AppConstants.prefEndSound, sound);

  static Future<void> setIntervalSound(String sound) async =>
      saveString(AppConstants.prefIntervalSound, sound);

  static Future<void> setIntervalMinutes(int minutes) async =>
      saveInt(AppConstants.prefIntervalMinutes, minutes);

  static Future<void> setVolume(int volume) async =>
      saveInt(AppConstants.prefSessionVolume, volume);

  static Future<void> setStartVibration(String vib) async =>
      saveString(AppConstants.prefStartVibration, vib);

  static Future<void> setEndVibration(String vib) async =>
      saveString(AppConstants.prefEndVibration, vib);

  static Future<void> setIntervalVibration(String vib) async =>
      saveString(AppConstants.prefIntervalVibration, vib);

  static Future<void> setVibrationIntervalMinutes(int minutes) async =>
      saveInt(AppConstants.prefVibrationIntervalMinutes, minutes);

  static Future<void> setTransparentWidget(bool enabled) async =>
      saveBool(AppConstants.prefTransparentWidget, enabled);

  static Future<void> setLocale(String locale) async =>
      saveString(AppConstants.prefLocale, locale);

  static Future<void> saveUserQuotes(String quotesJson) async =>
      saveString(AppConstants.prefUserQuotes, quotesJson);

  static Future<String?> loadUserQuotes() async {
    final p = await prefs;
    final json = p.getString(AppConstants.prefUserQuotes);
    return (json != null && json.isNotEmpty) ? json : null;
  }

  static Future<void> clearUserQuotes() async {
    final p = await prefs;
    await p.remove(AppConstants.prefUserQuotes);
  }

  static Future<void> saveActiveSession({
    required int startTime,
    required int durationSeconds,
    required String mode,
    required bool isPaused,
    required int pauseDuration,
    required int endTime,
    int? pauseStartTime,
  }) async {
    final p = await prefs;
    await p.setInt(AppConstants.sessionStateStartTime, startTime);
    await p.setInt(AppConstants.sessionStateDuration, durationSeconds);
    await p.setString(AppConstants.sessionStateMode, mode);
    await p.setBool(AppConstants.sessionStateIsPaused, isPaused);
    await p.setInt(AppConstants.sessionStatePauseDuration, pauseDuration);
    await p.setInt(AppConstants.sessionStateEndTime, endTime);
    if (pauseStartTime != null) {
      await p.setInt(AppConstants.sessionStatePauseStartTime, pauseStartTime);
    } else {
      await p.remove(AppConstants.sessionStatePauseStartTime);
    }
  }

  static Future<Map<String, int>?> loadActiveSession() async {
    final p = await prefs;
    final startTime = p.getInt(AppConstants.sessionStateStartTime);
    if (startTime == null) return null;

    return {
      'startTime': startTime,
      'durationSeconds': p.getInt(AppConstants.sessionStateDuration) ?? 0,
      'pauseDuration': p.getInt(AppConstants.sessionStatePauseDuration) ?? 0,
      'endTime': p.getInt(AppConstants.sessionStateEndTime) ?? 0,
      'pauseStartTime': p.getInt(AppConstants.sessionStatePauseStartTime) ?? 0,
    };
  }

  static Future<String?> loadActiveSessionMode() async {
    final p = await prefs;
    return p.getString(AppConstants.sessionStateMode);
  }

  static Future<bool> loadActiveSessionIsPaused() async {
    final p = await prefs;
    return p.getBool(AppConstants.sessionStateIsPaused) ?? false;
  }

  static Future<void> clearActiveSession() async {
    final p = await prefs;
    await p.remove(AppConstants.sessionStateStartTime);
    await p.remove(AppConstants.sessionStateDuration);
    await p.remove(AppConstants.sessionStateMode);
    await p.remove(AppConstants.sessionStateIsPaused);
    await p.remove(AppConstants.sessionStatePauseDuration);
    await p.remove(AppConstants.sessionStateEndTime);
    await p.remove(AppConstants.sessionStatePauseStartTime);
  }

  static Future<List<int>> loadRecentDurations() async {
    final p = await prefs;
    final json = p.getString(AppConstants.prefRecentDurations);
    if (json == null || json.isEmpty) return [15, 30, 45, 60];
    return json
        .split(',')
        .map((s) => int.tryParse(s) ?? 0)
        .where((v) => v > 0)
        .toList();
  }

  static Future<void> saveRecentDurations(List<int> durations) async {
    final p = await prefs;
    await p.setString(AppConstants.prefRecentDurations, durations.join(','));
  }

  static Future<List<int>> loadFixedHourPresets() async {
    final p = await prefs;
    final json = p.getString(AppConstants.prefFixedHourPresets);
    if (json == null || json.isEmpty) return [60, 90, 120, 180];
    return json
        .split(',')
        .map((s) => int.tryParse(s) ?? 60)
        .where((v) => v >= 1 && v <= 100800)
        .toList();
  }

  static Future<void> saveFixedHourPresets(List<int> presets) async {
    final p = await prefs;
    await p.setString(AppConstants.prefFixedHourPresets, presets.join(','));
  }
}
