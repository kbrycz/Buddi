import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    let listViewModel = ListViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Buddi")
                    .font(.largeTitle)
                    .padding(.top, 20)

                Text("Organize your relationships")
                    .font(.title3)
                    .padding(.top, 10)

                Spacer() // This will push all content to the top

                Image("yourImageName") // Replace with your image name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100) // Adjust size as needed
                    .padding(.top, 20)

                Spacer() // This adds space between the image and the buttons

                NavigationLink(destination:
                                ListView(viewModel: listViewModel)) {
                    Text("Take Notes")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)

                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HomeViewModel()
        HomeView(viewModel: viewModel)
    }
}
