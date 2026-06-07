//
//  MeditationTimerDeepLink.swift
//  Runner
//
//  Handles the ekatimer:// custom URL scheme from widget taps.
//  Parses the query parameters and stores them so the Flutter side can
//  retrieve them via the getWidgetAction method channel.
//
//  NOTE: On iOS 13+ with UIScene support, widget-tap URLs arrive through
//  SceneDelegate.scene(_:openURLContexts:), so this AppDelegate override
//  acts only as a fallback for legacy / non-scene configurations.
//  Both paths must parse the URL identically.
//

import Flutter
import UIKit

extension AppDelegate {

    /// Handle widget URL deep links.
    /// On UIScene-enabled apps (iOS 13+) this is typically NOT called for
    /// widget taps — SceneDelegate receives them instead.  Kept for correctness
    /// on devices / configurations that bypass the scene lifecycle.
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        guard url.scheme == "ekatimer" else { return false }

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let host = components.host else {
            return true
        }

        if host == "start" {
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

            // Carry the Unix end-timestamp for "endAt" widgets so Flutter can
            // jump straight to the countdown rather than opening configuration.
            if mode == "endAt", let endAtStr = param("endAt"), let endAt = Int(endAtStr) {
                data["endAt"] = endAt
            }

            self.setWidgetActionData(data)

            // Notify Flutter immediately (engine is already running in this path).
            if let flutterVC = self.window?.rootViewController as? FlutterViewController {
                FlutterMethodChannel(
                    name: "org.ekatimer.ios.gmlpub/widget",
                    binaryMessenger: flutterVC.binaryMessenger
                ).invokeMethod("widgetActionAvailable", arguments: nil)
            }
        }

        return true
    }
}
