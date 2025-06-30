//
//  BrainActivity.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/29/25.
//
import SwiftUI

/// All brain-training tasks that can appear on the home screen.
enum BrainActivity: String, CaseIterable, Identifiable {
    case reactionTime
    case spatialSpan
    case wordRecall
    // add more as you build them

    var id: String { rawValue }                      // Identifiable

    var title: String {
        switch self {
        case .reactionTime: return "Reaction Time"
        case .spatialSpan:  return "Spatial Span"
        case .wordRecall:   return "Word Recall"
        }
    }

    /// SF Symbol that represents the task (placeholder).
    var symbol: String {
        switch self {
        case .reactionTime: return "bolt.circle"
        case .spatialSpan:  return "square.grid.3x3"
        case .wordRecall:   return "textformat.abc"
        }
    }

    /// Color accent for the card (optional eye-candy).
    var color: Color {
        switch self {
        case .reactionTime: return .orange
        case .spatialSpan:  return .blue
        case .wordRecall:   return .purple
        }
    }
}

