//
//  SunAndMoon.swift
//  Vesper
//
//  Created by DoubleShy0N on 2024/3/19.
//

import SwiftUI

struct SunAndMoon: View {
    var width: CGFloat
    var height: CGFloat
    var scheme: ColorScheme
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @State private var circleOffset: CGSize
    
    init(width: CGFloat, height: CGFloat, scheme: ColorScheme) {
        self.width = width
        self.height = height
        self.scheme = scheme
        let isDark = scheme == .dark
        
        self._circleOffset = .init(
            initialValue: CGSize(
                width: isDark ? (width < 150 ? 8 : 30) : width,
                height: isDark ? (height < 150 ? -6 : -25) : -height
            )
        )
    }
    
    var body: some View {
        Circle()
            .fill(userTheme.color(scheme).gradient)
            .frame(width: width, height: height)
            .mask {
                /// Inverted Mask
                Rectangle()
                    .overlay {
                        Circle()
                            .offset(circleOffset)
                            .blendMode(.destinationOut)
                    }
            }
            .onChange(of: scheme, initial: false) { oldValue, newValue in
                let isDark = newValue == .dark
                withAnimation(.bouncy) {
                    circleOffset = CGSize(
                        width: isDark ? (width < 150 ? 8 : 30) : width,
                        height: isDark ? (height < 150 ? -6 : -25) : -height
                    )
                }
            }
    }
}

#Preview {
    SunAndMoon(width: 24, height: 24, scheme: .dark)
}
