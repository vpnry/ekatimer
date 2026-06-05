import Flutter
import UIKit
import AVFoundation
import BackgroundTasks
import UserNotifications

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
    // Request notification permissions for alarm scheduling
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if granted {
        print("AppDelegate: Notification permission granted")
      } else if let error = error {
        print("AppDelegate: Notification permission denied: \(error)")
      }
    }
    
    // Set up audio session for background playback
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
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
  
  // Register MethodChannel + EventChannel handlers for alarm service
  private func setupAlarmChannel(binaryMessenger: FlutterBinaryMessenger) {
    // Register the alarm_events EventChannel (stub for iOS — iOS uses local
    // notifications + onAlarmFired callback instead of EventChannel).
    // Without this, Flutter's AlarmService.init() throws MissingPluginException.
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
          let delaySeconds = args["delaySeconds"] as? Int ?? 0
          let endTimeMillis = args["endTimeMillis"] as? Int64 ?? 0
          let requestCode = args["requestCode"] as? Int ?? 1001
          self.scheduleLocalNotification(
            delaySeconds: delaySeconds,
            endTimeMillis: endTimeMillis,
            requestCode: requestCode
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
    
    backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "ekatimer_meditation") {
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
  
  private func scheduleLocalNotification(delaySeconds: Int, endTimeMillis: Int64, requestCode: Int) {
    let content = UNMutableNotificationContent()
    content.title = "Meditation Complete"
    content.body = "Your meditation session has ended."
    content.sound = UNNotificationSound.default
    content.categoryIdentifier = "timer_end"
    content.userInfo = ["requestCode": requestCode]
    
    var trigger: UNNotificationTrigger
    
    if endTimeMillis > 0 {
      let endDate = Date(timeIntervalSince1970: TimeInterval(endTimeMillis / 1000))
      let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: endDate)
      trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    } else {
      trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delaySeconds), repeats: false)
    }
    
    let request = UNNotificationRequest(
      identifier: "ekatimer_end_\(requestCode)",
      content: content,
      trigger: trigger
    )
    
    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("AppDelegate: Failed to schedule notification: \(error)")
      } else {
        print("AppDelegate: Local notification scheduled (ID: ekatimer_end_\(requestCode))")
      }
    }
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
      name: "org.ekatimer.ios.gmlpub/widget",
      binaryMessenger: binaryMessenger
    )
    
    widgetChannel.setMethodCallHandler { (call, result) in
      switch call.method {
      case "getWidgetAction":
        let data = _widgetActionData
        _widgetActionData = nil // Clear after reading so each tap triggers only once
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
  
  private func playEndSound(soundPath: String) {
    var soundURL: URL?
    
    if !soundPath.isEmpty && soundPath != "none" {
      if soundPath.hasPrefix("assets/") {
        let fileName = (soundPath as NSString).lastPathComponent
        let name = (fileName as NSString).deletingPathExtension
        let ext = (fileName as NSString).pathExtension
        soundURL = Bundle.main.url(forResource: name, withExtension: ext)
      } else {
        soundURL = URL(fileURLWithPath: soundPath)
      }
    }
    
    if soundURL == nil {
      soundURL = Bundle.main.url(forResource: "Gong", withExtension: "m4a")
      if soundURL == nil {
        soundURL = Bundle.main.url(forResource: "Bell", withExtension: "m4a")
      }
    }
    
    guard let url = soundURL else {
      print("AppDelegate: No sound file found, playing system alert sound")
      AudioServicesPlaySystemSound(1005)
      return
    }
    
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: url)
      audioPlayer?.volume = 1.0
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

/// Stub EventChannel stream handler for `alarm_events`.
/// iOS uses local notifications + onAlarmFired callback instead of
/// EventChannel, but Flutter's AlarmService.init() subscribes to this
/// channel and throws MissingPluginException if no handler is registered.
private class AlarmEventStreamHandler: NSObject, FlutterStreamHandler {

    func onListen(withArguments arguments: Any?,
                  eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("AlarmService: EventChannel listener registered (stub — no events on iOS)")
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("AlarmService: EventChannel listener cancelled")
        return nil
    }
}