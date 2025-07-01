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
  
  // two columns
  let columns = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16)
  ]
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 16) {
        ForEach(BrainActivity.allCases) { activity in
          NavigationLink {
            activity.destination(using: ctx)
          } label: {
            ActivityCard(activity: activity, ctx: ctx)
          }
          .buttonStyle(.plain)
        }
      }
      .padding(16)
    }
    .navigationTitle("Brain Training")
  }
}

struct ActivityCard: View {
  let activity: BrainActivity
  let ctx: ModelContext
  
  var body: some View {
    VStack(spacing: 12) {
      // upper half: icon placeholder
      ZStack {
        Rectangle()
          .fill(.blue.opacity(0.1))
        Image(systemName: activity.icon)
          .font(.system(size: 36, weight: .regular))
          .foregroundColor(.accentColor)
      }
      .frame(height: 100)
      
      // lower half: title + progress
      VStack(spacing: 8) {
        Text(activity.title)
          .font(.headline)
        ProgressView(value: activity.progress(using: ctx))
          .progressViewStyle(.linear)
      }
      .padding(.horizontal, 8)
      .padding(.bottom, 12)
    }
    .background(.thinMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    .shadow(radius: 3)
  }
}


