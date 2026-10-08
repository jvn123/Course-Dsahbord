import SwiftUI

struct CourseDetailsView: View {
    @State private var model: CourseDetailsViewModel

    init(courseID: Int, repository: any CourseRepositoryProtocol) {
        _model = State(initialValue: CourseDetailsViewModel(courseID: courseID, repository: repository))
    }

    var body: some View {
        Group {
            if let course = model.course {
                courseContent(course)
            } else {
                ProgressView(AppStrings.CourseDetails.loading)
            }
        }
        .navigationTitle(AppStrings.CourseDetails.title)
        .navigationBarTitleDisplayMode(.inline)
        .task { await model.load() }
    }

    private func courseContent(_ course: Course) -> some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text(course.title).font(.title2.bold()).foregroundStyle(DashboardStyle.ink)
                    Text(String(format: AppStrings.CourseDetails.instructor, course.instructor))
                        .foregroundStyle(DashboardStyle.muted)
                    ProgressView(value: Double(course.progress), total: 100).tint(DashboardStyle.accent)
                    Text(String(format: AppStrings.CourseDetails.progressSummary,
                                course.progress,
                                course.lessons.filter(\.isCompleted).count,
                                course.lessonCount))
                        .font(.footnote)
                        .foregroundStyle(DashboardStyle.muted)
                }
                .padding(.vertical, 8)
            }
            Section(AppStrings.CourseDetails.lessonsSection) {
                ForEach(course.lessons) { lesson in
                    Button {
                        guard !lesson.isCompleted else { return }
                        Task { await model.complete(lesson) }
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: lesson.isCompleted ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundStyle(lesson.isCompleted ? .green : DashboardStyle.muted)
                            Text(lesson.title).foregroundStyle(DashboardStyle.ink)
                            Spacer()
                            Text(lesson.isCompleted ? AppStrings.CourseDetails.completed : AppStrings.CourseDetails.markDone)
                                .font(.caption)
                                .foregroundStyle(lesson.isCompleted ? .green : DashboardStyle.accent)
                        }
                        .padding(.vertical, 5)
                    }
                    .buttonStyle(.plain)
                    .disabled(lesson.isCompleted)
                    .accessibilityIdentifier("lesson-\(lesson.id)")
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}
