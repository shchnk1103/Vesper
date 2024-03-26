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
    @State private var path = NavigationPath()
    @State private var recentPath: NavigationPath = .init()
    @State private var searchPath: NavigationPath = .init()
    @State private var graphPath: NavigationPath = .init()
    @State private var settingPath: NavigationPath = .init()
    @State private var tapCount: Int = .zero
    /// App Lock Properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false
    @AppStorage("lockPin") private var lockPin: String = ""
    @AppStorage("lockType") private var lockType: LockType = .both
    /// View Properties
    @AppStorage("tabType") private var tabType: Bool = false
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault

    var body: some View {
        LockView(
            lockType: lockType,
            lockPin: lockPin,
            isEnabled: isAppLockEnabled,
            lockWhenAppGoesBackground: lockWhenAppGoesBackground
        ) {
            NavigationStack(path: $path) {
                ZStack(alignment: .bottom) {
                    switch activeTab {
                    case .recents:
                        Recents()
                            .toolbarBackground(.hidden, for: .tabBar)
                            .tag(SegmentedTab.recents)
                    case .search:
                        Search()
                            .toolbarBackground(.hidden, for: .tabBar)
                            .tag(SegmentedTab.search)
                    case .charts:
                        Graphs()
                            .toolbarBackground(.hidden, for: .tabBar)
                            .tag(SegmentedTab.charts)
                    case .settings:
                        Settings()
                            .toolbarBackground(.hidden, for: .tabBar)
                            .tag(SegmentedTab.settings)
                    }
                }
            }
            .tint(appTint)
            .sheet(isPresented: $isFirstTime, content: {
                IntroScreen()
                    .interactiveDismissDisabled()
            })
            .overlay(alignment: .bottom, content: {
                SegmentedControl(
                    tabs: SegmentedTab.allCases,
                    activeTab: $activeTab,
                    activeTint: tabType ? .white : .primary,
                    inActiveTint: .gray.opacity(0.5),
                    path: $path
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
                        .shadow(color: appTint.opacity(0.25), radius: 8, x: 3, y: 3)
                }
                .padding(.horizontal, tabType ? 15 : 0)
                .padding(.bottom, tabType ? 10 : 0)
            })
            .preferredColorScheme(userTheme.colorScheme)
            .ignoresSafeArea(.keyboard, edges: .bottom)
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
        .environment(SceneDelegate())
        .modelContainer(for: [Transaction.self])
}
