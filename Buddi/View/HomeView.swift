import SwiftUI

struct HomeView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    let settingsViewModel = SettingsViewModel()
    
    init() {
        
        // Use UINavigationBarAppearance to change the navigation bar color
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.customBackground) // Set your custom color
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.customText)] // Set title color
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.customText)] // Set large title color
        appearance.titleTextAttributes = [.font: UIFont(name: "Quicksand-Bold", size: 18)!, .foregroundColor: UIColor(Color.customText)]
        
        
        // Apply the appearance to the navigation bar
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance // For iPhone small navigation bar in landscape
        UINavigationBar.appearance().scrollEdgeAppearance = appearance // For large title navigation bar
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Buddi")
                    .font(.custom("Quicksand-Bold", size: 40))
                    .foregroundColor(.customText) // Custom text color
                    .padding(.top, 40)
                    .padding(.bottom, 5)

                Text("Organize your relationships")
                    .font(.custom("Quicksand-Medium", size: 20))
                    .foregroundColor(.customText) // Custom text color

                Spacer() // This will push all content to the top

                Image("main") // Replace with your image name
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal)
                    .padding(.horizontal) // Add padding on both sides

                Spacer() // This adds space between the image and the buttons

                // Take Notes Button
                NavigationLink(destination: ListView()) {
                    Text("Take Notes")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.customText) // Custom button color
                        .foregroundColor(.customBackground) // For better contrast
                        .cornerRadius(10)
                        .shadow(radius: 5) // Add subtle shadow
                        .font(.custom("Quicksand-Medium", size: 18))
                }
                .padding(.horizontal, 20)

                // Settings Button
                NavigationLink(destination: SettingsView(viewModel: settingsViewModel)) {
                    Text("Settings")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.buttonGray) // Custom button color
                        .foregroundColor(.customText) // For better contrast
                        .cornerRadius(10)
                        .shadow(radius: 5) // Add subtle shadow
                        .font(.custom("Quicksand-Medium", size: 18))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Color.customBackground.edgesIgnoringSafeArea(.all)) // Set background color
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(Color.customText)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
