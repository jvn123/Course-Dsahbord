# Dashboard — Learning Dashboard

SwiftUI learning app by **Jeevan Rawat**. Open `Dashboard.xcodeproj`, choose the `ProductApp` scheme, and run on an iOS simulator (deployment target iOS 26.5). Demo login accepts any valid email and a password of 6+ characters. `error@example.com` or password `wrong` simulates a login failure.

## 1. Architecture

I chose MVVM because it keeps SwiftUI views focused on presentation while observable view models own screen state and user actions. `AppNavigator` centralizes typed navigation. `CourseRepository` coordinates API and cache protocols, so UI code does not depend on networking or storage details. This follows single responsibility and dependency inversion, and the protocol boundaries make components replaceable. Async work uses Swift concurrency; the repository and JSON cache are actors.

## 2. Offline Support

`JSONCourseCache` stores the latest course snapshot and lesson changes as JSON in the app’s Application Support directory. The repository tries the API first; if the request fails, it loads the saved snapshot and the dashboard shows an offline label. Local lesson completions are merged with later API responses.

To use a real API, set `COURSE_API_BASE_URL` in Xcode under **Product → Scheme → Edit Scheme → Run → Arguments → Environment Variables**. The app makes `GET {baseURL}/courses`. The endpoint should return:

```json
[{"id":1,"title":"Python Programming","instructor":"John Smith","progress":65,"lessons":20}]
```

Load courses while connected, disable connectivity, then tap refresh to check the cached fallback. Without the environment variable, the app uses `MockCourseAPI`. Use HTTPS; a local HTTP development server may require a suitable App Transport Security exception.

## 3. Security

The demo token is stored in the iOS Keychain through `KeychainSecureStorage`, with device-only accessibility. In production, I would store server-issued short-lived access and refresh tokens in Keychain, use TLS and refresh-token rotation, and never persist the user’s password.

## 4. Scale: 1 million users and hundreds of courses

1. Use a versioned, paginated API with request cancellation, retries/backoff, rate limiting, and monitoring.
2. Replace the JSON snapshot with a migrated local database such as SwiftData or Core Data, with indexes and cache freshness rules.
3. Add incremental background sync and conflict handling for lesson progress.
4. Harden authentication and authorization; add token rotation, privacy controls, and audit logging.
5. Expand automated integration, UI, accessibility, and performance coverage; add CI and crash/performance monitoring.

## 5. Android implementation

I would use Kotlin and Jetpack Compose for the UI, Navigation Compose for routing, and ViewModels with StateFlow for screen state. A repository would coordinate Retrofit or Ktor with Room for offline course data. Kotlin coroutines would handle asynchronous work, and Android Keystore-backed storage would protect authentication credentials.

A progress-calculation unit test is in `ProductAppTests`. A simulator build is in `build/Dashboard.app`.
