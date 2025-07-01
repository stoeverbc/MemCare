//
//  RootTabView.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/28/25.
//
// RootTabView.swift

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            // ── Existing “Tasks” tab
            TaskListView()
                .tabItem {
                    Label("Tasks", systemImage: "checkmark.circle")
                }

            // ── Existing “Brain” hub tab
            CognitionHomeView()
                .tabItem {
                    Label("Brain", systemImage: "brain.head.profile")
                }

            // ── NEW “Encode” tab
            MorningEncodeView()
                .tabItem {
                    Label("Encode", systemImage: "sunrise")
                }

            // (later you can add a “Recall” tab here too)
        }
    }
}
