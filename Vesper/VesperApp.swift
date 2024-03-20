//
//  VesperApp.swift
//  Vesper
//
//  Created by DoubleShy0N on 2024/3/12.
//

import SwiftUI
import WidgetKit

@main
struct VesperApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {
                    WidgetCenter.shared.reloadAllTimelines()
                })
        }
        .modelContainer(for: [Transaction.self])
    }
}
