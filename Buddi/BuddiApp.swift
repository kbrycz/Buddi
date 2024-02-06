import SwiftUI

@main
struct BuddiApp: App {
    @State private var isShowingSplash = true
    @State private var logoOpacity = 1.0 // Start with full opacity
    var viewModel = HomeViewModel()

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Pass this viewModel instance to HomeView
                HomeView(viewModel: viewModel)

                // Splash Screen
                if isShowingSplash {
                    SplashScreenView(logoOpacity: $logoOpacity) // Ensure you have this view created
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Adjust time as needed
                                withAnimation(.easeInOut(duration: 1)) {
                                    logoOpacity = 0.0
                                    isShowingSplash = false
                                }
                            }
                        }
                }
            }
            .edgesIgnoringSafeArea(.all) // Ensure the splash covers the whole screen
        }
    }
}
