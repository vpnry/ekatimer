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

  // Background task ID for keep-alive
  private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
  private var audioPlayer: AVAudioPlayer?

  /// Store widget action data from a deep link so Flutter can retrieve it.
  func setWidgetActionData(_ data: [String: Any]?) {
    _widgetActionData = data
  }

  /// Read and CLEAR the stored widget action data (one-shot consumption).
  /// Called by the "getWidgetAction" channel method.
  func getAndClearWidgetActionData() -> [String: Any]? {
    let data = _widgetActionData
    _widgetActionData = nil
    return data
  }

  /// Read the stored widget action data WITHOUT clearing it.
  /// Called by the "peekWidgetAction" channel method — lets Dart inspect
  /// flags (e.g. fromAlarm) before the full handleWidgetAction call
  /// consumes the payload via getWidgetAction.
  func peekWidgetActionData() -> [String: Any]? {
    return _widgetActionData
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    UNUserNotificationCenter.current().delegate = self

    // UNUserNotificationCenter.current().requestAuthorization(
    //   options: [.alert, .sound, .badge]
    // ) { granted, error in
    //   if granted {
    //     print("AppDelegate: Notification permission granted")
    //   } else if let error = error {
    //     print("AppDelegate: Notification permission denied: \(error)")
    //   }
    // }

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
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    setupAlarmChannel(binaryMessenger: engineBridge.applicationRegistrar.messenger())
    setupWidgetChannel(binaryMessenger: engineBridge.applicationRegistrar.messenger())
  }

  // MARK: - UNUserNotificationCenterDelegate

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    _ = notification.request.content.userInfo
    print("AppDelegate: willPresent notification – \(notification.request.identifier)")

    // Dart handles playing the sound in the foreground via _onTick,
    // so we don't play it here to avoid a double/echo sound.
    // if let soundName = userInfo["soundPath"] as? String {
    //   playEndSound(soundPath: soundName)
    // }

    if #available(iOS 14.0, *) {
      completionHandler([.banner, .badge])
    } else {
      completionHandler([.alert, .badge])
    }
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    print("AppDelegate: didReceive notification response – \(response.notification.request.identifier)")

    // The system already played the UNNotificationSound when the notification
    // was delivered to the lock screen or background. Playing it again when the user taps
    // the notification creates an unwanted double-sound experience.
    //
    // if UIApplication.shared.applicationState != .active {
    //   let userInfo = response.notification.request.content.userInfo
    //   if let soundName = userInfo["soundPath"] as? String {
    //     playEndSound(soundPath: soundName)
    //   }
    // }
    completionHandler()
  }

  // MARK: - Method Channel Setup

  private func setupAlarmChannel(binaryMessenger: FlutterBinaryMessenger) {
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

      case "stopEndSound":
        self.audioPlayer?.stop()
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

  private func setupWidgetChannel(binaryMessenger: FlutterBinaryMessenger) {
    let widgetChannel = FlutterMethodChannel(
      name:            "org.ekatimer.ios.gmlpub/widget",
      binaryMessenger: binaryMessenger
    )

    widgetChannel.setMethodCallHandler { (call, result) in
      switch call.method {

      case "getWidgetAction":
        // Returns data AND clears it from the store.
        let data = _widgetActionData
        _widgetActionData = nil
        result((data?.isEmpty == false) ? data : nil)

      case "peekWidgetAction":
        // Returns data WITHOUT clearing it — safe to call before getWidgetAction.
        result((_widgetActionData?.isEmpty == false) ? _widgetActionData : nil)

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

  // MARK: - Local Notification

  private func scheduleLocalNotification(
    delaySeconds: Int,
    endTimeMillis: Int64,
    requestCode: Int,
    soundPath: String = ""
  ) {
    let content = UNMutableNotificationContent()
    content.title = "Meditation Complete"
    content.body  = "Your meditation session has ended."
    content.userInfo = [
      "requestCode": requestCode,
      "soundPath":   soundPath,
    ]

    let resolvedSoundName = resolveNotificationSoundName(from: soundPath)

    if resolvedSoundName.isEmpty || resolvedSoundName == "none" {
      content.sound = UNNotificationSound.default
    } else {
      content.sound = UNNotificationSound(
        named: UNNotificationSoundName(rawValue: "\(resolvedSoundName).wav")
      )
    }

    content.categoryIdentifier = "timer_end"

    let trigger: UNNotificationTrigger

    if endTimeMillis > 0 {
      let endDate = Date(timeIntervalSince1970: TimeInterval(endTimeMillis / 1000))
      let components = Calendar.current.dateComponents(
        [.year, .month, .day, .hour, .minute, .second],
        from: endDate
      )
      trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    } else {
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

  private func resolveNotificationSoundName(from soundPath: String) -> String {
    guard !soundPath.isEmpty, soundPath != "none" else { return "" }
    if soundPath.hasPrefix("assets/") {
      let fileName = (soundPath as NSString).lastPathComponent
      return (fileName as NSString).deletingPathExtension
    }
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

  // MARK: - End Sound Playback

  private func playEndSound(soundPath: String) {
    var soundURL: URL?

    let name = resolveNotificationSoundName(from: soundPath)

    if !name.isEmpty {
      soundURL = Bundle.main.url(forResource: name, withExtension: "wav")
      if soundURL == nil {
        print("AppDelegate: '\(name).wav' not found in bundle root – check Xcode Copy Bundle Resources")
      }
    }

    if soundURL == nil {
      soundURL = Bundle.main.url(forResource: "BowlStrong", withExtension: "wav")
    }

    guard let url = soundURL else {
      print("AppDelegate: No sound file found, playing system alert sound")
      AudioServicesPlaySystemSound(1005)
      return
    }

    do {
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
