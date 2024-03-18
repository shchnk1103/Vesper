//
//  StatusCardViewLiveActivity.swift
//  StatusCardView
//
//  Created by DoubleShy0N on 2024/3/14.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct StatusCardViewAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct StatusCardViewLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StatusCardViewAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension StatusCardViewAttributes {
    fileprivate static var preview: StatusCardViewAttributes {
        StatusCardViewAttributes(name: "World")
    }
}

extension StatusCardViewAttributes.ContentState {
    fileprivate static var smiley: StatusCardViewAttributes.ContentState {
        StatusCardViewAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: StatusCardViewAttributes.ContentState {
         StatusCardViewAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: StatusCardViewAttributes.preview) {
   StatusCardViewLiveActivity()
} contentStates: {
    StatusCardViewAttributes.ContentState.smiley
    StatusCardViewAttributes.ContentState.starEyes
}
