import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var showMessage = false
    @State private var messageText = ""

    var body: some View {
        VStack(spacing: 10) { // Add spacing between elements
            Text("Buddi does not store your data! Because of this, you are responsible for backing up all of your notes! Export your data to a json file to later import it if you switch devices!")
                .font(.custom("Quicksand-Medium", size: 16))
                .lineSpacing(8.0)
                .foregroundColor(.customText) // Custom text color
                .padding(.top, 40) // Increased top padding
                .padding(.bottom, 40) // Increased top padding
                .padding(.horizontal) // Add horizontal padding

            Button(action: {
                viewModel.saveData()
                showMessageWithText("The feature is coming soon!")
            }) {
                Text("Save Data")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.customText) // Custom button color
                    .foregroundColor(.customBackground) // For better contrast
                    .cornerRadius(10)
                    .shadow(radius: 5) // Add subtle shadow
                    .font(.custom("Quicksand-Medium", size: 18))
            }

            Button(action: {
                viewModel.importData()
                showMessageWithText("The feature is coming soon!")
            }) {
                Text("Import Data")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.buttonGray) // Custom button color
                    .foregroundColor(.customText) // For better contrast
                    .cornerRadius(10)
                    .shadow(radius: 5) // Add subtle shadow
                    .font(.custom("Quicksand-Medium", size: 18))
            }

            if showMessage {
                Text(messageText)
                    .font(.custom("Quicksand-Regular", size: 16))
                    .foregroundColor(.customText)
                    .transition(.scale.combined(with: .opacity)) // Animated appearance
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                self.showMessage = false
                            }
                        }
                    }
            }
            
            Text("Version 1.0.0")
                .font(.custom("Quicksand-Regular", size: 12))
                .foregroundColor(.customText) // Custom text color
                .padding() // Add padding around the text

            Spacer()
        }
        .padding(.horizontal) // Add horizontal padding
        .background(Color.customBackground.edgesIgnoringSafeArea(.all)) // Set background color
        .navigationBarTitle("Settings", displayMode: .inline)
    }

    private func showMessageWithText(_ text: String) {
        withAnimation {
            messageText = text
            showMessage = true
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
