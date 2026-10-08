import SwiftUI

@Observable
final class AppNavigator {
    var path = NavigationPath()
    var isAuthenticated: Bool

    init(secureStorage: (any SecureStorage)? = nil) {
        let secureStorage = secureStorage ?? KeychainSecureStorage()
        isAuthenticated = (try? secureStorage.read(for: AppStrings.Configuration.authTokenKey)) != nil
    }

    func login() {
        isAuthenticated = true
        path = NavigationPath()
    }
    
    func logout() {
        isAuthenticated = false
        path = NavigationPath()
    }
}

enum AppRoute: Hashable {
    case courseDetails(Int)
}

struct AppRootView: View {
    @Environment(AppNavigator.self) private var navigator
    let repository: any CourseRepositoryProtocol

    var body: some View {
        @Bindable var navigation = navigator
        NavigationStack(path: $navigation.path) {
            Group {
                if navigator.isAuthenticated {
                    DashboardView(repository: repository)
                } else {
                    LoginView()
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .courseDetails(let id): CourseDetailsView(courseID: id, repository: repository)
                }
            }
        }
        .tint(Color(red: 0.22, green: 0.36, blue: 0.82))
    }
}
