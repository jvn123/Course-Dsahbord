import Foundation

protocol CourseAPI: Sendable {
    func fetchCourses() async throws -> [Course]
}

struct URLSessionCourseAPI: CourseAPI {
    private let endpoint: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession = .shared) {
        self.endpoint = baseURL.appending(path: AppStrings.Configuration.coursesPathComponent)
        self.session = session
    }

    func fetchCourses() async throws -> [Course] {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode) else {
            throw CourseAPIError.invalidResponse
        }

        let records = try JSONDecoder().decode([CourseRecord].self, from: data)
        return records.map(\.course)
    }
}

private struct CourseRecord: Decodable {
    let id: Int
    let title: String
    let instructor: String
    let progress: Int
    let lessons: Int

    var course: Course {
        let count = max(lessons, 0)
        let completed = min(count, max(0, Int((Double(progress) / 100 * Double(count)).rounded())))
        let lessonList = (0..<count).map { index in
            Lesson(
                id: id * 100 + index,
                title: String(format: AppStrings.CourseDetails.generatedLessonTitle, index + 1),
                isCompleted: index < completed
            )
        }
        return Course(id: id, title: title, instructor: instructor, lessons: lessonList, progress: progress)
    }
}

enum CourseAPIError: LocalizedError {
    case invalidResponse

    var errorDescription: String? { AppStrings.Errors.courseRequestFailed }
}

struct MockCourseAPI: CourseAPI {
    func fetchCourses() async throws -> [Course] {
        try await Task.sleep(for: .milliseconds(350))
        return [
            Course(id: 1, title: "Python Programming", instructor: "John Smith", lessons: lessons(1, ["Introduction", "Variables & Data Types", "Functions", "OOP"], completed: 13, count: 20), progress: 65),
            Course(id: 2, title: "Generative AI", instructor: "Sarah Williams", lessons: lessons(2, ["AI Foundations", "Prompt Engineering", "Building with LLMs", "Responsible AI"], completed: 6, count: 16), progress: 40),
            Course(id: 3, title: "Full Stack Development", instructor: "David Brown", lessons: lessons(3, ["Web Fundamentals", "HTML & CSS", "JavaScript", "APIs"], completed: 7, count: 28), progress: 25)
        ]
    }

    private func lessons(_ courseID: Int, _ titles: [String], completed: Int, count: Int) -> [Lesson] {
        (0..<count).map { index in
            let title = index < titles.count ? titles[index] : "Practice lesson \(index + 1)"
            return Lesson(id: courseID * 100 + index, title: title, isCompleted: index < completed)
        }
    }
}
