import Foundation

@MainActor @Observable
final class CourseDetailsViewModel {
    private(set) var course: Course?
    private let courseID: Int
    private let repository: any CourseRepositoryProtocol

    init(courseID: Int, repository: any CourseRepositoryProtocol) {
        self.courseID = courseID
        self.repository = repository
    }

    func load() async {
        do {
            course = try await repository.courses().courses.first { $0.id == courseID }
        } catch {
            course = nil
        }
    }

    func complete(_ lesson: Lesson) async {
        do {
            course = try await repository.markLessonCompleted(courseID: courseID, lessonID: lesson.id)
                .first { $0.id == courseID }
        } catch {
            // Keep the existing presentation state if persistence fails.
        }
    }
}
