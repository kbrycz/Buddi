import SwiftUI

struct ListView: View {
    @EnvironmentObject var viewModel: ListViewModel // Assuming this is how you access your parent VM
    @State private var showingAddBuddiPopup = false
    @State private var newBuddiName = ""
    @EnvironmentObject var refreshTrigger: RefreshTrigger // Assuming you inject this environment object


    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all) // Set the background color for the entire view
            
            ScrollView {
                LazyVStack(spacing: 10) { // Add some spacing between items
                    ForEach(viewModel.buddis.indices, id: \.self) { index in
                        let buddiBinding = $viewModel.buddis[index]
                        NavigationLink(destination: BuddiListView(buddiBinding: buddiBinding)) {
                            HStack {
                                Text(viewModel.buddis[index].name)
                                    .foregroundColor(.customText) // Custom text color
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white) // Chevron color
                            }
                            .padding()
                            .background(Color.customBackgroundDarker) // Slightly darker row color for contrast
                            .cornerRadius(10)
                            .padding(.horizontal) // Add horizontal padding
                        }
                    }

                }
                .padding(.top) // Add padding at the top of the list
            }
        }
        .onAppear() {
            print("Hello")
//            viewModel.loadBuddis()
            refreshTrigger.refresh.toggle()

        }
        .navigationBarItems(trailing: addButton)
        .navigationBarTitle("Buddies", displayMode: .inline)
        .sheet(isPresented: $showingAddBuddiPopup) {
            ZStack {
                Color.customBackgroundDarker // This will add a dark overlay to your image
                    .opacity(1) // Adjust the opacity as needed
                    .edgesIgnoringSafeArea(.all)

                Image("main") // Your background image
                    .resizable()
                    .scaledToFit() // Fill the entire background
                    .opacity(0.01) // Set transparency
                    .edgesIgnoringSafeArea(.all) // Ignore safe area to cover the whole background
                addBuddiSheet() // Your modal content
            }
        }
        .accentColor(Color.customText)
    }

    private var addButton: some View {
        Button(action: {
            showingAddBuddiPopup = true
        }) {
            Image(systemName: "plus")
                .foregroundColor(.customText) // Ensure plus icon matches custom text color
        }
    }

    private func addBuddiSheet() -> some View {
        VStack {
        
            TextField("", text: $newBuddiName, prompt: Text("Enter name here").foregroundColor(.gray))
                .padding()
                .background(Color.customBackground) // Make text field background the darker color
                .foregroundColor(.customText) // Set the text field text color to the light color
                .cornerRadius(5)
                .padding(.horizontal) // Add horizontal padding if needed

            Button("Add Buddi") {
                viewModel.addBuddi(name: newBuddiName)
                newBuddiName = ""
                showingAddBuddiPopup = false
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.customBackgroundDarkest) // Make button background the darker color
            .foregroundColor(.customText) // Set the button text color to the light color
            .cornerRadius(8)
            .padding(.horizontal) // Add horizontal padding if needed
        }
        .padding()
    }



    private func move(from source: IndexSet, to destination: Int) {
        viewModel.moveBuddis(from: source, to: destination)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
