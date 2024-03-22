//
//  Recents.swift
//  Vesper
//
//  Created by DoubleShy0N on 2024/3/12.
//

import SwiftUI
import SwiftData

struct Recents: View {
    /// User Properties
    @AppStorage("username") private var userName: String = ""
    /// View Properties
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var selectedCategory: Category = .expense
    /// For Animation
    @Namespace private var animation
    /// Alert
    @State private var alert: AlertConfig = .init(disableOutsideTap: false, slideEdge: .leading)
    
    var body: some View {
        GeometryReader {
            /// For Animation Purpose
            let size = $0.size
            
            ScrollView(.vertical) {
                HeaderView(size)
                    .padding(.horizontal, 15)
                    .padding(.top, 15)
                    
                LazyVStack(spacing: 10, content: {
                    /// Date Filter Button
                    Button(action: {
                        // showFilterView = true
                        alert.present()
                    }, label: {
                        HStack(spacing: 5, content: {
                            Circle()
                                .fill(appTint.gradient)
                                .frame(height: 15)
                            
                            Text("\(format(date: startDate, format: "dd-MMM-yyyy")) to \(format(date: endDate, format: "dd-MMM-yyyy"))")
                                .font(.caption2)
                                .foregroundStyle(.gray)
                        })
                    })
                    .frame(height: 25)
                    .padding(.horizontal, 5)
                    .hSpacing(.leading)
                    .padding(.horizontal, 15)
                    
                    FilterTransactionsView(startDate: startDate, endDate: endDate) { transactions in
                        /// Card View
                        CardView(
                            income: total(transactions, category: .income),
                            expense: total(transactions, category: .expense)
                        )
                        .padding(.horizontal, 15)
                        
                        LazyVStack {
                            /// Custom Segmented Control
                            CustomSegmentedControl()
                                .padding(.vertical, 10)
                            
                            ForEach(transactions.filter({ $0.category == selectedCategory.rawValue })) { transaction in
                                NavigationLink(value: transaction) {
                                    TransactionCardView(transaction: transaction)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 15)
                        .mask {
                            Rectangle()
                                .visualEffect { content, geometryProxy in
                                    content
                                        .offset(y: backgroundLimitOffset(geometryProxy))
                                }
                        }
                        .background {
                            Rectangle()
                                .fill(Color.clear)
                                .visualEffect { content, geometryProxy in
                                    content
                                        .offset(y: backgroundLimitOffset(geometryProxy))
                                }
                        }
                    }
                })
            }
            .scrollTargetBehavior(CustomScrollBehavior())
            .scrollIndicators(.hidden)
            .background(.gray.opacity(0.15))
            .navigationDestination(for: Transaction.self) { transaction in
                TransactionView(editTransaction: transaction)
            }
        }
        .alert(alertConfig: $alert) {
            DateFilterView(start: startDate, end: endDate, onSubmit: { start, end in
                startDate = start
                endDate = end
                alert.dismiss()
            }, onClose: {
                alert.dismiss()
            })
        }
    }
    
    /// Header View
    @ViewBuilder
    func HeaderView(_ size: CGSize) -> some View {
        HStack(spacing: 10, content: {
            VStack(alignment: .leading, spacing: 5, content: {
                Text("Welcome!")
                    .font(.title.bold())
                
                if !userName.isEmpty {
                    Text(userName)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            })
            .frame(height: 45)
            .visualEffect { content, geometryProxy in
                content
                    .scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .topLeading)
            }
            
            Spacer(minLength: 0)
            
            NavigationLink {
                TransactionView()
            } label: {
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 45, height: 45)
                    .background(appTint.gradient, in: .circle)
                    .contentShape(.circle)
            }
        })
        .padding(.bottom, userName.isEmpty ? 10 : 5)
    }
    
    /// Segmented Control
    @ViewBuilder
    func CustomSegmentedControl() -> some View {
        HStack(spacing: 0, content: {
            ForEach(Category.allCases, id: \.rawValue) { category in
                Text(category.rawValue)
                    .hSpacing()
                    .padding(.vertical, 10)
                    .background {
                        if category == selectedCategory {
                            Capsule()
                                .fill(.background)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    }
                    .contentShape(.capsule)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedCategory = category
                        }
                    }
            }
        })
        .background(.gray.opacity(0.15), in: .capsule)
        .padding(.top, 5)
    }
    
    /// Background Limit Offset
    func backgroundLimitOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        
        return minY < 134 ? -minY + 136 : 0
    }
    
    func headerBGOpacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY + safeArea.top
        return minY > 0 ? 0 : (-minY / 15)
    }
    
    func headerScale(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        let screenHeight = size.height
        
        let progress = minY / screenHeight
        let scale = (min(max(progress, 0), 1)) * 0.3
        
        return scale + 1
    }
}

/// Custom Scroll Target Behavior
struct CustomScrollBehavior: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < 83 {
            target.rect = .zero
        }
    }
}

#Preview {
    ContentView()
        .environment(SceneDelegate())
        .modelContainer(for: [Transaction.self])
}
