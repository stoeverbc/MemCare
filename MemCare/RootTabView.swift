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
            TaskListView()
                .tabItem { Label("Tasks", systemImage: "checklist") }

            CognitionHomeView()
                .tabItem { Label("Brain", systemImage: "brain.head.profile") }
        }
    }
}

