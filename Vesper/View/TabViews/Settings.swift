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
    @AppStorage("tabType") private var tabType: Bool = false
    
    var body: some View {
        List {
            Section("User Name") {
                TextField("Enter your name", text: $userName)
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
    }
}

#Preview {
    Settings()
}
