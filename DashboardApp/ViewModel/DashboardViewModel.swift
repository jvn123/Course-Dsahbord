import Foundation

@MainActor @Observable
final class DashboardViewModel {
    enum State {
        case loading
        case loaded([Course], isOffline: Bool)
        case empty
        case failed(String)
    }

    private(set) var state: State = .loading
    private let repository: any CourseRepositoryProtocol

    init(repository: any CourseRepositoryProtocol) {
        self.repository = repository
    }

    func load() async {
        state = .loading
        do {
            let result = try await repository.courses()
            state = result.courses.isEmpty
                ? .empty
                : .loaded(result.courses, isOffline: result.source == .cache)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
