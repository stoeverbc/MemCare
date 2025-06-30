import Foundation
import SwiftData            // ← required!

@Model                      // SwiftData macro
class Task {          // classes need an explicit init

    @Attribute(.unique) var id: UUID
    var title: String
    var dueDate: Date?
    var isDone: Bool

    init(
        id: UUID = .init(),
        title: String = "",
        dueDate: Date? = nil,
        isDone: Bool = false
    ) {
        self.id      = id
        self.title   = title
        self.dueDate = dueDate
        self.isDone  = isDone
    }
}


