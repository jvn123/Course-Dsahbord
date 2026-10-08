import Foundation

struct Course: Codable, Identifiable, Hashable, Sendable {
    let id: Int
    var title: String
    var instructor: String
    var lessons: [Lesson]
    var progress: Int

    init(id: Int, title: String, instructor: String, lessons: [Lesson], progress: Int? = nil) {
        self.id = id
        self.title = title
        self.instructor = instructor
        self.lessons = lessons
        self.progress = progress ?? ProgressCalculator.percentage(
            completed: lessons.filter(\.isCompleted).count,
            total: lessons.count
        )
    }

    var lessonCount: Int { lessons.count }
}

struct Lesson: Codable, Identifiable, Hashable, Sendable {
    let id: Int
    var title: String
    var isCompleted: Bool
}

enum ProgressCalculator {
    nonisolated static func percentage(completed: Int, total: Int) -> Int {
        guard total > 0 else { return 0 }
        return Int((Double(min(max(completed, 0), total)) / Double(total) * 100).rounded())
    }
}
