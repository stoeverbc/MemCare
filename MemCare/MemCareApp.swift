//
//  MemCareApp.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/26/25.
//
// MemCareApp.swift

import SwiftUI
import SwiftData

@main
struct MemCareApp: App {
    private let container: ModelContainer = {
        try! ModelContainer(for: Task.self, Trial.self, MemorySession.self, RecallTrial.self)
    }()

    // NEW: track whether splash is still visible
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreen(isActive: $showSplash)
            } else {
                NavigationStack { RootTabView() }
                    .modelContainer(container)
            }
        }
    }
}
