# ekaTimer App — Design & Implementation Report

## Overview

ekaTimer is a modern, cross-platform meditation timer app built with Flutter 3.44. It was designed from scratch based on the architectural ideas of the original Android-native MeditationAssistant, but completely rebuilt as a modern Flutter application with improved architecture, state management, and UI.

**Project location:** `meditation_timer/`  
**Tech stack:** Flutter 3.44 / Dart 3.12, Provider (state management), SQLite (session history), SharedPreferences (settings)

---

## 1. Architecture

### Design Pattern — Provider + ChangeNotifier

The app uses **Provider** for state management with three core providers:

| Provider | Responsibility |
|---|---|
| `TimerProvider` | Manages active meditation session state, timer tick, pause/resume, interval sounds, session persistence |
| `SettingsProvider` | Manages all user preferences, loads/saves from SharedPreferences |
| `SessionProvider` | Manages session history, streak calculations, statistics |

### Directory Structure

```
meditation_timer/lib/
├── main.dart              # Entry point, provider setup
├── app.dart               # MaterialApp, theme management, session recovery
├── models/                # Data models
│   ├── timer_mode.dart
│   ├── meditation_session.dart
│   ├── sound_config.dart
│   ├── vibration_config.dart
│   └── app_settings.dart
├── services/              # Business logic & platform integrations
│   ├── database_service.dart     # SQLite (session history)
│   ├── persistence_service.dart  # SharedPreferences (settings + session state)
│   ├── audio_service.dart        # Sound playback
│   ├── vibration_service.dart    # Haptic feedback
│   └── notification_service.dart # Daily reminders
├── providers/             # State management
│   ├── timer_provider.dart
│   ├── settings_provider.dart
│   └── session_provider.dart
├── screens/               # UI screens
│   ├── home_screen.dart         # Timer config, start button, stats summary
│   ├── meditation_screen.dart   # Active meditation UI
│   ├── complete_screen.dart     # Post-session summary
│   ├── history_screen.dart      # Session history (grouped by date)
│   ├── stats_screen.dart        # Statistics with charts
│   └── settings_screen.dart     # All configurable preferences
├── widgets/               # Reusable widgets
│   ├── timer_display.dart        # Animated circular timer
│   ├── session_card.dart         # Session history entry
│   ├── stats_summary.dart        # Quick stats cards
│   ├── sound_picker.dart         # Sound selector
│   └── vibration_picker.dart     # Vibration selector
├── theme/
│   ├── colors.dart               # Zen-inspired color palette
│   └── app_theme.dart            # Light & dark themes
└── utils/
    ├── constants.dart             # App-wide constants
    └── time_utils.dart            # Time formatting utilities
```

---

## 2. Timer System

### Three Timer Modes (inspired by original)

| Mode | Behavior | Display |
|---|---|---|
| **Timed** | Countdown from configured duration (5–480 min) | Shows time remaining |
| **End At** | Ends at a specific time of day | Shows elapsed time |
| **Unlimited** | Runs indefinitely until user stops | Shows elapsed time |

### Timer Implementation

- **Tick loop:** `Timer.periodic` every 500ms (`timerTickIntervalMs`)
- **Elapsed calculation:** `DateTime.now().difference(sessionStart) - totalPauseDuration`
- **Pause tracking:** Records `pauseStart` timestamp; on resume, calculates pause duration and adjusts `endTime` accordingly
- **Interval sounds:** Tracks `_lastIntervalMinute` and `_lastBellMinute` to avoid duplicate triggers
- **Auto-complete:** When `remainingSeconds <= 0`, triggers `_onSessionComplete()` which saves the session and navigates to the completion screen

### Process Death Persistence (Key improvement over original!)

**The original app lost all session state on process death.** ekaTimer fixes this:

1. **On session start:** State is persisted via `PersistenceService.saveActiveSession()` to SharedPreferences
2. **On state change:** Pause/resume also persist
3. **On app launch:** `_AppEntry._checkForActiveSession()` checks for saved state
4. **On recovery:** `TimerProvider.restoreSession()` reconstructs the session, restores sound/vibration settings, and starts the tick loop
5. **On completion/stop:** Persisted state is cleared

---

## 3. Audio & Haptic Feedback

### Sound System
- Singleton `AudioService` using `audioplayers` package
- 8 built-in sound options: Temple Bell, Metal Gong, Heavy Gong, Tingsha, Singing Bowl, Wind Chime, Soft Rain, Om Chant
- Sounds play at start, end, and configurable intervals
- Configurable volume (0–100%)

### Vibration System
- Singleton `VibrationService` using `vibration` package
- 5 patterns: None, Short, Medium, Long, Double
- Vibrates on start, end, and interval events

### Screen Control
- Uses `wakelock_plus` to keep screen on during meditation
- Settings support: Stay On, Dim, Normal (configurable)

---

## 4. Session History & Statistics

### Database (SQLite via `sqflite`)
- Sessions stored with: `id`, `startTime`, `endTime`, `durationSeconds`, `targetDurationSeconds`, `timerMode`, `completed`, `notes`
- Full CRUD operations via `DatabaseService`

### Key Metrics Tracked
| Metric | Calculation |
|---|---|
| Current streak | Consecutive days with ≥1 session |
| Longest streak | Historical max consecutive days |
| Total sessions | All-time session count |
| Total duration | Sum of all session durations |
| Average duration | Mean session duration |
| Today/Week/Month | Total meditation time for period |

### Charts & Visualization
- Weekly bar chart (last 8 weeks)
- Monthly bar chart (last 12 months)
- Statistics screen with Overview, Weekly, and Monthly tabs

---

## 5. Daily Reminders

- Uses `flutter_local_notifications` for cross-platform notifications
- Configurable time (default 19:00)
- Uses `periodicallyShow` with `RepeatInterval.daily` and `AndroidScheduleMode.inexactAllowWhileIdle`
- Toggle on/off from Settings

---

## 6. UI/UX Design

### Visual Design Language
- **Zen-inspired** color palette with primary blue (#5B8DEF) and warm accent (#FFB347)
- **Light & dark theme** support with full `ThemeData` definitions
- **Gradient backgrounds** that change based on time of day (sunrise, ocean, sunset, night)
- **Smooth animations:** Fade transitions between screens, pulse animation on meditation screen, animated timer display

### Key Screens
1. **Home:** Mode selector (pill-style tabs), duration picker with presets + slider, start button with glow effect, stats summary row
2. **Meditation:** Full-screen gradient background, large circular timer with progress arc, pause/resume/stop controls, stop confirmation dialog
3. **Complete:** Animated checkmark, duration display, streak badge, mini stats row, back-to-home button
4. **History:** Sessions grouped by date, per-session cards with time-of-day icons, delete option
5. **Stats:** Overview cards, period breakdown, weekly/monthly bar charts
6. **Settings:** Sections for Timer, Sound, Interval/Bell, Vibration, Display, Daily Reminder

### Responsiveness
- Custom `_buildTimePickerWheel` replaced with proper `ListWheelScrollView` for time selection
- Wrapped content in `CustomScrollView` with `SliverAppBar`
- All UI elements use `SafeArea` for notch compatibility

---

## 7. Key Improvements Over Original

| Feature | Original (Android Native) | ekaTimer (Flutter) |
|---|---|---|
| **Session persistence** | ❌ In-memory only, lost on process death | ✅ Persisted to SharedPreferences, recovered on relaunch |
| **State restoration** | ❌ No `onSaveInstanceState` | ✅ Full session state restored including pause state |
| **Cross-platform** | ❌ Android only | ✅ iOS & Android |
| **Theme** | ❌ Light only | ✅ Light + Dark + System modes |
| **Sound settings** | ❌ Separate config per event | ✅ Unified sound picker with preview |
| **UI animations** | ❌ Minimal | ✅ Smooth transitions, pulse animations, gradient backgrounds |
| **Statistics** | ❌ Basic | ✅ Charts, streaks, weekly/monthly breakdowns |
| **Architecture** | ❌ Monolithic Activity | ✅ Provider + ChangeNotifier separation of concerns |

---

## 8. Dependencies

```yaml
provider: ^6.1.2          # State management
sqflite: ^2.4.1           # SQLite database
path_provider: ^2.1.5     # File system paths
shared_preferences: ^2.3.4 # Key-value storage
audioplayers: ^6.1.0      # Audio playback
vibration: ^3.0.0         # Haptic feedback
wakelock_plus: ^1.2.10    # Screen keep-on
flutter_local_notifications: ^18.0.1  # Notifications
intl: ^0.20.2             # Internationalization
uuid: ^4.5.1              # Unique IDs
```

---

## 9. Build Status

**`flutter analyze` — No issues found.** ✅

---

## 10. Setup & Running

```bash
cd meditation_timer
flutter pub get
flutter run          # Run on connected device/emulator
flutter build apk    # Build Android APK
flutter build ios    # Build iOS (requires macOS + Xcode)
```

### Sound Assets
Add meditation sound files to `assets/sounds/` as `.mp3` files named after the keys in `AppConstants.builtInSounds`:
- `bell_temple.mp3`, `gong_metal.mp3`, `gong_heavy.mp3`, `tinsha.mp3`
- `singing_bowl.mp3`, `chime.mp3`, `rain.mp3`, `om.mp3`

Without these files, sounds will silently fail (no crash).

---

## 11. File Listing

| File | Lines | Purpose |
|---|---|---|
| `lib/main.dart` | ~25 | Entry point, service init, provider setup |
| `lib/app.dart` | ~145 | App widget, theme, splash, session recovery |
| `lib/models/timer_mode.dart` | ~50 | TimerMode enum |
| `lib/models/meditation_session.dart` | ~85 | Session data model |
| `lib/models/sound_config.dart` | ~55 | Sound configuration |
| `lib/models/vibration_config.dart` | ~45 | Vibration configuration |
| `lib/models/app_settings.dart` | ~45 | Aggregated settings model |
| `lib/services/database_service.dart` | ~195 | SQLite operations |
| `lib/services/persistence_service.dart` | ~135 | SharedPreferences operations |
| `lib/services/audio_service.dart` | ~45 | Audio playback |
| `lib/services/vibration_service.dart` | ~55 | Haptic feedback |
| `lib/services/notification_service.dart` | ~95 | Daily reminders |
| `lib/providers/timer_provider.dart` | ~290 | Timer state management |
| `lib/providers/settings_provider.dart` | ~180 | Settings state |
| `lib/providers/session_provider.dart` | ~155 | Session history + stats |
| `lib/screens/home_screen.dart` | ~350 | Main screen |
| `lib/screens/meditation_screen.dart` | ~270 | Active meditation |
| `lib/screens/complete_screen.dart` | ~220 | Post-session summary |
| `lib/screens/history_screen.dart` | ~180 | Session list |
| `lib/screens/stats_screen.dart` | ~290 | Statistics + charts |
| `lib/screens/settings_screen.dart` | ~300 | All settings |
| `lib/widgets/timer_display.dart` | ~120 | Animated timer |
| `lib/widgets/session_card.dart` | ~120 | Session entry card |
| `lib/widgets/stats_summary.dart` | ~85 | Quick stats |
| `lib/widgets/sound_picker.dart` | ~70 | Sound selector |
| `lib/widgets/vibration_picker.dart` | ~70 | Vibration selector |
| `lib/theme/colors.dart` | ~55 | Color palette |
| `lib/theme/app_theme.dart` | ~175 | Light/dark themes |
| `lib/utils/constants.dart` | ~95 | App constants |
| `lib/utils/time_utils.dart` | ~80 | Time helpers |

**Total: ~30 files, ~3,600 lines of Dart code** (excluding generated files)
