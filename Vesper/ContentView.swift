//
//  ContentView.swift
//  Vesper
//
//  Created by DoubleShy0N on 2024/3/12.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    /// Intro Visibility Status
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    /// Active Tab
    @State private var activeTab: SegmentedTab = .recents
    /// Navigation Paths
    @State private var recentPath: NavigationPath = .init()
    @State private var searchPath: NavigationPath = .init()
    @State private var graphPath: NavigationPath = .init()
    @State private var settingPath: NavigationPath = .init()
    @State private var tapCount: Int = .zero
    /// App Lock Properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false
    /// View Properties
    @AppStorage("tabType") private var tabType: Bool = false

    var body: some View {
        LockView(
            lockType: .biometric,
            lockPin: "",
            isEnabled: isAppLockEnabled,
            lockWhenAppGoesBackground: lockWhenAppGoesBackground
        ) {
            TabView(selection: $activeTab,
                    content:  {
                NavigationStack(path: $recentPath) {
                    Recents()
                }
                .toolbarBackground(.hidden, for: .tabBar)
                .tag(SegmentedTab.recents)
                
                NavigationStack(path: $searchPath) {                
                    Search()
                }
                .toolbarBackground(.hidden, for: .tabBar)
                .tag(SegmentedTab.search)
                
                NavigationStack(path: $graphPath) {
                    Graphs()
                }
                .toolbarBackground(.hidden, for: .tabBar)
                .tag(SegmentedTab.charts)
                
                NavigationStack(path: $settingPath) {
                    Settings()
                }
                .toolbarBackground(.hidden, for: .tabBar)
                .tag(SegmentedTab.settings)
            })
            .tint(appTint)
            .sheet(isPresented: $isFirstTime, content: {
                IntroScreen()
                    .interactiveDismissDisabled()
            })
            .overlay(alignment: .bottom) {
                SegmentedControl(
                    tabs: SegmentedTab.allCases,
                    activeTab: $activeTab,
                    activeTint: tabType ? .white : .primary,
                    inActiveTint: .gray.opacity(0.5)
                ) { size in
                    RoundedRectangle(cornerRadius: tabType ? 30 : 2)
                        .fill(appTint)
                        .frame(height: tabType ? size.height : 4)
                        .padding(.horizontal, tabType ? 0 : 10)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
                .background {
                    RoundedRectangle(cornerRadius: tabType ? 30 : 0)
                        .fill(.ultraThinMaterial)
                        .tabSafeArea(tabType)
                        .padding(.top, tabType ? 0 : -10)
                        .shadow(radius: 3, x: 3, y: 3)
                }
                .padding(.horizontal, tabType ? 15 : 0)
            }
        }
    }
    
    var tabSelection: Binding<SegmentedTab> {
        return .init {
            return activeTab
        } set: { newValue in
            if newValue == activeTab {
                tapCount += 1
                
                if tapCount == 2 {
                    switch newValue {
                    case .recents: recentPath = .init()
                    case .search: searchPath = .init()
                    case .charts: graphPath = .init()
                    case .settings: settingPath = .init()
                    }
                    
                    tapCount = .zero
                }
            } else {
                tapCount = .zero
            }
            
            activeTab = newValue
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Transaction.self])
}
