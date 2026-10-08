enum AppStrings {
    enum Configuration {
        static let apiBaseURLEnvironmentKey = "COURSE_API_BASE_URL"
        static let apiBaseURLInfoKey = "COURSE_API_BASE_URL"
        static let coursesPathComponent = "courses"
        static let authTokenKey = "authToken"
    }

    enum Login {
        static let title = "Welcome back"
        static let subtitle = "Sign in to continue learning"
        static let emailPlaceholder = "Email address"
        static let passwordPlaceholder = "Password"
        static let button = "Login"
        static let loading = "Signing in…"
        static let demoHint = "Demo: use any valid email and a password of 6+ characters."
        static let invalidEmail = "Enter a valid email address."
        static let invalidPassword = "Password must be at least 6 characters."
        static let failure = "Login failed. Check your email and password."
        static let mockFailureEmail = "error@example.com"
        static let mockFailurePassword = "wrong"
    }

    enum Dashboard {
        static let eyebrow = "LEARN"
        static let title = "Your courses"
        static let subtitle = "Keep your momentum going"
        static let loading = "Loading your courses…"
        static let emptyTitle = "No courses yet"
        static let emptyDescription = "Your courses will appear here."
        static let failureTitle = "Couldn't load courses"
        static let retry = "Try again"
        static let signOut = "Sign out"
        static let refreshAccessibility = "Refresh courses"
        static let offline = "Offline · showing saved courses"
        static let progress = "Progress"
        static let progressPercent = "%d%%"
        static let lessons = "%d lessons"
        static let continueLearning = "Continue"
        static let instructor = "with %@"
    }

    enum CourseDetails {
        static let title = "Course details"
        static let loading = "Loading course…"
        static let lessonsSection = "Lessons"
        static let completed = "Completed"
        static let markDone = "Mark done"
        static let instructor = "with %@"
        static let progressSummary = "%d%% complete · %d of %d lessons"
        static let generatedLessonTitle = "Lesson %d"
    }

    enum Errors {
        static let courseRequestFailed = "The course server returned an invalid response."
        static let coursesUnavailable = "Courses could not be loaded. Check your connection and try again."
    }
}
