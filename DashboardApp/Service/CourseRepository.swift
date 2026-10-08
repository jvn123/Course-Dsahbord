import Foundation

protocol CourseRepositoryProtocol: Sendable {
    func courses() async throws -> CourseLoadResult
    func markLessonCompleted(courseID: Int, lessonID: Int) async throws -> [Course]
}

struct CourseLoadResult: Sendable {
    let courses: [Course]
    let source: Source

    enum Source: Sendable {
        case remote
        case cache
    }
}

enum CourseRepositoryError: LocalizedError {
    case unavailable

    var errorDescription: String? {
        AppStrings.Errors.coursesUnavailable
    }
}

actor CourseRepository: CourseRepositoryProtocol {
    private let remote: any CourseAPI
    private let cache: any CourseCache
    private var current: [Course] = []

    init(remote: any CourseAPI, cache: any CourseCache) {
        self.remote = remote
        self.cache = cache
    }

    func courses() async throws -> CourseLoadResult {
        let previousCourses = current.isEmpty
            ? ((try? await cache.load()) ?? [])
            : current
        do {
            let latest = try await remote.fetchCourses()
            let merged = latest.map { incoming -> Course in
                guard let old = previousCourses.first(where: { $0.id == incoming.id }) else { return incoming }
                var result = incoming
                let completedIDs = Set(old.lessons.filter(\.isCompleted).map(\.id))
                var hasLocalCompletion = false
                for index in result.lessons.indices where completedIDs.contains(result.lessons[index].id) {
                    hasLocalCompletion = hasLocalCompletion || !result.lessons[index].isCompleted
                    result.lessons[index].isCompleted = true
                }
                if hasLocalCompletion {
                    result.progress = ProgressCalculator.percentage(
                        completed: result.lessons.filter(\.isCompleted).count,
                        total: result.lessons.count
                    )
                }
                return result
            }
            current = merged
            try await cache.save(merged)
            return CourseLoadResult(courses: merged, source: .remote)
        } catch {
            if let saved = try? await cache.load(), !saved.isEmpty {
                current = saved
                return CourseLoadResult(courses: saved, source: .cache)
            }
            throw CourseRepositoryError.unavailable
        }
    }

    func markLessonCompleted(courseID: Int, lessonID: Int) async throws -> [Course] {
        if current.isEmpty { current = (try? await cache.load()) ?? [] }
        guard let courseIndex = current.firstIndex(where: { $0.id == courseID }),
              let lessonIndex = current[courseIndex].lessons.firstIndex(where: { $0.id == lessonID }) else {
            return current
        }
        current[courseIndex].lessons[lessonIndex].isCompleted = true
        current[courseIndex].progress = ProgressCalculator.percentage(
            completed: current[courseIndex].lessons.filter(\.isCompleted).count,
            total: current[courseIndex].lessons.count
        )
        try await cache.save(current)
        return current
    }
}
