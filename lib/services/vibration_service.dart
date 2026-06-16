import 'dart:io';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class VibrationService {
  static final VibrationService _instance = VibrationService._internal();
  factory VibrationService() => _instance;
  VibrationService._internal();

  // Reuse the existing alarm channel — no new channel registration needed.
  static const MethodChannel _iosChannel = MethodChannel(
    'org.tipitakapali.ekatimer/alarm',
  );

  bool _hasVibrator = false;

  Future<void> init() async {
    if (Platform.isIOS) {
      // All iPhones have a Taptic Engine; skip the plugin hasVibrator() call
      // which may itself invoke CHHapticEngine on iOS 13+.
      _hasVibrator = true;
      return;
    }
    try {
      _hasVibrator = await Vibration.hasVibrator();
    } catch (_) {
      _hasVibrator = false;
    }
  }

  Future<void> vibrate(String pattern) async {
    if (pattern == 'none' || pattern.isEmpty) return;

    if (Platform.isIOS) {
      // Route ALL iOS vibration through the native channel.
      // AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) works while
      // the .playback audio session is active (screen off), unlike
      // CHHapticEngine which iOS suspends on screen-off.
      // Pattern nuance is intentionally dropped on iOS — a single Taptic
      // pulse is the correct UX for meditation interval signals.
      await _vibrateIos();
      return;
    }

    // Android — unchanged
    switch (pattern) {
      case 'short':
        await _vibrateWithDuration(100);
      case 'medium':
        await _vibrateWithDuration(300);
      case 'long':
        await _vibrateWithDuration(600);
      case 'double':
        await _vibratePattern([0, 150, 100, 150]);
      default:
        break;
    }
  }

  Future<void> _vibrateIos() async {
    try {
      await _iosChannel.invokeMethod<void>('vibrateNow');
    } catch (_) {
      // Native channel unavailable (e.g. simulator) — silent fail.
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
    if (Platform.isIOS) return; // Nothing to cancel with AudioServices
    if (!_hasVibrator) return;
    try {
      await Vibration.cancel();
    } catch (_) {}
  }
}
