//
//  TestView.swift
//  Vesper
//
//  Created by DoubleShy0N on 2024/3/25.
//

import SwiftUI

struct TestView: View {
    @AppStorage("username") private var userName: String = ""
    @State private var alert: AlertConfig = .init(slideEdge: .bottom)
    
    var body: some View {
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

#Preview {
    TestView()
        .environment(SceneDelegate())
}
