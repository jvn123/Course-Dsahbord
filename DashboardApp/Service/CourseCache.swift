import Foundation

protocol CourseCache: Sendable {
    func load() async throws -> [Course]?
    func save(_ courses: [Course]) async throws
}

actor JSONCourseCache: CourseCache {
    private let fileURL: URL

    init(fileManager: FileManager = .default) {
        let directory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            .appending(path: "LearningDashboard", directoryHint: .isDirectory)
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        fileURL = directory.appending(path: "courses.json")
    }

    func load() async throws -> [Course]? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        return try JSONDecoder().decode([Course].self, from: Data(contentsOf: fileURL))
    }

    func save(_ courses: [Course]) async throws {
        let data = try JSONEncoder().encode(courses)
        try data.write(to: fileURL, options: .completeFileProtection)
    }
}
