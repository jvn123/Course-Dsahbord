import SwiftUI

struct DashboardView: View {
    @Environment(AppNavigator.self) private var navigator
    @State private var model: DashboardViewModel

    init(repository: any CourseRepositoryProtocol) {
        _model = State(initialValue: DashboardViewModel(repository: repository))
    }

    var body: some View {
        Group {
            switch model.state {
            case .loading:
                ProgressView(AppStrings.Dashboard.loading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .empty:
                ContentUnavailableView(
                    AppStrings.Dashboard.emptyTitle,
                    systemImage: "books.vertical",
                    description: Text(AppStrings.Dashboard.emptyDescription)
                )
            case .failed(let message):
                ContentUnavailableView {
                    Label(AppStrings.Dashboard.failureTitle, systemImage: "wifi.exclamationmark")
                } description: {
                    Text(message)
                } actions: {
                    Button(AppStrings.Dashboard.retry) { Task { await model.load() } }
                        .primaryActionButton()
                }
            case .loaded(let courses, let isOffline):
                courseList(courses, isOffline: isOffline)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(AppStrings.Dashboard.signOut) {
                    try? KeychainSecureStorage().delete(for: AppStrings.Configuration.authTokenKey)
                    navigator.logout()
                }
            }
        }
        .task { await model.load() }
    }

    private func courseList(_ courses: [Course], isOffline: Bool) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(AppStrings.Dashboard.eyebrow).font(.caption.bold()).tracking(1.4).foregroundStyle(DashboardStyle.accent)
                        Text(AppStrings.Dashboard.title).font(.largeTitle.bold()).foregroundStyle(DashboardStyle.ink)
                    }
                    Spacer()
                    Button { Task { await model.load() } } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .accessibilityLabel(AppStrings.Dashboard.refreshAccessibility)
                }
                if isOffline {
                    Label(AppStrings.Dashboard.offline, systemImage: "wifi.slash")
                        .font(.footnote)
                        .foregroundStyle(DashboardStyle.muted)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white, in: RoundedRectangle(cornerRadius: 12))
                }
                Text(AppStrings.Dashboard.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(DashboardStyle.muted)
                ForEach(courses) { course in
                    CourseCardView(course: course) {
                        navigator.path.append(AppRoute.courseDetails(course.id))
                    }
                }
            }
            .padding(20)
        }
        .dashboardScreen()
    }
}
