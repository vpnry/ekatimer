The issue where the end alarm fails when the phone screen is off has been resolved. Here's a summary of all changes:

## Problem

When the phone's screen is turned off (power button), Android enters __doze mode__ which suspends the Dart VM's `Timer.periodic`. This prevents `_onTick` from firing, so the timer completion and end alarm never execute.

## Solution (Reference App Approach)

The reference app (`MeditationAssistant`) uses two mechanisms:

1. __`PARTIAL_WAKE_LOCK`__ - Keeps the CPU running even when screen is off
2. __`AlarmManager.setExactAndAllowWhileIdle()`__ - Wakes the device from doze mode at the exact end time

## Files Changed/Created

### Android Native (Kotlin)

- __`android/app/src/main/kotlin/.../AlarmSchedulerPlugin.kt`__ *(NEW)* - Native plugin with:

  - `PARTIAL_WAKE_LOCK` acquisition/release (CPU stays on)
  - `AlarmManager.setExactAndAllowWhileIdle()` scheduling (wakes from doze)
  - Native `MediaPlayer` for end sound playback (works in deep sleep)
  - `EventChannel` to send alarm-fired events back to Flutter

- __`android/app/src/main/kotlin/.../MainActivity.kt`__ *(MODIFIED)* - Registers AlarmSchedulerPlugin in `configureFlutterEngine()`

- __`android/app/src/main/AndroidManifest.xml`__ *(MODIFIED)* - Added permissions: `WAKE_LOCK`, `VIBRATE`, `SCHEDULE_EXACT_ALARM`, `USE_EXACT_ALARM`, `RECEIVE_BOOT_COMPLETED` and registered `AlarmReceiver`

### Flutter (Dart)

- __`lib/services/alarm_service.dart`__ *(NEW)* - Cross-platform service that:

  - Acquires/releases CPU wake lock via native channel
  - Schedules/cancels native alarms
  - Listens for alarm-fired events from native side
  - Plays end sound natively (backup when app is in deep sleep)

- __`lib/providers/timer_provider.dart`__ *(MODIFIED)* - Updated session lifecycle:

  - `startSession()`: acquires CPU wake lock + schedules native alarm
  - `pauseSession()`: cancels native alarm + releases wake lock
  - `resumeSession()`: re-acquires wake lock + re-schedules alarm
  - `stopSession()`/`reset()`/`dispose()`: cleans up all native alarms
  - `onNativeAlarmFired()`: handles alarm from doze mode (plays sound natively + completes session)

- __`lib/app.dart`__ *(MODIFIED)* - Wires up `AlarmService.onAlarmFired` callback in `_AppEntryState`

- __`lib/main.dart`__ *(MODIFIED)* - Initializes `AlarmService` in startup

### iOS Native (Swift)

- __`ios/Runner/BackgroundAlarmPlugin.swift`__ *(NEW)* - iOS equivalent using:

  - `AVAudioSession` background playback mode (keeps app alive)
  - `beginBackgroundTask` (iOS partial wake lock equivalent)
  - `UNUserNotificationCenter` local notifications (alarm backup)
  - `BGTaskScheduler` for processing background tasks

- __`ios/Runner/AppDelegate.swift`__ *(MODIFIED)* - Registers plugin + requests notification permissions

- __`ios/Runner/Info.plist`__ *(MODIFIED)* - Added `UIBackgroundModes` (audio, processing) and `BGTaskSchedulerPermittedIdentifiers`
