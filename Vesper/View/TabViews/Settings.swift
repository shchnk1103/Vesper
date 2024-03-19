//
//  Settings.swift
//  Vesper
//
//  Created by DoubleShy0N on 2024/3/12.
//

import SwiftUI

struct Settings: View {
    /// User Properties
    @AppStorage("username") private var userName: String = ""
    /// App Lock Properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false
    /// View Properties
    @State private var changeTheme: Bool = false
    @Environment(\.colorScheme) private var scheme
    @AppStorage("tabType") private var tabType: Bool = false
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        List {
            Section("User Name") {
                TextField("Enter your name", text: $userName)
            }
            
            Section("Appearance") {
                HStack(spacing: 0, content: {
                    Text("Appearance")
                    
                    Spacer()
                    
                    Button {
                        changeTheme.toggle()
                    } label: {
                        HStack(spacing: 6, content: {
                            SunAndMoon(width: 24, height: 24, scheme: scheme)
                            
                            Text("\(userTheme.rawValue)")
                                .foregroundStyle(userTheme.color(scheme))
                        })
                    }
                })
            }
            
            Section("App Lock") {
                Toggle("Enable App Lock", isOn: $isAppLockEnabled)
                
                if isAppLockEnabled {
                    Toggle("Lock When App Goes Background", isOn: $lockWhenAppGoesBackground)
                }
            }
            
            Section("Tab Type") {
                Toggle("Change Tab Type", isOn: $tabType)
            }
        }
        .navigationTitle("Settings")
        .background(.gray.opacity(0.15))
        .sheet(isPresented: $changeTheme, content: {
            ThemeChangeView(scheme: scheme)
                .presentationDetents([.height(410)])
                .presentationBackground(.clear)
        })
    }
}

#Preview {
    Settings()
}
