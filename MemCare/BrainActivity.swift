//
//  BrainActivity.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/30/25.
//
import SwiftUI
import SwiftData
import Foundation

enum BrainActivity: String, CaseIterable, Identifiable {
    case reactionTime, spatialSpan, wordRecall
    var id: String { rawValue }

    var title: String {
        switch self {
        case .reactionTime: "Reaction Time"
        case .spatialSpan:  "Spatial Span"
        case .wordRecall:   "Word Recall"
        }
    }
    var icon: String {
        switch self {
        case .reactionTime: "bolt.clock"
        case .spatialSpan:  "square.grid.3x3.fill"
        case .wordRecall:   "textformat.abc"
        }
    }

    func progress(using ctx: ModelContext) -> Double {
        switch self {
        case .reactionTime: return ctx.hasToday(Trial.self) ? 1 : 0
        case .spatialSpan:  return ctx.hasToday(SpatialSpanTrial.self) ? 1 : 0
        case .wordRecall:
            guard let s = ctx.todaySession() else { return 0 }
            return ctx.hasRecall(for: s) ? 1 : 0.5
        }
    }

    @ViewBuilder
    func destination(using ctx: ModelContext) -> some View {
        switch self {
        case .reactionTime: ReactionTimeContainer()
        case .spatialSpan:  SpatialSpanContainer()
        case .wordRecall:
            if ctx.todaySession() == nil {
                WordEncodeView()
            } else if let s = ctx.todaySession(),
                      !ctx.hasRecall(for: s) {
                WordRecallView(session: s)
            } else {
                WordSummaryView()
            }
        }
    }
}

// MARK: - SwiftData helpers
extension ModelContext {
    func todaySession() -> MemorySession? {
        let start = Calendar.current.startOfDay(for: Date())
        let end   = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        let d = FetchDescriptor<MemorySession>(predicate: #Predicate {
            $0.date >= start && $0.date < end
        })
        return try? fetch(d).first
    }

    func hasRecall(for s: MemorySession) -> Bool {
        // 1. Grab *today’s* recall trials (cheap – usually 0 or 1 rows).
        let start = Calendar.current.startOfDay(for: Date())
        let desc  = FetchDescriptor<RecallTrial>(predicate: #Predicate {
            $0.timestamp >= start           // ← simple, fully-supported predicate
        })

        // 2. Fetch & check in memory.
        guard let trials = try? fetch(desc) else { return false }
        return trials.contains { $0.sessionID == s.id }
    }

    func hasToday<T>(_ t: T.Type) -> Bool where T: PersistentModel & Timestamped {
        let start = Calendar.current.startOfDay(for: Date())
        let d = FetchDescriptor<T>(predicate: #Predicate { $0.timestamp >= start })
        return !( (try? fetch(d))?.isEmpty ?? true )
    }
}

protocol Timestamped { var timestamp: Date { get } }
extension Trial:            Timestamped {}
extension RecallTrial:      Timestamped {}

