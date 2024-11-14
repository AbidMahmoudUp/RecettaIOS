import SwiftUI

struct SplashScreenViewUI: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @EnvironmentObject private var appState: AppState // Shared app state

    var body: some View {
        Group {
            if isActive {
                // Navigate based on the persisted onboarding status
                if appState.isOnboardingDone {
                    LoginScreenViewUI()
                } else {
                    OnboardingView()
                        .environmentObject(appState) // Pass appState to OnboardingView
                }
            } else {
                VStack {
                    Image(systemName: "hare.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.red)
                    Text("Epic App")
                        .font(Font.custom("Baskerville_Bold", size: 26))
                        .foregroundColor(.black.opacity(0.80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    // Animate splash effect
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                    // Delay and then show the next view
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}
#Preview {
    SplashScreenViewUI()
}
