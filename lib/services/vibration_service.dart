import 'package:vibration/vibration.dart';

class VibrationService {
  static final VibrationService _instance = VibrationService._internal();
  factory VibrationService() => _instance;
  VibrationService._internal();

  bool _hasVibrator = false;

  Future<void> init() async {
    try {
      _hasVibrator = await Vibration.hasVibrator();
    } catch (_) {
      _hasVibrator = false;
    }
  }

  Future<void> vibrate(String pattern) async {
    switch (pattern) {
      case 'short':
        await _vibrateWithDuration(100);
      case 'medium':
        await _vibrateWithDuration(300);
      case 'long':
        await _vibrateWithDuration(600);
      case 'double':
        await _vibratePattern([0, 150, 100, 150]);
      case 'none':
      default:
        break;
    }
  }

  Future<void> _vibrateWithDuration(int ms) async {
    if (!_hasVibrator) return;
    try {
      await Vibration.vibrate(duration: ms);
    } catch (_) {}
  }

  Future<void> _vibratePattern(List<int> pattern) async {
    if (!_hasVibrator) return;
    try {
      await Vibration.vibrate(pattern: pattern);
    } catch (_) {}
  }

  Future<void> cancel() async {
    if (!_hasVibrator) return;
    try {
      await Vibration.cancel();
    } catch (_) {}
  }
}
