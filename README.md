# ekaTimer

A simple and distraction-free meditation timer built with Flutter. This project is a 99% vibed-code project.

ekaTimer is inspired by Trevor Slocum's Meditation Assistant and re-implements many of the features from that app.

![ekaTimer](/images/home.png)

![ekaTimer](/images/endat.png)

![ekaTimer](/images/statoverview.png)

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

## Features

* Meditation timer with configurable sessions
* Bell and interval notifications
* Clean and minimalist interface
* Cross-platform Flutter implementation
* Free and open-source software

## Development

To build a signed Android release, create or edit:

`android/key.properties`

```text
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=/path/to/your/keystore.jks
```

## Attribution

This project is a Dart/Flutter re-implementation inspired by Trevor Slocum's Meditation Assistant.

The original project:

* Author: Trevor Slocum
* Source: https://codeberg.org/tslocum/meditationassistant

While ekaTimer is not a fork of the original application, many features and behaviors were derived from studying and re-implementing concepts found in Meditation Assistant. The original project has been an important source of inspiration, and proper credit is gratefully acknowledged.

## License

ekaTimer is licensed under the GNU General Public License v3.0 (GPLv3).

This project is distributed under GPLv3 in recognition of the GPLv3 licensing of the original Meditation Assistant project by by Trevor Slocum and to ensure that users continue to enjoy the same freedoms to use, study, modify, and share the software.

See the [LICENSE](LICENSE) file for the full license text.

## Source Code

GitHub: https://github.com/vpnry/ekatimer

```text 
ekatimer/
  lib/
    main.dart                                    # Entry point
    app.dart                                     # App widget, routing, splash
    providers/
      timer_provider.dart                        # Core timer state machine (533 lines)
      settings_provider.dart                     # Settings state management
      session_provider.dart                      # Session/statistics state management
    services/
      alarm_service.dart                         # Flutter-native bridge for alarms
      notification_service.dart                  # Local notifications
      audio_service.dart                         # Sound playback via audioplayers
      vibration_service.dart                     # Haptic feedback
      persistence_service.dart                   # SharedPreferences key-value store
      database_service.dart                      # SQLite via sqflite
      widget_data_service.dart                   # (Stub) Widget data initialization
      widget_action_handler.dart                 # Widget tap → timer start bridge
      translation_service.dart                   # i18n via JSON files
    models/
      timer_mode.dart                            # Enum: timed, endAt, unlimited
      meditation_session.dart                    # Session data model
      app_settings.dart                          # All user settings
      sound_config.dart                          # Sound configuration
      vibration_config.dart                      # Vibration configuration
    screens/
      home_screen.dart                           # Main timer setup/start screen
      meditation_screen.dart                     # Active timer display
      complete_screen.dart                       # Post-session summary
      settings_screen.dart                       # Full settings
      history_screen.dart                        # Session history list
      stats_screen.dart                          # Charts and statistics
      meditation_screen.dart                     # (Duplicate? unused)
    widgets/
      timer_display.dart                         # Circular countdown widget
      sound_picker.dart                          # Sound selection UI
      vibration_picker.dart                      # Vibration selection UI
      session_card.dart                          # History list item
      stats_summary.dart                         # Home screen stats card
      edit_fixed_presets_dialog.dart             # Duration preset editor
    theme/
      app_theme.dart                             # ThemeData (light/dark)
      colors.dart                                # Color palette
    utils/
      constants.dart                             # App constants
      time_utils.dart                            # Time formatting helpers
  android/
    app/src/main/
      kotlin/org/tipitakapali/ekatimer/
        MainActivity.kt                          # Flutter main activity + alarm init
        AlarmSchedulerPlugin.kt                  # Core: AlarmManager + WakeLock + MediaPlayer
        MeditationTimerWidget.kt                 # Android widget providers (11 widgets)
      AndroidManifest.xml                        # Permissions + receivers + widgets
      res/                                       # Layouts, drawables, widget configs
    app/src/profile/AndroidManifest.xml
    app/src/debug/AndroidManifest.xml
  ios/
    Runner/
      AppDelegate.swift                          # iOS alarm/notification/background handling
      SceneDelegate.swift                        # iOS widget URL deep link handler
      MeditationTimerDeepLink.swift              # ekatimer:// URL scheme handler
      Info.plist                                 # Bundle config + background modes
    MeditationWidget/
      MeditationWidget.swift                     # iOS widget views (11 widgets)
      MeditationWidgetBundle.swift               # Widget bundle entry point
  pubspec.yaml                                   # Flutter dependencies
  assets/
    sounds/                                      # WAV sound files
    translations/                                # JSON i18n files


```