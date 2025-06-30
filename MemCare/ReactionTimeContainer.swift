//
//  ReactionTimeContainer.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/28/25.
//

//
// ReactionTimeContainer.swift
// MemCare
//

import SwiftUI
import SwiftData    // needed because we’re inserting a Trial model

struct ReactionTimeContainer: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var ctx

    @State private var state: Phase = .waiting
    @State private var startTime: Date = .now
    @State private var lastMs: Double?

    enum Phase { case waiting, ready, tapped }

    var body: some View {
        ZStack {
            Color(state == .ready ? .green : .blue)
                .ignoresSafeArea()
            VStack(spacing: 32) {
                Text(label)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                if let ms = lastMs {
                    Text("Reaction: \(Int(ms)) ms")
                        .foregroundStyle(.white)
                }
            }
        }
        .onAppear { scheduleCue() }
        .onTapGesture { handleTap() }
        .navigationBarBackButtonHidden()
    }

    private var label: String {
        switch state {
        case .waiting: return "Wait for green…"
        case .ready:   return "TAP!"
        case .tapped:  return "Good job"
        }
    }

    private func scheduleCue() {
        state = .waiting
        let delay = Double.random(in: 1.0...3.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            startTime = .now
            state = .ready
        }
    }

    private func handleTap() {
        switch state {
        case .waiting:
            // tapped too soon – reset
            lastMs = nil
            scheduleCue()
        case .ready:
            let ms = Date().timeIntervalSince(startTime) * 1000
            lastMs = ms
            ctx.insert(Trial(ms: ms))
            try? ctx.save()
            state = .tapped
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                dismiss()
            }
        case .tapped:
            break
        }
    }
}
