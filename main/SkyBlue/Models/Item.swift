//
//  Item.swift
//  SkyBlue
//
//  Created by Colin Rafferty on 3/17/25.
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
