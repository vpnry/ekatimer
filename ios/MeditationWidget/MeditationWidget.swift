//
//  MeditationWidget.swift
//  MeditationWidget
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry

struct QuickStartEntry: TimelineEntry {
    let date: Date
    let label: String
    let timerMode: String
    let durationMinutes: Int
}

// MARK: - Provider

struct QuickStartProvider: TimelineProvider {
    let label: String
    let timerMode: String
    let durationMinutes: Int

    func placeholder(in context: Context) -> QuickStartEntry {
        QuickStartEntry(date: Date(), label: label, timerMode: timerMode, durationMinutes: durationMinutes)
    }

    func getSnapshot(in context: Context, completion: @escaping (QuickStartEntry) -> Void) {
        completion(QuickStartEntry(date: Date(), label: label, timerMode: timerMode, durationMinutes: durationMinutes))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuickStartEntry>) -> Void) {
        let entry = QuickStartEntry(date: Date(), label: label, timerMode: timerMode, durationMinutes: durationMinutes)
        completion(Timeline(entries: [entry], policy: .never))
    }
}

// MARK: - Widget View (beautiful design with icon + label + "Meditate")

struct QuickStartWidgetView: View {
    let entry: QuickStartEntry
    @Environment(\.colorScheme) var colorScheme

    private var isDark: Bool {
        colorScheme == .dark
    }

    private var bgColor: Color {
        isDark ? Color(red: 0.114, green: 0.114, blue: 0.122) : Color.white
    }

    private var accentColor: Color {
        Color(red: 0.22, green: 0.46, blue: 0.39) // AppColors.primary equivalent
    }

    private var foregroundColor: Color {
        isDark ? Color.white : Color.black
    }

    private var widgetUrl: URL? {
        var components = URLComponents()
        components.scheme = "ekatimer"
        components.host = "start"
        components.queryItems = [
            URLQueryItem(name: "mode", value: entry.timerMode),
            URLQueryItem(name: "duration", value: "\(entry.durationMinutes)")
        ]
        return components.url
    }

    private var sfSymbol: String {
        switch entry.timerMode {
        case "endAt":
            return "clock.badge.checkmark"
        case "unlimited":
            return "infinity"
        default:
            return "leaf.fill"
        }
    }

    var body: some View {
        let content = VStack(spacing: 4) {
            Spacer()

            // Icon
            Image(systemName: sfSymbol)
                .font(.system(size: 22))
                .foregroundColor(accentColor)

            Spacer().frame(height: 2)

            // Duration / action label (large)
            Text(entry.label)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(foregroundColor)

            // "Meditate" label (small, elegant)
            Text("Meditate")
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(foregroundColor.opacity(0.5))
                .textCase(.uppercase)

            Spacer()
        }
        .widgetURL(widgetUrl)

        if #available(iOS 17.0, *) {
            content
                .containerBackground(bgColor, for: .widget)
        } else {
            ZStack {
                bgColor.ignoresSafeArea()
                content
            }
        }
    }
}

// MARK: - Individual Quick-Start Widgets

struct Meditation15mWidget: Widget {
    let kind: String = "Meditation15mWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuickStartProvider(label: "15m", timerMode: "timed", durationMinutes: 15)) { entry in
            QuickStartWidgetView(entry: entry)
        }
        .configurationDisplayName("15m Meditation")
        .description("Start a 15-minute meditation.")
        .supportedFamilies([.systemSmall])
    }
}

struct Meditation30mWidget: Widget {
    let kind: String = "Meditation30mWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuickStartProvider(label: "30m", timerMode: "timed", durationMinutes: 30)) { entry in
            QuickStartWidgetView(entry: entry)
        }
        .configurationDisplayName("30m Meditation")
        .description("Start a 30-minute meditation.")
        .supportedFamilies([.systemSmall])
    }
}

struct Meditation1HWidget: Widget {
    let kind: String = "Meditation1HWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuickStartProvider(label: "1H", timerMode: "timed", durationMinutes: 60)) { entry in
            QuickStartWidgetView(entry: entry)
        }
        .configurationDisplayName("1H Meditation")
        .description("Start a 1-hour meditation.")
        .supportedFamilies([.systemSmall])
    }
}

struct Meditation1_5HWidget: Widget {
    let kind: String = "Meditation1_5HWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuickStartProvider(label: "1.5H", timerMode: "timed", durationMinutes: 90)) { entry in
            QuickStartWidgetView(entry: entry)
        }
        .configurationDisplayName("1.5H Meditation")
        .description("Start a 1.5-hour meditation.")
        .supportedFamilies([.systemSmall])
    }
}

struct Meditation2HWidget: Widget {
    let kind: String = "Meditation2HWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuickStartProvider(label: "2H", timerMode: "timed", durationMinutes: 120)) { entry in
            QuickStartWidgetView(entry: entry)
        }
        .configurationDisplayName("2H Meditation")
        .description("Start a 2-hour meditation.")
        .supportedFamilies([.systemSmall])
    }
}

struct Meditation2_5HWidget: Widget {
    let kind: String = "Meditation2_5HWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuickStartProvider(label: "2.5H", timerMode: "timed", durationMinutes: 150)) { entry in
            QuickStartWidgetView(entry: entry)
        }
        .configurationDisplayName("2.5H Meditation")
        .description("Start a 2.5-hour meditation.")
        .supportedFamilies([.systemSmall])
    }
}

struct Meditation3HWidget: Widget {
    let kind: String = "Meditation3HWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuickStartProvider(label: "3H", timerMode: "timed", durationMinutes: 180)) { entry in
            QuickStartWidgetView(entry: entry)
        }
        .configurationDisplayName("3H Meditation")
        .description("Start a 3-hour meditation.")
        .supportedFamilies([.systemSmall])
    }
}

struct Meditation3_5HWidget: Widget {
    let kind: String = "Meditation3_5HWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuickStartProvider(label: "3.5H", timerMode: "timed", durationMinutes: 210)) { entry in
            QuickStartWidgetView(entry: entry)
        }
        .configurationDisplayName("3.5H Meditation")
        .description("Start a 3.5-hour meditation.")
        .supportedFamilies([.systemSmall])
    }
}

struct Meditation4HWidget: Widget {
    let kind: String = "Meditation4HWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuickStartProvider(label: "4H", timerMode: "timed", durationMinutes: 240)) { entry in
            QuickStartWidgetView(entry: entry)
        }
        .configurationDisplayName("4H Meditation")
        .description("Start a 4-hour meditation.")
        .supportedFamilies([.systemSmall])
    }
}

struct MeditationEndAtWidget: Widget {
    let kind: String = "MeditationEndAtWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuickStartProvider(label: "End", timerMode: "endAt", durationMinutes: 0)) { entry in
            QuickStartWidgetView(entry: entry)
        }
        .configurationDisplayName("End At Meditation")
        .description("Set an end time for your meditation.")
        .supportedFamilies([.systemSmall])
    }
}

struct MeditationUnlimitedWidget: Widget {
    let kind: String = "MeditationUnlimitedWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuickStartProvider(label: "∞", timerMode: "unlimited", durationMinutes: 0)) { entry in
            QuickStartWidgetView(entry: entry)
        }
        .configurationDisplayName("Unlimited Meditation")
        .description("Meditate without a time limit.")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - Previews

@available(iOS 17.0, *)
#Preview(as: .systemSmall) {
    Meditation1HWidget()
} timeline: {
    QuickStartEntry(date: Date(), label: "1H", timerMode: "timed", durationMinutes: 60)
}