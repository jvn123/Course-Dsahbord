import SwiftUI

struct LoginView: View {
    @Environment(AppNavigator.self) private var navigator
    @State private var model = LoginViewModel()

    var body: some View {
        @Bindable var model = model
        VStack(alignment: .leading, spacing: 24) {
            Spacer()
            Image(systemName: "book.closed.fill")
                .font(.system(size: 36))
                .foregroundStyle(DashboardStyle.accent)
            VStack(alignment: .leading, spacing: 8) {
                Text(AppStrings.Login.title).font(.largeTitle.bold()).foregroundStyle(DashboardStyle.ink)
                Text(AppStrings.Login.subtitle).foregroundStyle(DashboardStyle.muted)
            }
            VStack(spacing: 14) {
                TextField(AppStrings.Login.emailPlaceholder, text: $model.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityIdentifier("emailField")
                SecureField(AppStrings.Login.passwordPlaceholder, text: $model.password)
                    .textContentType(.password)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityIdentifier("passwordField")
            }
            if let message = model.errorMessage {
                Text(message).font(.footnote).foregroundStyle(.red).accessibilityIdentifier("loginError")
            }
            Button {
                Task { await model.login { navigator.login() } }
            } label: {
                HStack {
                    if model.isLoading { ProgressView().tint(.white) }
                    Text(model.isLoading ? AppStrings.Login.loading : AppStrings.Login.button).fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
            }
            .primaryActionButton()
            .disabled(model.isLoading)
            .accessibilityIdentifier("loginButton")
            Text(AppStrings.Login.demoHint)
                .font(.caption).foregroundStyle(DashboardStyle.muted)
            Spacer()
        }
        .padding(28)
        .dashboardScreen()
    }
}
