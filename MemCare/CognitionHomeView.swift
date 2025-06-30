//
//  CognitionHomeView.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/28/25.
//
// CognitionHomeView.swift

import SwiftUI
import SwiftData
import Charts

// MARK: - 2. Home screen
struct CognitionHomeView: View {
    @State private var navPath = NavigationPath()

    // Same SwiftData query you already had
    @Query(sort: \Trial.timestamp, order: .reverse)
    private var recentTrialsRaw: [Trial]

    private var recentTrials: [Trial] {
        Array(recentTrialsRaw.prefix(5))   // keep ≤ 5 rows
    }

    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                VStack(spacing: 32) {

                    // ── Sparkline ─────────────────────────
                    if recentTrials.count >= 2 {
                        Chart(recentTrials.reversed()) { t in
                            LineMark(
                                x: .value("Order", t.timestamp),
                                y: .value("RT", t.ms)
                            )
                            .interpolationMethod(.catmullRom)
                        }
                        .chartYAxis { AxisMarks(position: .leading) }
                        .frame(height: 80)
                        .padding(.horizontal, 32)
                    }

                    // ── Five-row list ─────────────────────
                    VStack(spacing: 4) {
                        ForEach(recentTrials) { t in
                            HStack {
                                Text(t.timestamp, format: .dateTime.hour().minute())
                                Spacer()
                                Text("\(Int(t.ms)) ms")
                                    .monospacedDigit()
                            }
                            .font(.caption)
                            Divider()
                        }
                    }
                    .padding(.horizontal, 32)

                    // ── Task grid ─────────────────────────
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 24) {
                        ForEach(BrainActivity.allCases) { act in
                            NavigationLink(value: act) {
                                ActivityCard(act)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Brain Training")
            .navigationDestination(for: BrainActivity.self) { act in
                switch act {
                case .reactionTime: ReactionTimeContainer()
                case .spatialSpan:  Text("Spatial Span coming soon")
                case .wordRecall:   Text("Word Recall coming soon")
                }
            }
        }
    }
}

// MARK: - 3. Card view
private struct ActivityCard: View {
    let activity: BrainActivity
    init(_ a: BrainActivity) { activity = a }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(activity.color.opacity(0.15))
                .frame(height: 120)
            VStack(spacing: 12) {
                Image(systemName: activity.symbol)
                    .font(.system(size: 32))
                    .foregroundStyle(activity.color)
                Text(activity.title)
                    .font(.headline)
            }
        }
    }
}
