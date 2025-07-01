//
//  BrainActivity.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/30/25.
//
//
//  BrainActivity.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/30/25.
//

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
    case .reactionTime: return "Reaction Time"
    case .spatialSpan:  return "Spatial Span"
    case .wordRecall:   return "Word Recall"
    }
  }

  var icon: String {
    switch self {
    case .reactionTime: return "bolt.clock"
    case .spatialSpan:  return "square.grid.3x3.fill"
    case .wordRecall:   return "textformat.abc"
    }
  }

  func progress(using ctx: ModelContext) -> Double {
    switch self {
    case .reactionTime:
      return ctx.hasToday(Trial.self) ? 1 : 0
    case .spatialSpan:
      return ctx.hasToday(SpatialSpanTrial.self) ? 1 : 0
    case .wordRecall:
      guard let session = ctx.todaySession() else { return 0 }
      return ctx.hasRecall(for: session) ? 1 : 0.5
    }
  }

  @ViewBuilder
  func destination(using ctx: ModelContext) -> some View {
    switch self {
    case .reactionTime:
      ReactionTimeContainer()
    case .spatialSpan:
      SpatialSpanContainer()
    case .wordRecall:
        // Guarantee a session exists for today
        let session = ctx.todaySession()
            ?? {
                let s = MemorySession(words: WordBank.sample())
                ctx.insert(s)
                try? ctx.save()
                return s
            }()
        WordRecallView(session: session)

      }
    }
  }

// MARK: - SwiftData helpers

extension ModelContext {
  /// Fetch today’s MemorySession, if any
  func todaySession() -> MemorySession? {
    let start = Calendar.current.startOfDay(for: Date())
    let end   = Calendar.current.date(byAdding: .day, value: 1, to: start)!
    let desc  = FetchDescriptor<MemorySession>(
      predicate: #Predicate {
        $0.date >= start && $0.date < end
      }
    )
    return try? fetch(desc).first
  }

  /// Did we record at least one RecallTrial for that session?
    func hasRecall(for session: MemorySession) -> Bool {
        // Fetch TODAY’s RecallTrials – timestamp comparison is fully supported
        let start = Calendar.current.startOfDay(for: Date())
        let desc  = FetchDescriptor<RecallTrial>(predicate: #Predicate {
            $0.timestamp >= start          // ✅ scalar ≥ comparison only
        })
        
        guard let todaysTrials = try? fetch(desc) else { return false }
        // simple in-memory check avoids any unsupported predicate
        return todaysTrials.contains { $0.sessionID == session.id }
    }
  
  /// Did we record any T-typed model *today*?
  func hasToday<T>(_ type: T.Type) -> Bool
  where T: PersistentModel & Timestamped {
    let start = Calendar.current.startOfDay(for: Date())
    let desc  = FetchDescriptor<T>(
      predicate: #Predicate { $0.timestamp >= start }
    )
    return !( (try? fetch(desc))?.isEmpty ?? true )
  }
}

/// Marker protocol for anything that has a `timestamp`
/// (so we can write the generic `hasToday(_:)` above)
protocol Timestamped { var timestamp: Date { get } }

extension Trial:            Timestamped {}
extension RecallTrial:      Timestamped {}

