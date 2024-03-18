//
//  CardView.swift
//  Vesper
//
//  Created by DoubleShy0N on 2024/3/12.
//

import SwiftUI

struct CardView: View {
    /// User Properties
    @AppStorage("username") private var userName: String = ""
    /// View Properties
    var income: Double
    var expense: Double
    var isHomeCardView: Bool = true
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        Card()
            .frame(height: 125)
    }
    
    @ViewBuilder
    private func Card() -> some View {
        GeometryReader {
            let rect = $0.frame(in: .scrollView(axis: .vertical))
            let minY = rect.minY
            let topValue: CGFloat = userName.isEmpty ? 88 : 83
            
            let offset = min(minY - topValue, 0)
            let progress = max(min(-offset / topValue, 1), 0)
            let scale: CGFloat = 1 + progress
            
            ZStack {
                Rectangle()
                    .fill(isHomeCardView ? appTint : (scheme == .dark ? .black : .white))
                    .overlay(alignment: .leading) {
                        if isHomeCardView {
                            Circle()
                                .fill(appTint)
                                .overlay {
                                    Circle()
                                        .fill(.white.opacity(0.2))
                                }
                                .scaleEffect(2, anchor: .topLeading)
                                .offset(x: -50, y: -40)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                    .scaleEffect(isHomeCardView ? scale : 1, anchor: .bottom)
                
                VStack(spacing: 0, content: {
                    HStack(spacing: 12, content: {
                        Text("\(currencyString(income - expense))")
                            .font(.title.bold())
                            .foregroundStyle(isHomeCardView ? Color.white : Color.primary)
                        
                        Image(systemName: expense > income ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
                            .font(.title3)
                            .foregroundStyle(expense > income ? .red : .green)
                    })
                    .padding(.bottom, 25)
                    
                    HStack(spacing: 0, content: {
                        ForEach(Category.allCases, id: \.rawValue) { category in
                            let symbolImage = category == .income ? "arrow.down" : "arrow.up"
                            let tint = category == .income ? Color.green : Color.red
                            
                            HStack(spacing: 10, content: {
                                Image(systemName: symbolImage)
                                    .font(.callout.bold())
                                    .foregroundStyle(tint)
                                    .frame(width: 35, height: 35)
                                    .background {
                                        Circle()
                                            .fill(tint.opacity(0.25).gradient)
                                    }
                                
                                VStack(alignment: .leading, spacing: 4, content: {
                                    Text(category.rawValue)
                                        .font(.caption2)
                                        .foregroundStyle(isHomeCardView ? Color.white.opacity(0.75) : Color.gray)
                                    
                                    Text(currencyString(category == .income ? income : expense, allowedDigits: 0))
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(isHomeCardView ? Color.white : Color.primary)
                                })
                                
                                if category == .income {
                                    Spacer(minLength: 10)
                                }
                            })
                        }
                    })
                })
                .padding([.horizontal, .bottom], 25)
                .padding(.top, 15)
            }
            .offset(y: isHomeCardView ? -offset : 0)
            /// Moving till Top Value
            .offset(y: isHomeCardView ? progress * -topValue : 0)
        }
    }
}

#Preview {
    ScrollView {
        CardView(income: 4590, expense: 2389)
    }
    .padding(15)
}
