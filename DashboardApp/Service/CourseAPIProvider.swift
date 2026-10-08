import Foundation

struct CourseAPIProvider {
    static func make(environment: [String: String] = ProcessInfo.processInfo.environment) -> any CourseAPI {
        let configuredURL = environment[AppStrings.Configuration.apiBaseURLEnvironmentKey]
            ?? (Bundle.main.object(forInfoDictionaryKey: AppStrings.Configuration.apiBaseURLInfoKey) as? String)

        guard let configuredURL,
              let baseURL = URL(string: configuredURL),
              baseURL.scheme == "http" || baseURL.scheme == "https" else {
            return MockCourseAPI()
        }
        return URLSessionCourseAPI(baseURL: baseURL)
    }
}
