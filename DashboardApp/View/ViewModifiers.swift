import SwiftUI

struct DashboardScreenModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(DashboardStyle.canvas)
            .ignoresSafeArea(edges: .bottom)
    }
}

struct CardSurfaceModifier: ViewModifier {
    var cornerRadius: CGFloat = 18

    func body(content: Content) -> some View {
        content
            .padding(18)
            .background(.white, in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black.opacity(0.04))
            }
    }
}

struct PrimaryActionButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .tint(DashboardStyle.accent)
    }
}

extension View {
    func dashboardScreen() -> some View {
        modifier(DashboardScreenModifier())
    }

    func cardSurface(cornerRadius: CGFloat = 18) -> some View {
        modifier(CardSurfaceModifier(cornerRadius: cornerRadius))
    }

    func primaryActionButton() -> some View {
        modifier(PrimaryActionButtonModifier())
    }
}
