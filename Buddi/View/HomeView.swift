import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    let listViewModel = ListViewModel()

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
                NavigationLink(destination: ListView(viewModel: listViewModel)) {
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
                NavigationLink(destination: SettingsView()) {
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
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HomeViewModel()
        HomeView(viewModel: viewModel)
    }
}