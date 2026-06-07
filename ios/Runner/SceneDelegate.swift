// ios/Runner/SceneDelegate.swift

import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {

    // MARK: - State

    private var hasPendingWidgetAction = false
    private var retryTimer: Timer?
    private let retryInterval: TimeInterval = 0.25
    private let retryMaxDuration: TimeInterval = 8.0

    // MARK: - Channel

    private let channelName = "org.ekatimer.ios.gmlpub/widget"

    private func makeChannel() -> FlutterMethodChannel? {
        guard let flutterVC = window?.rootViewController as? FlutterViewController else {
            return nil
        }
        return FlutterMethodChannel(
            name: channelName,
            binaryMessenger: flutterVC.binaryMessenger
        )
    }

    private func setupWidgetChannel() {
        guard let channel = makeChannel() else { return }

        channel.setMethodCallHandler { [weak self] call, result in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                result(nil)
                return
            }

            switch call.method {

            case "getWidgetAction":
                // Returns data AND clears it from the store.
                let data = appDelegate.getAndClearWidgetActionData()
                let payload: [String: Any]? = (data?.isEmpty == false) ? data : nil
                if payload != nil {
                    self?.cancelRetryTimer()
                    self?.hasPendingWidgetAction = false
                }
                result(payload)

            case "peekWidgetAction":
                // Returns data WITHOUT clearing — safe to call before getWidgetAction.
                let data = appDelegate.peekWidgetActionData()
                result((data?.isEmpty == false) ? data : nil)

            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // MARK: - URL parsing

    @discardableResult
    private func parseAndStoreWidgetData(from url: URL) -> Bool {
        guard url.scheme == "ekatimer",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              components.host == "start",
              let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return false }

        let queryItems = components.queryItems ?? []
        func param(_ name: String) -> String? {
            queryItems.first(where: { $0.name == name })?.value
        }

        let mode     = param("mode") ?? "timed"
        let duration = Int(param("duration") ?? "0") ?? 0

        var data: [String: Any] = [
            "timerMode":     mode,
            "timerDuration": duration,
        ]
        if mode == "endAt", let ts = param("endAt").flatMap(Int.init) {
            data["endAt"] = ts
        }

        appDelegate.setWidgetActionData(data)
        return true
    }

    // MARK: - Retry timer (cold launch)

    /// Fires widgetActionAvailable repeatedly until Flutter calls getWidgetAction
    /// (which cancels the timer) or the 8-second window expires.
    /// This tolerates any delay in Dart's channel listener registration.
    private func startRetryTimer() {
        cancelRetryTimer()

        guard let channel = makeChannel() else {
            // Engine not ready — wait one interval and try again.
            DispatchQueue.main.asyncAfter(deadline: .now() + retryInterval) { [weak self] in
                guard self?.hasPendingWidgetAction == true else { return }
                self?.startRetryTimer()
            }
            return
        }

        var elapsed: TimeInterval = 0
        retryTimer = Timer.scheduledTimer(withTimeInterval: retryInterval, repeats: true) { [weak self] timer in
            guard let self = self else { timer.invalidate(); return }
            elapsed += self.retryInterval
            guard self.hasPendingWidgetAction && elapsed < self.retryMaxDuration else {
                self.cancelRetryTimer()
                return
            }
            channel.invokeMethod("widgetActionAvailable", arguments: nil)
        }
        // Fire once immediately (timer first fires after one interval).
        channel.invokeMethod("widgetActionAvailable", arguments: nil)
    }

    private func cancelRetryTimer() {
        retryTimer?.invalidate()
        retryTimer = nil
    }

    // MARK: - UISceneDelegate lifecycle

    /// Cold launch — app was not running when the widget was tapped.
    override func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)
        setupWidgetChannel()

        for urlContext in connectionOptions.urlContexts {
            if parseAndStoreWidgetData(from: urlContext.url) {
                hasPendingWidgetAction = true
                break
            }
        }
    }

    /// Engine is reliably up here — start the retry loop for cold launch.
    override func sceneDidBecomeActive(_ scene: UIScene) {
        super.sceneDidBecomeActive(scene)
        setupWidgetChannel()

        if hasPendingWidgetAction {
            startRetryTimer()
        }
    }

    /// Warm / suspended → foreground — app was already running.
    override func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        setupWidgetChannel()

        guard let url = URLContexts.first?.url else {
            super.scene(scene, openURLContexts: URLContexts)
            return
        }

        if parseAndStoreWidgetData(from: url) {
            // Engine already running; single notification is reliable here.
            hasPendingWidgetAction = true
            makeChannel()?.invokeMethod("widgetActionAvailable", arguments: nil)
            return
        }

        super.scene(scene, openURLContexts: URLContexts)
    }

    override func sceneWillResignActive(_ scene: UIScene) {
        super.sceneWillResignActive(scene)
        cancelRetryTimer()
    }
}
