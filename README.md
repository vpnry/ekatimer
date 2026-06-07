# ekaTimer

A simple, distraction-free meditation timer built with Flutter.

<img src="/images/home.png" width="180" alt="Home screen">&nbsp;
<img src="/images/endat.png" width="180" alt="End-at screen">&nbsp;
<img src="/images/statoverview.png" width="180" alt="Stats overview">

---

## Overview

ekaTimer is inspired by Trevor Slocum's [Meditation Assistant](https://codeberg.org/tslocum/meditationassistant) and reimplements many of its features in Dart/Flutter. While it is not a fork, the original project was an important source of inspiration and is gratefully acknowledged.

> This program is distributed in the hope that it will be useful, but **WITHOUT ANY WARRANTY**; without even the implied warranty of **MERCHANTABILITY** or **FITNESS FOR A PARTICULAR PURPOSE**.

---

## Features

- Meditation timer with configurable sessions
- Bell and interval notifications
- Clean, minimalist interface
- Cross-platform (Android & iOS)
- Free and open-source (GPLv3)

---

## Building

### Android — signed release

Create or edit `android/key.properties`:

```text
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=/path/to/your/keystore.jks
```

Then run the standard Flutter build command:

```sh
flutter build apk --release
# or
flutter build appbundle --release
```

---

## Project Structure

```
ekatimer/
  lib/
    main.dart                          # Entry point
    app.dart                           # App widget, routing, splash screen
    providers/
      timer_provider.dart              # Core timer state machine
      settings_provider.dart           # Settings state management
      session_provider.dart            # Session and statistics state
    services/
      alarm_service.dart               # Flutter-native alarm bridge
      notification_service.dart        # Local notifications
      audio_service.dart               # Sound playback (audioplayers)
      vibration_service.dart           # Haptic feedback
      persistence_service.dart         # SharedPreferences key-value store
      database_service.dart            # SQLite via sqflite
      widget_data_service.dart         # Home widget data initialisation
      widget_action_handler.dart       # Widget tap → timer start bridge
      translation_service.dart         # i18n via JSON files
    models/
      timer_mode.dart                  # Enum: timed, endAt, unlimited
      meditation_session.dart          # Session data model
      app_settings.dart                # User settings model
      sound_config.dart                # Sound configuration
      vibration_config.dart            # Vibration configuration
    screens/
      home_screen.dart                 # Timer setup and start
      meditation_screen.dart           # Active timer display
      complete_screen.dart             # Post-session summary
      settings_screen.dart             # App settings
      history_screen.dart              # Session history list
      stats_screen.dart                # Charts and statistics
    widgets/
      timer_display.dart               # Circular countdown widget
      sound_picker.dart                # Sound selection UI
      vibration_picker.dart            # Vibration selection UI
      session_card.dart                # History list item
      stats_summary.dart               # Home screen stats card
      edit_fixed_presets_dialog.dart   # Duration preset editor
    theme/
      app_theme.dart                   # ThemeData (light/dark)
      colors.dart                      # Colour palette
    utils/
      constants.dart                   # App-wide constants
      time_utils.dart                  # Time formatting helpers
  android/
    app/src/main/
      kotlin/org/tipitakapali/ekatimer/
        MainActivity.kt                # Flutter activity + alarm initialisation
        AlarmSchedulerPlugin.kt        # AlarmManager, WakeLock, MediaPlayer
        MeditationTimerWidget.kt       # Android home widget providers
      AndroidManifest.xml              # Permissions, receivers, widget declarations
      res/                             # Layouts, drawables, widget configs
  ios/
    Runner/
      AppDelegate.swift                # Alarm, notification, background handling
      SceneDelegate.swift              # Widget URL deep-link handler
      MeditationTimerDeepLink.swift    # ekatimer:// URL scheme handler
      Info.plist                       # Bundle config and background modes
    MeditationWidget/
      MeditationWidget.swift           # iOS home widget views
      MeditationWidgetBundle.swift     # Widget bundle entry point
  pubspec.yaml                         # Flutter dependencies
  assets/
    sounds/                            # WAV audio files
    translations/                      # JSON i18n files
```

---

## Attribution

### Meditation Assistant

ekaTimer is a Dart/Flutter reimplementation inspired by Meditation Assistant, originally authored by Trevor Slocum. While ekaTimer is not a fork, many of its features and behaviours were derived from studying and reimplementing concepts found in that project.

- **Author:** Trevor Slocum
- **Source:** https://codeberg.org/tslocum/meditationassistant

### Audio

**CC0 1.0 Universal (Public Domain)**
`bell.wav`, `gardenbird.wav`, `bowl.wav`, `bowlstrong.wav`, `watch.wav`
— Joseph Sardin ([BigSoundBank.com](https://bigsoundbank.com))

**Creative Commons Attribution 4.0**

| File | Author | Source |
|---|---|---|
| `ThreeBowl.wav` | naturenotesuk | https://freesound.org/s/667491/ |
| `gong.wav` | reinsamba | https://freesound.org/s/46062/ |

---

## License

ekaTimer is licensed under the **GNU General Public License v3.0 (GPLv3)**.

It is distributed under GPLv3 in recognition of the GPLv3 licence applied to Meditation Assistant by Trevor Slocum, and to ensure that users continue to enjoy the same freedoms to use, study, modify, and share the software.

See the [LICENSE](LICENSE) file for the full licence text.

---

## Source Code

GitHub: https://github.com/vpnry/ekatimer