import SwiftUI

@main
struct BuddiApp: App {
    @State private var isShowingSplash = true
    @State private var logoOpacity = 1.0 // Start with full opacity
    @StateObject private var listViewModel = ListViewModel()
    @StateObject private var refreshTrigger = RefreshTrigger() // Initialize RefreshTrigger here

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Pass this viewModel instance to HomeView
                HomeView(viewModel: HomeViewModel())
                    .environmentObject(listViewModel)
                    .environmentObject(refreshTrigger) // Provide RefreshTrigger to the environment

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


class RefreshTrigger: ObservableObject {
    // Change this value to trigger a refresh
    @Published var refresh: Bool = false
}
