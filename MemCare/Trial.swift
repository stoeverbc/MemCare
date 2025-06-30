//
//  Trial.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/28/25.
//

import Foundation
import SwiftData          // ← REQUIRED

@Model                    // ← REQUIRED
final class Trial {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var ms: Double        // reaction-time in ms

    init(ms: Double, at date: Date = .init()) {
        self.id = .init()
        self.timestamp = date
        self.ms = ms
    }
}
