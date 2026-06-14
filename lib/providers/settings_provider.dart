import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../models/timer_mode.dart';
import '../models/sound_config.dart';
import '../models/vibration_config.dart';
import '../services/persistence_service.dart';
import '../services/widget_action_handler.dart';

class SettingsProvider extends ChangeNotifier {
  AppSettings _settings = const AppSettings();

  AppSettings get settings => _settings;

  TimerMode get defaultTimerMode => _settings.defaultTimerMode;
  int get defaultDurationMinutes => _settings.defaultDurationMinutes;
  String get screenControl => _settings.screenControl;
  String get themeMode => _settings.themeMode;
  SoundConfig get soundConfig => _settings.soundConfig;
  VibrationConfig get vibrationConfig => _settings.vibrationConfig;
  int get sessionDelaySeconds => _settings.sessionDelaySeconds;
  bool get transparentWidget => _settings.transparentWidget;
  String get locale => _settings.locale;

  Future<void> loadSettings() async {
    _settings = await PersistenceService.loadSettings();
    notifyListeners();
  }

  Future<void> setTimerMode(TimerMode mode) async {
    _settings = _settings.copyWith(defaultTimerMode: mode);
    await PersistenceService.setTimerMode(mode.asString);
    notifyListeners();
  }

  Future<void> setTimerDuration(int minutes) async {
    _settings = _settings.copyWith(defaultDurationMinutes: minutes);
    await PersistenceService.setTimerDuration(minutes);
    notifyListeners();
  }

  Future<void> setScreenControl(String control) async {
    _settings = _settings.copyWith(screenControl: control);
    await PersistenceService.setScreenControl(control);
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _settings = _settings.copyWith(themeMode: mode);
    await PersistenceService.setThemeMode(mode);
    notifyListeners();
  }

  Future<void> setStartSound(String sound) async {
    final updated = _settings.soundConfig.copyWith(startSound: sound);
    _settings = _settings.copyWith(soundConfig: updated);
    await PersistenceService.setStartSound(sound);
    notifyListeners();
  }

  Future<void> setEndSound(String sound) async {
    final updated = _settings.soundConfig.copyWith(endSound: sound);
    _settings = _settings.copyWith(soundConfig: updated);
    await PersistenceService.setEndSound(sound);
    notifyListeners();
  }

  Future<void> setIntervalSound(String sound) async {
    final updated = _settings.soundConfig.copyWith(intervalSound: sound);
    _settings = _settings.copyWith(soundConfig: updated);
    await PersistenceService.setIntervalSound(sound);
    notifyListeners();
  }

  Future<void> setIntervalMinutes(int minutes) async {
    final updated = _settings.soundConfig.copyWith(intervalMinutes: minutes);
    _settings = _settings.copyWith(soundConfig: updated);
    await PersistenceService.setIntervalMinutes(minutes);
    notifyListeners();
  }

  Future<void> setVolume(int volume) async {
    final updated = _settings.soundConfig.copyWith(volume: volume);
    _settings = _settings.copyWith(soundConfig: updated);
    await PersistenceService.setVolume(volume);
    notifyListeners();
  }

  Future<void> setStartVibration(String vib) async {
    final updated = _settings.vibrationConfig.copyWith(startVibration: vib);
    _settings = _settings.copyWith(vibrationConfig: updated);
    await PersistenceService.setStartVibration(vib);
    notifyListeners();
  }

  Future<void> setEndVibration(String vib) async {
    final updated = _settings.vibrationConfig.copyWith(endVibration: vib);
    _settings = _settings.copyWith(vibrationConfig: updated);
    await PersistenceService.setEndVibration(vib);
    notifyListeners();
  }

  Future<void> setIntervalVibration(String vib) async {
    final updated = _settings.vibrationConfig.copyWith(intervalVibration: vib);
    _settings = _settings.copyWith(vibrationConfig: updated);
    await PersistenceService.setIntervalVibration(vib);
    notifyListeners();
  }

  Future<void> setVibrationIntervalMinutes(int minutes) async {
    final updated =
        _settings.vibrationConfig.copyWith(intervalMinutes: minutes);
    _settings = _settings.copyWith(vibrationConfig: updated);
    await PersistenceService.setVibrationIntervalMinutes(minutes);
    notifyListeners();
  }

  Future<void> setSessionDelay(int seconds) async {
    _settings = _settings.copyWith(sessionDelaySeconds: seconds);
    await PersistenceService.setSessionDelay(seconds);
    notifyListeners();
  }

  Future<void> setTransparentWidget(bool enabled) async {
    _settings = _settings.copyWith(transparentWidget: enabled);
    await PersistenceService.setTransparentWidget(enabled);
    // Trigger Android widget refresh directly with the current value
    await WidgetActionHandler.updateAllWidgets(transparent: enabled);
    notifyListeners();
  }

  Future<void> setLocale(String locale) async {
    _settings = _settings.copyWith(locale: locale);
    await PersistenceService.setLocale(locale);
    notifyListeners();
  }

}
