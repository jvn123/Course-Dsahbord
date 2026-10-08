import Foundation

@MainActor @Observable
final class LoginViewModel {
    var email = ""
    var password = ""
    private(set) var isLoading = false
    var errorMessage: String?

    private let authenticate: @MainActor (String, String) async throws -> String
    private let secureStorage: any SecureStorage

    init(
        secureStorage: (any SecureStorage)? = nil,
        authenticate: @escaping @MainActor (String, String) async throws -> String = { email, password in
            try await Task.sleep(for: .milliseconds(500))
            guard email.lowercased() != AppStrings.Login.mockFailureEmail,
                  password != AppStrings.Login.mockFailurePassword else {
                throw LoginError.invalidCredentials
            }
            return "demo-token-\(UUID().uuidString)"
        }
    ) {
        self.authenticate = authenticate
        self.secureStorage = secureStorage ?? KeychainSecureStorage()
    }

    var validationMessage: String? {
        guard !email.isEmpty,
              email.contains("@"),
              email.split(separator: "@").last?.contains(".") == true else {
            return AppStrings.Login.invalidEmail
        }
        guard password.count >= 6 else {
            return AppStrings.Login.invalidPassword
        }
        return nil
    }

    func login(onSuccess: () -> Void) async {
        guard validationMessage == nil else {
            errorMessage = validationMessage
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let token = try await authenticate(email, password)
            try secureStorage.save(token, for: AppStrings.Configuration.authTokenKey)
            onSuccess()
        } catch {
            errorMessage = AppStrings.Login.failure
        }
    }
}

enum LoginError: Error {
    case invalidCredentials
}
