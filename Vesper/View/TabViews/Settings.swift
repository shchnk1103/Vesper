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
    /// View Properties
    @State private var changeTheme: Bool = false
    @Environment(\.colorScheme) private var scheme
    @AppStorage("tabType") private var tabType: Bool = false
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @State private var alert: AlertConfig = .init(slideEdge: .bottom)
    @State private var avatarColor: Color = appTint
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 12) {
                    Circle()
                        .fill(avatarColor.gradient)
                        .frame(width: 52, height: 52)
                        .overlay {
                            Text("\(userName.prefix(1))")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                        }
                    
                    Text(userName.isEmpty ? "Enter your name" : userName)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
                .onTapGesture {
                    alert.present()
                }
            }
            .onAppear {
                let count = tints.count
                let randomIndex = Int.random(in: 0 ..< count)
                
                avatarColor = tints[randomIndex].value
            }
            
            Section("Appearance") {
                HStack(spacing: 0, content: {
                    HStack {
                        Image(systemName: "circle.lefthalf.filled.inverse")
                            .iconFrame
                        
                        Text("Theme")
                    }
                    
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
                
                Toggle(isOn: $tabType, label: {
                    HStack {
                        Image(systemName: "slider.horizontal.below.square.filled.and.square")
                            .iconFrame
                        
                        Text("Tab Bar Style")
                    }
                })
                .tint(appTint)
            }
            
            Section("App Lock") {
                HStack {
                    Image(systemName: "lock.fill")
                        .iconFrame
                    
                    NavigationLink("Lock Settings") {
                        LockSettingView ()
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .background(.gray.opacity(0.15))
        .sheet(isPresented: $changeTheme, content: {
            ThemeChangeView(scheme: scheme)
                .presentationDetents([.height(410)])
                .presentationBackground(.clear)
        })
        .alert(alertConfig: $alert) {
            EditNameView()
        }
    }
    
    @ViewBuilder
    func EditNameView() -> some View {
        VStack(spacing: 12) {
            Text("Please enter your name! 🎉")
                .font(.title2.bold())
            
            TextField("", text: $userName)
                .padding()
                .background(.secondary.opacity(0.25), in: .rect(cornerRadius: 12))
                .padding(.horizontal, 12)
            
            HStack {
                Spacer()
                
                Button("Cancel") {
                    alert.dismiss()
                }
                .foregroundStyle(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 24)
                .background(.red.gradient, in: .capsule)
                .contentShape(.rect)
                
                Spacer()
                
                Button("Submit") {
                    alert.dismiss()
                }
                .foregroundStyle(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 24)
                .background(.green.gradient, in: .capsule)
                .contentShape(.rect)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(30)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(.background)
                .shadow(radius: 30)
                .padding()
        }
    }
}

extension Image {
    var iconFrame: some View {
        self.frame(width: 24, height: 24)
    }
}

#Preview {
    NavigationStack {
        Settings()
            .environment(SceneDelegate())
    }
}
