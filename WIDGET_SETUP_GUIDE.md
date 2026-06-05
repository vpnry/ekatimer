# Widget Setup Guide

> **Android widgets are fully ready.** iOS widgets require a one-time Xcode setup.

## Prerequisites

- Xcode 15+ (for WidgetKit and the widget extension target)
- An Apple Developer account (for App Groups capability)

---

## iOS - Add Widget Extension in Xcode

1. **Open the project in Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Add a Widget Extension target:**
   - File → New → Target...
   - Search for "Widget Extension"
   - Name: `MeditationWidget`
   - Bundle Identifier: `org.ekatimer.ios.gmlpub.MeditationWidget`
   - Language: Swift
   - Uncheck "Include Configuration App Intent"
   - Click Finish

3. **Replace the generated files:**
   - Xcode will create `MeditationWidget.swift` and `MeditationWidgetBundle.swift`
   - Delete these generated files
   - In Finder, the widget files are already at:
     ```
     ios/MeditationWidget/MeditationWidget.swift
     ios/MeditationWidget/MeditationWidgetBundle.swift
     ios/MeditationWidget/Info.plist
     ```
   - Drag the `ios/MeditationWidget` folder into Xcode under the `MeditationWidget` target

4. **Add App Groups capability to the main app:**
   - Select the `Runner` target → Signing & Capabilities
   - Click "+" → "App Groups"
   - Add group: `group.org.ekatimer.ios.gmlpub.shared`
   - Enable the group checkbox

5. **Add App Groups capability to the widget extension:**
   - Select the `MeditationWidget` target → Signing & Capabilities
   - Click "+" → "App Groups"
   - Add group: `group.org.ekatimer.ios.gmlpub.shared`
   - Enable the group checkbox

6. **Update the main app's Info.plist:**
   - The URL scheme for `ekatimer://` is already configured in `ios/Runner/Info.plist`

7. **Update the Deep Link file:**
   - The file `ios/Runner/MeditationTimerDeepLink.swift` is already created
   - In Xcode, add it to the Runner target (drag it into the Runner group)

8. **Build & Run:**
   - Select a scheme that includes the widget (Runner should auto-detect)
   - Build and run on a simulator or device

---

## Android - No Setup Needed

The Android widgets are fully configured with:
- Widget provider: `android/app/src/main/kotlin/org/tipitakapali/ekatimer/MeditationTimerWidget.kt`
- Layouts: `widget_quickstart.xml` and `widget_stats.xml`
- Manifest: 7 widget receivers registered

Just rebuild the app and the widgets will appear in the Android widget picker.

---

## Verifying Widget Data

1. Open the app and complete a meditation session
2. The stats data is automatically written to shared preferences
3. On Android, add a widget from the picker
4. On iOS, add a widget from the widget gallery (long-press home screen → "+")
