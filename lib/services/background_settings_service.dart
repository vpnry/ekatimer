import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class BackgroundSettingsService {
  BackgroundSettingsService._();

  static const MethodChannel _channel = MethodChannel(
    'org.tipitakapali.ekatimer/background_settings',
  );

  static Future<bool> isBatteryOptimizationIgnored() async {
    if (!Platform.isAndroid) return true;
    try {
      final result = await _channel.invokeMethod<bool>(
        'isBatteryOptimizationIgnored',
      );
      return result ?? false;
    } on MissingPluginException {
      return true;
    } catch (e) {
      debugPrint('BackgroundSettingsService: error checking battery opt: $e');
      return true;
    }
  }

  static Future<String?> requestIgnoreBatteryOptimization() async {
    if (!Platform.isAndroid) return null;
    try {
      await _channel.invokeMethod<void>('requestIgnoreBatteryOptimization');
      return null;
    } on MissingPluginException {
      return 'MISSING_PLUGIN';
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> openOemBackgroundSettings() async {
    if (!Platform.isAndroid) return null;
    try {
      await _channel.invokeMethod<void>('openOemBackgroundSettings');
      return null;
    } on MissingPluginException {
      return 'MISSING_PLUGIN';
    } catch (e) {
      return e.toString();
    }
  }
}
