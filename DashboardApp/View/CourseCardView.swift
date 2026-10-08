import SwiftUI

struct CourseCardView: View {
    let course: Course
    let onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 7) {
                    Text(course.title).font(.headline).foregroundStyle(DashboardStyle.ink)
                    Text(String(format: AppStrings.Dashboard.instructor, course.instructor))
                        .font(.subheadline)
                        .foregroundStyle(DashboardStyle.muted)
                }
                Spacer(minLength: 4)
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundStyle(DashboardStyle.muted)
            }
            VStack(spacing: 8) {
                HStack {
                    Text(AppStrings.Dashboard.progress).foregroundStyle(DashboardStyle.muted)
                    Spacer()
                    Text(String(format: AppStrings.Dashboard.progressPercent, course.progress))
                        .fontWeight(.semibold)
                }
                ProgressView(value: Double(course.progress), total: 100)
                    .tint(DashboardStyle.accent)
            }
            .font(.caption)
            HStack {
                Label(String(format: AppStrings.Dashboard.lessons, course.lessonCount), systemImage: "play.rectangle")
                    .font(.caption)
                    .foregroundStyle(DashboardStyle.muted)
                Spacer()
                Button(AppStrings.Dashboard.continueLearning, action: onContinue)
                    .primaryActionButton()
                    .accessibilityIdentifier("continue-\(course.id)")
            }
        }
        .cardSurface()
    }
}
