import SwiftUI
import SwiftData

struct TaskDetailView: View {
    @Bindable var task: Task               // binds directly to model row
    @Environment(\.modelContext) var ctx

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Task title", text: $task.title)
            }

            Section(header: Text("Due")) {
                DatePicker("Date",
                           selection: Binding(
                               get: { task.dueDate ?? Date() },
                               set: { task.dueDate = $0 }
                           ),
                           displayedComponents: [.date, .hourAndMinute])
            }

            Section {
                Toggle("Completed", isOn: $task.isDone)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            try? ctx.save()                // autosave when you leave
        }
    }
}
