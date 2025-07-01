//
//  CognitionHomeView.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/28/25.
//
// CognitionHomeView.swift
import SwiftUI
import SwiftData

struct CognitionHomeView: View {
    @Environment(\.modelContext) private var ctx

    // Two adaptive columns, min-width of 150 points
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16),
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(BrainActivity.allCases) { activity in
                        NavigationLink {
                            activity.destination(using: ctx)
                        } label: {
                            ActivityCard(activity: activity)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .navigationTitle("Brain Training")
        }
    }
}

private struct ActivityCard: View {
    let activity: BrainActivity
    @Environment(\.modelContext) private var ctx

    var body: some View {
        VStack(spacing: 0) {
            // MARK: — illustration placeholder
            ZStack {
                Rectangle()
                    .fill(.thinMaterial)
                Image(systemName: activity.icon)
                    .font(.system(size: 40))
                    .foregroundColor(.accentColor)
            }
            .frame(height: 100)          // reserve more space for your artwork

            // MARK: — title + progress
            VStack(spacing: 8) {
                Text(activity.title)
                    .font(.headline)
                    .foregroundColor(.primary)

                ProgressView(value: activity.progress(using: ctx))
                    .progressViewStyle(.linear)
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 3)
    }
}

