import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// Lightweight JSON-based translation service, following the same pattern
/// as the upocal_widget project.
///
/// Usage in a widget:
///   final t = TranslationService.of(context);
///   Text(t.translate('settings.language'));
class TranslationService extends InheritedWidget {
  Map<String, Map<String, String>> get _translations => translations;
  final String _currentLocale;

  const TranslationService({
    super.key,
    required super.child,
    required this.translations,
    required String locale,
  }) : _currentLocale = locale;

  /// The loaded translations map.
  final Map<String, Map<String, String>> translations;

  /// All supported language codes mapped to their native display names.
  /// Matches the language list from the upocal_widget project.
  /// 'system' is a special value meaning "follow iOS device preferred language".
  static const Map<String, String> supportedLanguages = {
    'system': 'Device Language',
    'en': 'English',
    'vi': 'Tiếng Việt',
    'my': 'မြန်မာ',
    'si': 'සිංහල',
    'de': 'Deutsch',
    'id': 'Bahasa Indonesia',
    'zh': '中文',
    'th': 'ไทย',
    'hi': 'हिन्दी',
    'ne': 'नेपाली',
    'ko': '한국어',
    'ja': '日本語',
    'km': 'ភាសាខ្មែរ',
    'ru': 'Русский',
    'lo': 'ລາວ',
  };

  /// Resolve the effective locale to use for translations.
  /// If [locale] is 'system', fall back to the device's preferred locale.
  /// Returns 'en' if the device locale is not supported.
  static String resolveLocale(String locale) {
    if (locale != 'system') return locale;
    try {
      final deviceLocale = ui.PlatformDispatcher.instance.locale;
      final lang = deviceLocale.languageCode;
      if (supportedLanguages.containsKey(lang)) {
        return lang;
      }
    } catch (_) {}
    return 'en';
  }

  /// Get the current locale code (e.g. 'en', 'vi', 'de').
  String get locale => _currentLocale;

  /// Translate [key] using the current locale.
  /// Falls back to 'en' (base) if the key is missing in the current locale.
  /// If missing everywhere, returns the key itself.
  String translate(String key, {Map<String, String>? args}) {
    // Try current locale
    String? value = _translations[_currentLocale]?[key];
    // Fall back to English
    value ??= _translations['en']?[key];
    // Fall back to key itself
    value ??= key;

    if (args != null && args.isNotEmpty) {
      for (final entry in args.entries) {
        value = value!.replaceAll('{${entry.key}}', entry.value);
      }
    }

    return value!;
  }

  /// Shorthand to get from context.
  static TranslationService of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<TranslationService>();
    assert(result != null, 'No TranslationService found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TranslationService oldWidget) =>
      oldWidget._currentLocale != _currentLocale ||
      oldWidget._translations != _translations;

  // ────────────────────────────────────────────
  //  Loader
  // ────────────────────────────────────────────

  /// Load translations from the JSON asset bundled with the app.
  /// [path] defaults to 'assets/translations/translations.json'.
  static Future<Map<String, Map<String, String>>> loadTranslations({
    String path = 'assets/translations/translations.json',
  }) async {
    final raw = await rootBundle.loadString(path);
    final decoded = json.decode(raw) as Map<String, dynamic>;

    return decoded.map(
      (locale, value) => MapEntry(
        locale,
        (value as Map<String, dynamic>).map((k, v) => MapEntry(k, v as String)),
      ),
    );
  }
}
