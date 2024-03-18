//
//  ChartModel.swift
//  Vesper
//
//  Created by DoubleShy0N on 2024/3/14.
//

import SwiftUI

struct ChartGroup: Identifiable {
    let id: UUID = .init()
    var date: Date
    var categories: [ChartCategory]
    var totalIncome: Double
    var totalExpense: Double
    
}

struct ChartCategory: Identifiable {
    let id: UUID = .init()
    var totalValue: Double
    var category: Category
}
