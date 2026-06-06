// ios/Runner/AppDelegate.swift

import Flutter
import UIKit
import AVFoundation
import BackgroundTasks
import UserNotifications
import AudioToolbox

// File-private storage for widget action data received from deep links.
// Used by the method channel handler to respond to Flutter's getWidgetAction call.
fileprivate var _widgetActionData: [String: Any]? = nil

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    
    // FIX 1: Adopt delegate so we can
                                                              // intercept foreground notification
                                                              // delivery and play AVAudioPlayer.

  // Background task ID for keep-alive
  private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
  private var audioPlayer: AVAudioPlayer?

  /// Store widget action data from a deep link so Flutter can retrieve it.
  func setWidgetActionData(_ data: [String: Any]?) {
    _widgetActionData = data
  }

  /// Read and clear the stored widget action data (one-shot consumption).
  func getAndClearWidgetActionData() -> [String: Any]? {
    let data = _widgetActionData
    _widgetActionData = nil
    return data
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // FIX 2: Assign ourselves as the UNUserNotificationCenter delegate BEFORE
    // super.application(...) so we receive willPresent and didReceive callbacks.
    // Without this the system shows the banner but your code never runs.
    UNUserNotificationCenter.current().delegate = self

    // Request notification permissions for alarm scheduling
    UNUserNotificationCenter.current().requestAuthorization(
      options: [.alert, .sound, .badge]
    ) { granted, error in
      if granted {
        print("AppDelegate: Notification permission granted")
      } else if let error = error {
        print("AppDelegate: Notification permission denied: \(error)")
      }
    }

    // Set up audio session for background playback
    do {
      try AVAudioSession.sharedInstance().setCategory(
        .playback,
        mode: .default,
        options: [.mixWithOthers]
      )
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("AppDelegate: Failed to set up audio session: \(error)")
    }

    // Register for background tasks
    if #available(iOS 13.0, *) {
      BGTaskScheduler.shared.register(
        forTaskWithIdentifier: "org.tipitakapali.ekatimer.timerend",
        using: nil
      ) { task in
        self.handleBackgroundTask(task: task)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - FlutterImplicitEngineDelegate

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    // Register all Flutter plugins (audioplayers, provider, etc.)
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    // Set up our custom alarm channel
    setupAlarmChannel(binaryMessenger: engineBridge.applicationRegistrar.messenger())
    // Set up widget action channel so Flutter can retrieve widget tap data
    setupWidgetChannel(binaryMessenger: engineBridge.applicationRegistrar.messenger())
  }

  // MARK: - UNUserNotificationCenterDelegate

  // FIX 3: willPresent fires when a notification arrives while the app IS in the
  // foreground (screen on, app visible).  Without this iOS suppresses the
  // banner AND the sound.  We play the sound ourselves via AVAudioPlayer so
  // the in-app experience is identical to the background/screen-off path.
override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
) {
    let userInfo = notification.request.content.userInfo
    print("AppDelegate: willPresent notification – \(notification.request.identifier)")

    // Play the end sound ourselves so AVAudioPlayer fires (not just the system beep).
    // Extract the soundPath that was stashed in userInfo when we scheduled the notification.
    if let soundName = userInfo["soundPath"] as? String {
      playEndSound(soundPath: soundName)
    }

    // Still show the banner/badge but suppress the system sound (we already played it).
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .badge])
    } else {
      completionHandler([.alert, .badge])
    }
  }

  // FIX 4: didReceive fires when the user TAPS the notification (foreground or
  // background).  We do NOT replay the sound here because the system already
  // played content.sound on delivery.  We just hand off to Flutter if needed.
override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
) {
    print("AppDelegate: didReceive notification response – \(response.notification.request.identifier)")
    completionHandler()
  }

  // MARK: - Method Channel Setup

  private func setupAlarmChannel(binaryMessenger: FlutterBinaryMessenger) {
    // Register the alarm_events EventChannel (stub for iOS).
    let alarmEventChannel = FlutterEventChannel(
      name: "org.tipitakapali.ekatimer/alarm_events",
      binaryMessenger: binaryMessenger
    )
    alarmEventChannel.setStreamHandler(AlarmEventStreamHandler())

    let alarmChannel = FlutterMethodChannel(
      name: "org.tipitakapali.ekatimer/alarm",
      binaryMessenger: binaryMessenger
    )

    alarmChannel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }

      switch call.method {
      case "acquireCpuWakeLock":
        self.startBackgroundTask()
        result(true)

      case "releaseCpuWakeLock":
        self.endBackgroundTask()
        result(true)

      case "scheduleEndAlarm":
        if let args = call.arguments as? [String: Any] {
          let delaySeconds   = args["delaySeconds"]   as? Int    ?? 0
          let endTimeMillis  = args["endTimeMillis"]  as? Int64  ?? 0
          let requestCode    = args["requestCode"]    as? Int    ?? 1001
          let soundPath      = args["soundPath"]      as? String ?? ""
          self.scheduleLocalNotification(
            delaySeconds:  delaySeconds,
            endTimeMillis: endTimeMillis,
            requestCode:   requestCode,
            soundPath:     soundPath
          )
        }
        result(true)

      case "cancelEndAlarm":
        if let args = call.arguments as? [String: Any] {
          let requestCode = args["requestCode"] as? Int ?? 1001
          self.cancelLocalNotification(requestCode: requestCode)
        }
        result(true)

      case "cancelAllAlarms":
        self.cancelAllNotifications()
        self.endBackgroundTask()
        result(true)

      case "playEndSound":
        if let args = call.arguments as? [String: Any] {
          let soundPath = args["soundPath"] as? String ?? ""
          self.playEndSound(soundPath: soundPath)
        }
        result(true)

      case "hasExactAlarmPermission":
        result(true)

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  // MARK: - Background Task Support

  private func startBackgroundTask() {
    guard backgroundTaskID == .invalid else {
      print("AppDelegate: Background task already running")
      return
    }

    backgroundTaskID = UIApplication.shared.beginBackgroundTask(
      withName: "ekatimer_meditation"
    ) {
      print("AppDelegate: Background task expired")
      self.endBackgroundTask()
    }

    print("AppDelegate: Background task started (ID: \(backgroundTaskID))")
  }

  private func endBackgroundTask() {
    guard backgroundTaskID != .invalid else { return }
    UIApplication.shared.endBackgroundTask(backgroundTaskID)
    print("AppDelegate: Background task ended (ID: \(backgroundTaskID))")
    backgroundTaskID = .invalid
  }

  @available(iOS 13.0, *)
  private func handleBackgroundTask(task: BGTask) {
    print("AppDelegate: Handling background task: \(task.identifier)")
    playEndSound(soundPath: "")
    task.setTaskCompleted(success: true)
  }

  // MARK: - Local Notification (iOS Alarm Backup)

  private func scheduleLocalNotification(
    delaySeconds: Int,
    endTimeMillis: Int64,
    requestCode: Int,
    soundPath: String = ""
  ) {
    let content = UNMutableNotificationContent()
    content.title = "Meditation Complete"
    content.body  = "Your meditation session has ended."

    // FIX 5: Stash the soundPath in userInfo so willPresent can re-play it
    // via AVAudioPlayer when the app IS in the foreground.
    content.userInfo = [
      "requestCode": requestCode,
      "soundPath":   soundPath          // ← new
    ]

    // FIX 6: The notification sound MUST reference a file that lives in the
    // ROOT of the app bundle (Runner target → Build Phases → Copy Bundle
    // Resources).  Flutter asset paths (assets/sounds/…) are bundled under
    // Frameworks/App.framework/flutter_assets/ which iOS CANNOT reach for
    // UNNotificationSound.  Add the .wav files directly to the Xcode target.
    //
    // Naming convention expected here: bare name, e.g. "BowlStrong"
    // → iOS will look for BowlStrong.wav (or .aiff / .caf) in the bundle root.
    //
    // If soundPath looks like "assets/sounds/Bell.wav" we strip to "Bell".
    let resolvedSoundName = resolveNotificationSoundName(from: soundPath)

    if resolvedSoundName.isEmpty || resolvedSoundName == "none" {
      content.sound = UNNotificationSound.default
    } else {
      content.sound = UNNotificationSound(
        named: UNNotificationSoundName(rawValue: "\(resolvedSoundName).wav")
      )
    }

    content.categoryIdentifier = "timer_end"

    // Build trigger
    let trigger: UNNotificationTrigger

    if endTimeMillis > 0 {
      let endDate = Date(timeIntervalSince1970: TimeInterval(endTimeMillis / 1000))
      let components = Calendar.current.dateComponents(
        [.year, .month, .day, .hour, .minute, .second],
        from: endDate
      )
      trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    } else {
      // Guard: UNTimeIntervalNotificationTrigger requires interval > 0
      let interval = max(TimeInterval(delaySeconds), 1)
      trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
    }

    let request = UNNotificationRequest(
      identifier: "ekatimer_end_\(requestCode)",
      content:    content,
      trigger:    trigger
    )

    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("AppDelegate: Failed to schedule notification: \(error)")
      } else {
        print("AppDelegate: Local notification scheduled (ID: ekatimer_end_\(requestCode), sound: \(resolvedSoundName))")
      }
    }
  }

  // FIX 7: Centralise sound-name extraction so both scheduleLocalNotification
  // and playEndSound use identical logic, and neither passes a bad path to iOS.
  //
  //   "assets/sounds/Bell.wav"  →  "Bell"
  //   "BowlStrong"              →  "BowlStrong"
  //   ""  /  "none"             →  ""
  private func resolveNotificationSoundName(from soundPath: String) -> String {
    guard !soundPath.isEmpty, soundPath != "none" else { return "" }

    if soundPath.hasPrefix("assets/") {
      // Strip directory and extension:  "assets/sounds/Bell.wav" → "Bell"
      let fileName = (soundPath as NSString).lastPathComponent           // "Bell.wav"
      return (fileName as NSString).deletingPathExtension                // "Bell"
    }
    // Already a bare name: "BowlStrong"
    return soundPath
  }

  private func cancelLocalNotification(requestCode: Int) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(
      withIdentifiers: ["ekatimer_end_\(requestCode)"]
    )
    print("AppDelegate: Local notification cancelled (ID: ekatimer_end_\(requestCode))")
  }

  private func cancelAllNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    print("AppDelegate: All notifications cancelled")
  }

  // MARK: - Widget Channel (for quick-start widget taps)

  private func setupWidgetChannel(binaryMessenger: FlutterBinaryMessenger) {
    let widgetChannel = FlutterMethodChannel(
      name:            "org.ekatimer.ios.gmlpub/widget",
      binaryMessenger: binaryMessenger
    )

    widgetChannel.setMethodCallHandler { (call, result) in
      switch call.method {
      case "getWidgetAction":
        let data = _widgetActionData
        _widgetActionData = nil
        if let data = data, !data.isEmpty {
          result(data)
        } else {
          result(nil)
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  // MARK: - End Sound Playback

  // FIX 8: Uses resolveNotificationSoundName for consistent path handling,
  // and always falls back to BowlStrong → system sound in that order so
  // something always plays.
  private func playEndSound(soundPath: String) {
    var soundURL: URL?

    let name = resolveNotificationSoundName(from: soundPath)

    if !name.isEmpty {
      // Look for <name>.wav in the native bundle root (where Xcode-copied
      // resources live). Flutter asset paths do NOT work here.
      soundURL = Bundle.main.url(forResource: name, withExtension: "wav")

      if soundURL == nil {
        print("AppDelegate: '\(name).wav' not found in bundle root – check Xcode Copy Bundle Resources")
      }
    }

    // Fallback 1: BowlStrong.wav (must be in Xcode target resources)
    if soundURL == nil {
      soundURL = Bundle.main.url(forResource: "BowlStrong", withExtension: "wav")
    }

    // Fallback 2: system alert
    guard let url = soundURL else {
      print("AppDelegate: No sound file found, playing system alert sound")
      AudioServicesPlaySystemSound(1005)
      return
    }

    do {
      // FIX 9: Re-activate audio session before playing in case it was
      // deactivated by another app or a phone call.
      try AVAudioSession.sharedInstance().setActive(true)
      audioPlayer = try AVAudioPlayer(contentsOf: url)
      audioPlayer?.volume        = 1.0
      audioPlayer?.numberOfLoops = 0
      audioPlayer?.play()
      print("AppDelegate: Playing sound: \(url.lastPathComponent)")
    } catch {
      print("AppDelegate: Failed to play sound: \(error)")
      AudioServicesPlaySystemSound(1005)
    }
  }
}

// MARK: - Alarm Event Stream Handler (stub for iOS)

private class AlarmEventStreamHandler: NSObject, FlutterStreamHandler {
  func onListen(
    withArguments arguments: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    print("AlarmService: EventChannel listener registered (stub — no events on iOS)")
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    print("AlarmService: EventChannel listener cancelled")
    return nil
  }
}
