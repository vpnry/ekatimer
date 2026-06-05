//
//  MeditationTimerDeepLink.swift
//  Runner
//
//  Handles the ekatimer:// custom URL scheme from widget taps.
//  Parses the query parameters and stores them so the Flutter side can
//  retrieve them via the getWidgetAction method channel.
//

import Flutter
import UIKit

extension AppDelegate {

    /// Handle widget URL deep links. Called automatically when the app
    /// receives a URL with the ekatimer:// scheme.
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        guard url.scheme == "ekatimer" else { return false }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let host = components.host else {
            return true
        }
        
        if host == "start" {
            let queryItems = components.queryItems ?? []
            let mode = queryItems.first(where: { $0.name == "mode" })?.value ?? "timed"
            let durationStr = queryItems.first(where: { $0.name == "duration" })?.value ?? "0"
            let duration = Int(durationStr) ?? 0
            
            let data: [String: Any] = [
                "timerMode": mode,
                "timerDuration": duration
            ]
            self.setWidgetActionData(data)
        }
        
        return true
    }
}
