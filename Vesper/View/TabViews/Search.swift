//
//  Search.swift
//  Vesper
//
//  Created by DoubleShy0N on 2024/3/12.
//

import SwiftUI
import Combine

struct Search: View {
    /// View Properties
    @State private var searchText: String = ""
    @State private var filterText: String = ""
    @State private var selectedCategory: Category? = nil
    let searchPublisher = PassthroughSubject<String, Never>()
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 12) {
                FilterTransactionsView(category: selectedCategory, searchText: filterText) { transactions in
                    ForEach(transactions) { transaction in
                        NavigationLink(value: transaction) {
                            TransactionCardView(transaction: transaction, showsCategory: true)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(15)
        }
        .searchable(text: $searchText)
        .overlay {
            ContentUnavailableView("Search Transactions", systemImage: "magnifyingglass")
                .opacity(filterText.isEmpty ? 1 : 0)
        }
        .onChange(of: searchText, { oldValue, newValue in
            if newValue.isEmpty {
                filterText = ""
            }
            searchPublisher.send(newValue)
        })
        .onReceive(searchPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main), perform: { text in
            filterText = text
        })
        .navigationTitle("Search")
        .navigationDestination(for: Transaction.self, destination: { transaction in
            TransactionView(editTransaction: transaction)
        })
        .background(.gray.opacity(0.15))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ToolBarContent()
            }
        }
    }
    
    @ViewBuilder
    func ToolBarContent() -> some View {
        Menu {
            Button(action: {
                selectedCategory = nil
            }, label: {
                HStack {
                    Text("Both")
                    
                    if selectedCategory == nil {
                        Image(systemName: "checkmark")
                    }
                }
            })
            
            ForEach(Category.allCases, id: \.rawValue) { category in
                Button(action: {
                    selectedCategory = category
                }, label: {
                    HStack {
                        Text(category.rawValue)
                        
                        if selectedCategory == category {
                            Image(systemName: "checkmark")
                        }
                    }
                })
            }
        } label: {
            Image(systemName: "slider.vertical.3")
        }
    }
}

#Preview {
    Search()
}
