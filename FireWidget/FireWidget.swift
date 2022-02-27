//
//  Widget_Extension.swift
//  Widget Extension
//
//  Created by Сердюков Евгений on 26.02.2022.
//

import WidgetKit
import SwiftUI
import Intents
import Firebase

struct FireTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> FireTimelineEntry {
        FireTimelineEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (FireTimelineEntry) -> ()) {
        let entry = FireTimelineEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        ImageProvider.getImageFromStorage { response in

            var entries: [FireTimelineEntry] = []
            var policy: TimelineReloadPolicy
            var entry: FireTimelineEntry
            policy = .after(Calendar.current.date(byAdding: .minute, value: 15, to: Date())!)

            switch response {
            case .Failure:
                entry = FireTimelineEntry(date: Date(), image: nil, text: "Connection Error")
                break
            case .Success(let image):
                entry = FireTimelineEntry(date: Date(), image: image, text: "")
                break
            }

            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: policy)
            completion(timeline)

        }
    }
}

struct FireTimelineEntry: TimelineEntry {
    var date: Date
    var image: UIImage?
    var text: String = ""
}

struct FireWidgetEntryView : View {
    var entry: FireTimelineProvider.Entry
    @State var image: UIImage

    init(entry: FireTimelineEntry) {

        self.entry = entry
        self._image = State(initialValue: UIImage(named: "example")!)
        if let image = entry.image {
            self._image = State(initialValue: image)
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center){
                Image(uiImage: image)
                    .resizable()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .background(.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                Text(entry.text)
            }
        }
    }
}

@main
struct FireWidget: Widget {

    init() {
        FirebaseApp.configure()
        try? Auth.auth().useUserAccessGroup("group.FirebaseAuth")
    }

    let kind: String = "FireWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FireTimelineProvider()) { entry in
            FireWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Fire")
        .description("This widget show the images from your Fire friends")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
    }
}
