//
//  HomescreenWidget.swift
//  HomescreenWidget
//
//  Created by BerkH on 4.10.2023.
//

import WidgetKit
import SwiftUI
import Shared

struct Provider: TimelineProvider {
    func snapshot(in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), title: "")
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), title: "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        if let readers = Reader.shared.readers, !readers.isEmpty {
            var firstThreeTitles: [String] = []

            for i in 0..<min(3, readers.count) {
                let reader = readers[i]
                let title = reader.title ?? "Title-not-found"
                firstThreeTitles.append(title)
            }

            let title = firstThreeTitles.joined(separator: ", ")
            let entry = SimpleEntry(date: .now, title: title, firstThreeEntries: firstThreeTitles)
            entries.append(entry)
            print(entries)
        } else {
            let entry = SimpleEntry(date: .now, title: "No-title-available")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    let title: String
    let firstThreeEntries: [String]

    init(date: Date, title: String = "", firstThreeEntries: [String] = []) {
        self.date = date
        self.title = title
        self.firstThreeEntries = firstThreeEntries
    }
}

struct HomescreenWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        switch widgetFamily {
            
        case .systemMedium:
            if entry.firstThreeEntries.count >= 3 {
                Text("Title 1: \(entry.firstThreeEntries[0])")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Title 2: \(entry.firstThreeEntries[1])")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Title 3: \(entry.firstThreeEntries[2])")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("Not enough data available")
            }
        default:
            Text("Title: Not Available")
        }
    }
}

struct HomescreenWidget: Widget {
    let kind: String = "HomescreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HomescreenWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HomescreenWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemMedium, .systemLarge, .accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}

