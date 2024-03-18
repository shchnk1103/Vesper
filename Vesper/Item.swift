//
//  Item.swift
//  Vesper
//
//  Created by DoubleShy0N on 2024/3/12.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
