//
//  MemoryModels.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/30/25.
//
//  Defines the daily word‑list session and the next‑day recall trial.
//  Add this file to the main target so SwiftData migrates the schema automatically.

import Foundation
import SwiftData

/// A daily list of words shown to the user for later recall.
@Model
class MemorySession {
    /// Stable primary key so we can link trials back.
    @Attribute(.unique) var id: UUID
    /// Session creation date in the user’s current calendar & time‑zone.
    var date: Date
    /// The 5‑word list presented (transformable).
    var words: [String]

    init(id: UUID = UUID(), date: Date = .now, words: [String]) {
        self.id = id
        self.date = date
        self.words = words
    }
}

/// A user’s recall attempt scored against its originating `MemorySession`.
@Model
final class RecallTrial {
    /// Primary key so trials survive sync/merge.
    @Attribute(.unique) var id: UUID = UUID()
    /// When the recall happened (usually next‑day).
    var timestamp: Date = Date()
    /// Number of correctly recalled words (0–5).
    var correct: Int = 0
    
    var sessionID: UUID
    /// Weak link back to the `MemorySession`. `.nullify` keeps the trial if a session is purged.
    @Relationship(deleteRule: .nullify) var session: MemorySession?

    init(session: MemorySession, correct: Int) {
        self.sessionID = session.id
        self.timestamp = timestamp
        self.correct = correct
        self.session = session
    }
}

