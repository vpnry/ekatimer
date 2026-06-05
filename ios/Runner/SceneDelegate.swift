import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
    private static var widgetChannelSetup = false

    /// Set up the widget method channel handler on the main Flutter engine's messenger.
    /// This must be done in addition to the implicit engine setup (didInitializeImplicitFlutterEngine)
    /// because the Dart MethodChannel uses the main engine's messenger, not the implicit engine's.
    private func setupWidgetChannelOnMainEngine() {
        guard !SceneDelegate.widgetChannelSetup,
              let flutterVC = window?.rootViewController as? FlutterViewController else {
            return
        }
        SceneDelegate.widgetChannelSetup = true

        let channel = FlutterMethodChannel(
            name: "org.ekatimer.ios.gmlpub/widget",
            binaryMessenger: flutterVC.binaryMessenger
        )
        channel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "getWidgetAction":
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    let data = appDelegate.getAndClearWidgetActionData()
                    if let data = data, !data.isEmpty {
                        result(data)
                    } else {
                        result(nil)
                    }
                } else {
                    result(nil)
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    /// Handle widget URL deep links delivered via scene (iOS 13+).
    /// On iOS 13+, widget tap URLs are delivered here, NOT through
    /// the AppDelegate's application(_:open:options:).
    override func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)
        // Register widget channel on the main engine as early as possible
        setupWidgetChannelOnMainEngine()
    }

    override func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        // Setup widget channel if not already done (late-fallback)
        setupWidgetChannelOnMainEngine()

        guard let url = URLContexts.first?.url else {
            super.scene(scene, openURLContexts: URLContexts)
            return
        }

        // Handle ekatimer:// scheme ourselves — don't forward it to
        // FlutterSceneDelegate which would try to navigate to it as a route.
        if url.scheme == "ekatimer",
           let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let host = components.host,
           host == "start" {
            let queryItems = components.queryItems ?? []
            let mode = queryItems.first(where: { $0.name == "mode" })?.value ?? "timed"
            let durationStr = queryItems.first(where: { $0.name == "duration" })?.value ?? "0"
            let duration = Int(durationStr) ?? 0

            // Store widget action data for Flutter to retrieve via method channel
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let data: [String: Any] = [
                    "timerMode": mode,
                    "timerDuration": duration
                ]
                appDelegate.setWidgetActionData(data)

                // Immediately notify Flutter that new widget action data is available
                if let flutterVC = window?.rootViewController as? FlutterViewController {
                    let channel = FlutterMethodChannel(
                        name: "org.ekatimer.ios.gmlpub/widget",
                        binaryMessenger: flutterVC.binaryMessenger
                    )
                    channel.invokeMethod("widgetActionAvailable", arguments: nil)
                }
            }
            return
        }

        // Forward non-ekatimer URLs to FlutterSceneDelegate
        super.scene(scene, openURLContexts: URLContexts)
    }
}
