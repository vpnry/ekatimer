import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/app_settings.dart';
import '../models/user_profile.dart';
import '../models/timer_mode.dart';
import '../models/sound_config.dart';
import '../models/vibration_config.dart';
import '../services/persistence_service.dart';
import '../services/widget_action_handler.dart';

class SettingsProvider extends ChangeNotifier {
  AppSettings _settings = const AppSettings();
  List<UserProfile> _profiles = const [
    UserProfile(id: UserProfile.defaultId, name: 'Meditator'),
  ];
  String _activeProfileId = UserProfile.defaultId;

  AppSettings get settings => _settings;

  TimerMode get defaultTimerMode => _settings.defaultTimerMode;
  int get defaultDurationMinutes => _settings.defaultDurationMinutes;
  String get screenControl => _settings.screenControl;
  String get themeMode => _settings.themeMode;
  SoundConfig get soundConfig => _settings.soundConfig;
  VibrationConfig get vibrationConfig => _settings.vibrationConfig;
  int get sessionDelaySeconds => _settings.sessionDelaySeconds;
  bool get transparentWidget => _settings.transparentWidget;
  bool get showQuotes => _settings.showQuotes;
  String get locale => _settings.locale;
  List<UserProfile> get profiles => List.unmodifiable(_profiles);
  String get activeProfileId => _activeProfileId;
  UserProfile get activeProfile => _profiles.firstWhere(
    (profile) => profile.id == _activeProfileId,
    orElse: () => _profiles.first,
  );
  String get userName => activeProfile.name;

  Future<void> loadSettings() async {
    _settings = await PersistenceService.loadSettings();
    _profiles = await PersistenceService.loadUserProfiles();
    _activeProfileId = await PersistenceService.loadActiveProfileId();
    if (!_profiles.any((profile) => profile.id == _activeProfileId)) {
      _activeProfileId = _profiles.first.id;
      await PersistenceService.setActiveProfileId(_activeProfileId);
    }
    _settings = _settings.copyWith(userName: activeProfile.name);
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
    final updated = _settings.vibrationConfig.copyWith(
      intervalMinutes: minutes,
    );
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

  Future<void> setShowQuotes(bool enabled) async {
    _settings = _settings.copyWith(showQuotes: enabled);
    await PersistenceService.setShowQuotes(enabled);
    notifyListeners();
  }

  Future<void> setLocale(String locale) async {
    _settings = _settings.copyWith(locale: locale);
    await PersistenceService.setLocale(locale);
    notifyListeners();
  }

  // ---- Multi-profile management ----------------------------------
  // A profile is just an id + display name; all session data is looked
  // up by the active profile's id elsewhere (see SessionProvider,
  // DatabaseService). Every mutation here re-saves the full profile
  // list and, if it touches the active profile, mirrors the change into
  // AppSettings.userName so existing UI reading settings.userName stays
  // correct without change.

  Future<void> setUserName(String name) async {
    await renameUserProfile(_activeProfileId, name);
  }

  Future<UserProfile> addUserProfile(String name) async {
    final normalized = _validatedProfileName(name);
    _ensureUniqueProfileName(normalized);
    final profile = UserProfile(id: const Uuid().v4(), name: normalized);
    _profiles = [..._profiles, profile];
    await PersistenceService.saveUserProfiles(_profiles);
    await selectUserProfile(profile.id);
    return profile;
  }

  Future<void> selectUserProfile(String profileId) async {
    final profile = _profiles.firstWhere(
      (candidate) => candidate.id == profileId,
      orElse: () =>
          throw ArgumentError.value(profileId, 'profileId', 'Unknown profile'),
    );
    _activeProfileId = profile.id;
    _settings = _settings.copyWith(userName: profile.name);
    await PersistenceService.setActiveProfileId(profile.id);
    await PersistenceService.setUserName(profile.name);
    notifyListeners();
  }

  Future<void> renameUserProfile(String profileId, String name) async {
    final normalized = _validatedProfileName(name);
    _ensureUniqueProfileName(normalized, exceptId: profileId);
    var found = false;
    _profiles = _profiles.map((profile) {
      if (profile.id != profileId) return profile;
      found = true;
      return profile.copyWith(name: normalized);
    }).toList();
    if (!found) {
      throw ArgumentError.value(profileId, 'profileId', 'Unknown profile');
    }
    await PersistenceService.saveUserProfiles(_profiles);
    if (profileId == _activeProfileId) {
      _settings = _settings.copyWith(userName: normalized);
      await PersistenceService.setUserName(normalized);
    }
    notifyListeners();
  }

  /// Deletes a profile (not its session history — callers that also want
  /// the data gone must call SessionProvider.deleteSessionsForProfile).
  /// At least one profile must always exist, and deleting the active
  /// profile switches to whichever profile is now first in the list.
  Future<void> deleteUserProfile(String profileId) async {
    if (_profiles.length <= 1) {
      throw StateError('At least one profile is required.');
    }
    if (!_profiles.any((profile) => profile.id == profileId)) return;
    _profiles = _profiles.where((profile) => profile.id != profileId).toList();
    if (_activeProfileId == profileId) {
      _activeProfileId = _profiles.first.id;
      _settings = _settings.copyWith(userName: _profiles.first.name);
      await PersistenceService.setActiveProfileId(_activeProfileId);
      await PersistenceService.setUserName(_profiles.first.name);
    }
    await PersistenceService.saveUserProfiles(_profiles);
    notifyListeners();
  }

  /// Wholesale-replaces the profile list, used when restoring a backup.
  /// Rejects a backup with duplicate ids or an activeProfileId that
  /// isn't in the list, rather than silently picking a fallback —
  /// a bad restore should fail loudly, not quietly corrupt state.
  Future<void> replaceUserProfiles(
    Iterable<UserProfile> profiles, {
    required String activeProfileId,
  }) async {
    final values = profiles.toList();
    if (values.isEmpty) {
      throw ArgumentError('At least one profile is required.');
    }
    final ids = values.map((profile) => profile.id).toSet();
    if (ids.length != values.length || !ids.contains(activeProfileId)) {
      throw const FormatException('Invalid profile backup.');
    }
    _profiles = values;
    _activeProfileId = activeProfileId;
    _settings = _settings.copyWith(userName: activeProfile.name);
    await PersistenceService.saveUserProfiles(_profiles);
    await PersistenceService.setActiveProfileId(_activeProfileId);
    await PersistenceService.setUserName(activeProfile.name);
    notifyListeners();
  }

  String _validatedProfileName(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(value, 'name', 'Profile name is required.');
    }
    return normalized.length <= 50 ? normalized : normalized.substring(0, 50);
  }

  // Names are compared case-insensitively so "Alex" and "alex" can't
  // coexist and silently confuse whoever is picking a profile.
  void _ensureUniqueProfileName(String name, {String? exceptId}) {
    final duplicate = _profiles.any(
      (profile) =>
          profile.id != exceptId &&
          profile.name.toLowerCase() == name.toLowerCase(),
    );
    if (duplicate) {
      throw ArgumentError.value(name, 'name', 'Profile name already exists.');
    }
  }

  /// Store user-imported quotes JSON string.
  Future<void> setUserQuotes(String quotesJson) async {
    await PersistenceService.saveUserQuotes(quotesJson);
  }

  /// Retrieve stored user quotes JSON, or null if none.
  Future<String?> getUserQuotes() async {
    return PersistenceService.loadUserQuotes();
  }

  /// Clear user-imported quotes.
  Future<void> clearUserQuotes() async {
    await PersistenceService.clearUserQuotes();
  }
}
