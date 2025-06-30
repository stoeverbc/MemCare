import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Task.title) private var tasksRaw: [Task]

    @State private var newTitle = ""

    var body: some View {
        NavigationStack {
            List {
                // Active section
                Section("Active") {
                    taskRows(tasksRaw.filter { !$0.isDone })
                }
                // Completed section
                Section("Completed") {
                    taskRows(tasksRaw.filter { $0.isDone })
                }
            }
            .navigationTitle("Tasks")

            // ---------- One unified toolbar ----------
            .toolbar {
                // Top-right: Edit / Done toggle
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }

                // Bottom: add-new controls
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        TextField("New Task", text: $newTitle)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 180)

                        Button {
                            let trimmed = newTitle.trimmingCharacters(in: .whitespaces)
                            guard !trimmed.isEmpty else { return }
                            let task = Task(title: trimmed,
                                            dueDate: Date().addingTimeInterval(3600))
                            context.insert(task)
                            try? context.save()
                            newTitle = ""
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }

    // ---------- ROWS ----------
    @ViewBuilder
    private func taskRows(_ subset: [Task]) -> some View {
        ForEach(subset) { task in
            NavigationLink {
                TaskDetailView(task: task)
            } label: {
                rowLabel(for: task)
            }
            // Swipe-to-delete (single item)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    context.delete(task)
                    try? context.save()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        // Bulk delete when list is in Edit mode
        .onDelete { idxSet in
            idxSet.forEach { context.delete(subset[$0]) }
            try? context.save()
        }
    }

    // ---------- SINGLE ROW ----------
    @ViewBuilder
    private func rowLabel(for task: Task) -> some View {
        HStack {
            Button {
                task.isDone.toggle()
                try? context.save()
            } label: {
                Image(systemName: task.isDone
                                 ? "checkmark.circle.fill"
                                 : "circle")
            }
            .buttonStyle(.plain)
            .padding(.trailing, 4)

            Text(task.title)
                .strikethrough(task.isDone)
                .foregroundStyle(task.isDone ? .secondary : .primary)
        }
    }
}

