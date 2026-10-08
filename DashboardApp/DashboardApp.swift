import SwiftUI

@main
struct ProductAppApp: App {
    @State private var navigator = AppNavigator()
    private let repository: any CourseRepositoryProtocol = CourseRepository(
        remote: CourseAPIProvider.make(), cache: JSONCourseCache()
    )

    var body: some Scene {
        WindowGroup {
            AppRootView(repository: repository)
                .environment(navigator)
        }
    }
}
