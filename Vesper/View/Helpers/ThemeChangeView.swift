//
//  ThemeChangeView.swift
//  Vesper
//
//  Created by DoubleShy0N on 2024/3/19.
//

import SwiftUI

struct ThemeChangeView: View {
    /// View Properties
    var scheme: ColorScheme
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    /// For Sliding Effect
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 15) {
            SunAndMoon(width: 150, height: 150, scheme: scheme)
            
            Text("Choose a Style")
                .font(.title2.bold())
                .padding(.top, 25)
            
            Text("Pop our subtle, Day or Night.\nCustomize your interface.")
                .multilineTextAlignment(.center)
            
            /// Custom Segmented Picker
            HStack(spacing: 0) {
                ForEach(Theme.allCases, id: \.rawValue) { theme in
                    Text(theme.rawValue)
                        .foregroundStyle(userTheme == theme ? Color.white : Color.primary)
                        .padding(.vertical, 10)
                        .frame(width: 100)
                        .background {
                            ZStack {
                                if userTheme == theme {
                                    Capsule()
                                        .fill(appTint)
                                        .matchedGeometryEffect(id: "ACTIVETHEME", in: animation)
                                }
                            }
                            .animation(.snappy, value: userTheme)
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            userTheme = theme
                        }
                }
            }
            .padding(3)
            .background(.primary.opacity(0.06), in: .capsule)
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: 410)
        .background(userTheme == .dark ? Color.black : Color.white)
        .overlay {
            if userTheme == .dark {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(lineWidth: 0.5)
            }
        }
        .clipShape(.rect(cornerRadius: 30))
        .padding(.horizontal, 15)
        .environment(\.colorScheme, scheme)
    }
}

#Preview {
    ThemeChangeView(scheme: .light)
}
