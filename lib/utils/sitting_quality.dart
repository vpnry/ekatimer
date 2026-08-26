class SittingQuality {
  SittingQuality._();

  static final RegExp _ratingPattern = RegExp(
    r'^(?:[0-4](?:[\.,]\d)?|5(?:[\.,]0)?)$',
  );

  // Same shape as _ratingPattern but with the trailing digit made optional,
  // so a value mid-typing ("3." or "3,") is accepted while it's incomplete.
  // Kept next to _ratingPattern on purpose: change one, check the other.
  static final RegExp _keystrokePattern = RegExp(
    r'^(?:[0-4](?:[\.,]\d?)?|5(?:[\.,]0?)?)?$',
  );

  /// Empty quality is valid because the field is optional. A supplied value
  /// must be a number from 0.0 through 5.0 with at most one decimal place.
  static bool isValidInput(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty || _ratingPattern.hasMatch(trimmed);
  }

  /// Whether [value] is a legal in-progress state of the text field, i.e. a
  /// prefix of some valid [isValidInput] value. Use this in a
  /// `TextInputFormatter` to block keystrokes as the user types, not to
  /// validate the finished value.
  static bool isValidKeystroke(String value) =>
      _keystrokePattern.hasMatch(value);

  static String? normalize(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    if (!_ratingPattern.hasMatch(trimmed)) return null;
    final parsed = double.parse(trimmed.replaceAll(',', '.'));
    return parsed.toStringAsFixed(1);
  }

  static double? rating(String? value) {
    final normalized = normalize(value);
    if (normalized == null) return null;
    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed < 0 || parsed > 5) {
      return null;
    }
    return parsed;
  }

  static String display(String value) {
    final normalized = normalize(value) ?? '';
    final parsed = rating(normalized);
    if (parsed == null) return '';

    // Plain-text exports cannot embed a Flutter icon, so use the visual star
    // glyph instead of the old asterisk fallback.
    return '${formatRating(parsed)}★';
  }

  static String descriptionKey(int rating) => 'quality.level.$rating';

  static List<String> descriptionKeys(double rating) {
    if (rating == rating.roundToDouble()) {
      return [descriptionKey(rating.toInt())];
    }
    return [descriptionKey(rating.floor()), descriptionKey(rating.ceil())];
  }

  static String formatRating(double rating) => rating.toStringAsFixed(1);

  /// Returns the filled proportion for each of five visual star slots.
  ///
  /// The fractional part is preserved, so 3.5 becomes
  /// `[1.0, 1.0, 1.0, 0.5, 0.0]` and 2.2 fills 20% of the third star.
  static List<double> starFillFractions(double rating) {
    final clampedRating = rating.isFinite ? rating.clamp(0.0, 5.0) : 0.0;
    final safeRating = (clampedRating * 10).round() / 10;
    return List<double>.generate(5, (index) {
      final fraction = (safeRating - index).clamp(0.0, 1.0);
      return (fraction * 10).round() / 10;
    }, growable: false);
  }

  static String stars(double rating) {
    final filledCount = rating.round().clamp(0, 5);
    return '${List.filled(filledCount, '★').join()}${List.filled(5 - filledCount, '☆').join()}';
  }

  static double? average(Iterable<String?> values) {
    var total = 0.0;
    var count = 0;
    for (final value in values) {
      final parsed = rating(value);
      if (parsed == null) continue;
      total += parsed;
      count++;
    }
    return count == 0 ? null : total / count;
  }
}
