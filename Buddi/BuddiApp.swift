import SwiftUI

@main
struct BuddiApp: App {
    @State private var isShowingSplash = true
    @State private var logoOpacity = 1.0 // Start with full opacity
    @StateObject private var listViewModel = ListViewModel() // Use @StateObject for ownership and lifecycle management

    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Pass this viewModel instance to HomeView
                HomeView(viewModel: HomeViewModel())
                                    .environmentObject(listViewModel)

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
