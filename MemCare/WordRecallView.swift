////
//  WordRecallView.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/30/25.
//

import SwiftUI
import SwiftData

struct WordRecallView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss)      private var dismiss
    
    @Bindable var session: MemorySession          // SwiftData model
    @State private var words: [String] = []
    @State private var index = 0                  // current word
    @State private var correct = 0                // # “I got it”

    var body: some View {
        VStack(spacing: 40) {
            Text("Recall the words")
                .font(.title2.weight(.semibold))

            if !words.isEmpty {
                Text(words[index])
                    .font(.largeTitle)
            }

            HStack(spacing: 20) {
                Button("I got it") {
                    correct += 1
                    advance()
                }
                .buttonStyle(.borderedProminent)

                Button("Missed") { advance() }
                    .buttonStyle(.bordered)
            }

            Spacer()

            Text("\(index + 1) / \(words.count)")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Word Recall")
        .onAppear { words = session.words.shuffled() }
    }

    /// Move to next word or finish + record trial
    private func advance() {
        guard index + 1 < words.count else {
            let trial = RecallTrial(session: session,   // use existing init
                                    correct: correct)
            modelContext.insert(trial)
            try? modelContext.save()
            dismiss()
            return
        }
        index += 1
    }
}

