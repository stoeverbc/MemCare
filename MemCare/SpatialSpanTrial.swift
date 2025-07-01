//
//  SpatialSpanTrial.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/30/25.
//
// SpatialSpanTrial.swift
import Foundation
import SwiftData

@Model
final class SpatialSpanTrial: Timestamped {
    @Attribute(.unique) var id: UUID = UUID()
    var timestamp: Date = Date()        // use Date(), not .now

    init() {}                           // <- satisfies the macro
}
