//
//  Item.swift
//  MyMacApp
//
//  Created by Richard Lam on 2/5/2024.
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
