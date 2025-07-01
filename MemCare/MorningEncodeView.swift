//
//  MorningEncodeView.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/30/25.
//
import SwiftUI
import SwiftData

struct MorningEncodeView: View {
    @Environment(\.modelContext) private var context
    @State private var words: [String] = []
    @State private var currentIndex = 0

    var body: some View {
        VStack {
            if !words.isEmpty {
                Text(words[currentIndex])
                    .font(.largeTitle.weight(.semibold))
                    .transition(.opacity)
                    .padding()
            } else {
                ProgressView("Loading…")
                    .padding()
            }
        }
        .onAppear {
            startSession()
        }
        .task(id: words) {
            guard words.count > 1 else { return }
            for i in 1..<words.count {
                try? await _Concurrency.Task.sleep(nanoseconds: 2_000_000_000)  // ← uppercase “Task”
                withAnimation {
                    currentIndex = i
                }
            }
        }
    }

    private func startSession() {
        let sampled = WordBank.sample()
        words = sampled

        let session = MemorySession(words: sampled)
        context.insert(session)
    }
}
