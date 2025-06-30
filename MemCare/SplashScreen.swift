//
//  SplashScreen.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/29/25.

import SwiftUI

struct SplashScreen: View {
    // Bind back to the parent so we can dismiss after 2 s
    @Binding var isActive: Bool

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 16) {
                // Replace "brain.head.profile" with your real logo asset if you have one
                Image(systemName: "brain.head.profile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                    .symbolRenderingMode(.hierarchical)
                Text("MemoryCare")
                    .font(.largeTitle.weight(.bold))
            }
            .opacity(isActive ? 1 : 0)          // fade out on dismiss
            .animation(.easeInOut(duration: 0.4), value: isActive)
        }
        .onAppear {
            // Auto-dismiss after ~2 s
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { isActive = false }
            }
        }
    }
}

