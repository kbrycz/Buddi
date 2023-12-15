import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()

            // Add your settings components here

            Spacer()
        }
        .navigationBarTitle("Settings", displayMode: .inline)
    }
}
