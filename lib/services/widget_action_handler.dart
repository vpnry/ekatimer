import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../models/timer_mode.dart';

/// Handles widget tap actions from home screen widgets.
///
/// When a user taps a quick-start widget (1H, 2H, 3H, End At, Unlimited),
/// the app opens and this handler reads the action data to auto-start
/// the appropriate timer.
class WidgetActionHandler {
  // iOS uses the App Group identifier, Android uses the app package name.
  // Each platform only registers its own channel, so we pick the right one.
  static String get _channelName {
    if (Platform.isAndroid) {
      return 'org.tipitakapali.ekatimer/widget';
    }
    // iOS
    return 'org.ekatimer.ios.gmlpub/widget';
  }

  /// If a widget wants to land on the home screen with a pre-selected mode
  /// (e.g. "End At"), this stores the mode string so the home screen can read it.
  static String? selectedWidgetMode;

  /// Set up a method call handler that responds to `widgetActionAvailable`
  /// invocations from the native side (iOS), and immediately processes
  /// the widget action. This handles the case where the app is already
  /// in the foreground when a widget is tapped (lifecycle observer won't fire).
  ///
  /// [onSessionStarted] is called when a session was successfully started
  /// (the caller should update `_hasActiveSession` or similar state).
  static void setupListener(
    BuildContext context, {
    required VoidCallback onSessionStarted,
  }) {
    if (Platform.isAndroid) return; // Android handles via intent extras
    try {
      final channel = MethodChannel(_channelName);
      channel.setMethodCallHandler((call) async {
        if (call.method == 'widgetActionAvailable') {
          if (context.mounted) {
            final handled = await handleWidgetAction(context);
            if (handled && context.mounted) {
              onSessionStarted();
            }
          }
        }
        return null;
      });
    } catch (e) {
      debugPrint('WidgetActionHandler: setupListener error: $e');
    }
  }

  /// Get raw widget action data from the native side without processing it.
  /// Used to check for non-widget launch flags like `fromAlarm`.
  static Future<Map<String, dynamic>?> getWidgetActionData(
    BuildContext context,
  ) async {
    try {
      final channel = MethodChannel(_channelName);
      final result = await channel.invokeMethod<Map<dynamic, dynamic>>(
        'getWidgetAction',
      );
      if (result == null || result.isEmpty) return null;
      return result.cast<String, dynamic>();
    } on MissingPluginException {
      return null;
    } catch (e) {
      debugPrint('WidgetActionHandler.getWidgetActionData error: $e');
      return null;
    }
  }

  /// Check if the app was launched by a widget tap and handle the action.
  ///
  /// Returns true if the session was started (navigate to MeditationScreen),
  /// false if the action was consumed but should go to the home screen instead.
  static Future<bool> handleWidgetAction(BuildContext context) async {
    // Capture provider reference before any async gap
    final timerProvider = context.read<TimerProvider>();

    try {
      final channel = MethodChannel(_channelName);
      final result = await channel.invokeMethod<Map<dynamic, dynamic>>(
        'getWidgetAction',
      );
      if (result == null || result.isEmpty) return false;

      // Check for quick-start timer action
      final timerMode = result['timerMode'] as String?;
      final timerDuration = result['timerDuration'] as int?;

      if (timerMode != null) {
        final mode = TimerMode.fromString(timerMode);

        // For "End At", don't start the session – instead land on the home
        // screen with the End At picker pre-selected.
        if (mode == TimerMode.endAt) {
          timerProvider.configure(mode: mode, durationMinutes: timerDuration);
          selectedWidgetMode = timerMode;
          return false;
        }

        // Timed and unlimited modes: start immediately.
        timerProvider.configure(
          mode: mode,
          durationMinutes: timerDuration ?? 60,
        );
        await timerProvider.startSession();
        return true;
      }

      return false;
    } on MissingPluginException {
      // Method channel not available on this platform
      return false;
    } catch (e) {
      debugPrint('WidgetActionHandler error: $e');
      return false;
    }
  }
}
