import SwiftUI

struct BuddiListView: View {
    var buddi: Buddi
    @ObservedObject var viewModel: BuddiListViewModel
    @State private var showingAddNotePopup = false
    @State private var newNoteName = ""

    init(buddi: Buddi) {
        self.buddi = buddi
        self.viewModel = BuddiListViewModel()
        // Load notes for this specific Buddi here if needed
    }

    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all) // Set the background color for the entire view

            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.notes, id: \.self) { note in
                        NavigationLink(destination: NoteView(noteTitle: note)) {
                            HStack {
                                Text(note)
                                    .foregroundColor(.customText)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.customBackgroundDarker)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
        }
        .navigationBarTitle(buddi.name, displayMode: .inline)
        .navigationBarItems(trailing: addButton)
        .sheet(isPresented: $showingAddNotePopup) {
            ZStack {
                Color.customBackgroundDarker // This will add a dark overlay to your image
                    .opacity(1) // Adjust the opacity as needed
                    .edgesIgnoringSafeArea(.all)

                Image("main") // Your background image
                    .resizable()
                    .scaledToFit() // Fill the entire background
                    .opacity(0.01) // Set transparency
                    .edgesIgnoringSafeArea(.all) // Ignore safe area to cover the whole background
                addNoteSheet()
            }
        }
        .accentColor(Color.customText)
    }

    private var addButton: some View {
        Button(action: {
            showingAddNotePopup = true
        }) {
            Image(systemName: "plus")
                .foregroundColor(.customText)
        }
    }

    private func addNoteSheet() -> some View {
        VStack {
            TextField("", text: $newNoteName, prompt: Text("Enter note here").foregroundColor(.customText.opacity(0.5)))
                .padding()
                .background(Color.customBackground) // Make text field background the darker color
                .foregroundColor(.customText) // Set the text field text color to the light color
                .cornerRadius(5)
                .padding(.horizontal)

            Button("Add Note") {
                viewModel.addNote(name: newNoteName)
                newNoteName = ""
                showingAddNotePopup = false
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.customBackgroundDarkest) // Make button background the darker color
            .foregroundColor(.customText) // Set the button text color to the light color
            .cornerRadius(8)
            .padding(.horizontal)
        }
        .padding()
    }
}

struct BuddiListView_Previews: PreviewProvider {
    static var previews: some View {
        let buddi = Buddi(name: "Karl")
        BuddiListView(buddi: buddi)
    }
}
