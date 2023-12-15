import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: ListViewModel
    @State private var showingAddBuddiPopup = false
    @State private var newBuddiName = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.buddis) { buddi in
                    HStack {
                        Text(buddi.name)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .onMove(perform: move)
            }
            .navigationBarItems(trailing: addButton)
            .navigationBarTitle("Buddis", displayMode: .inline)
            .sheet(isPresented: $showingAddBuddiPopup, content: addBuddiSheet)
        }
    }

    private var addButton: some View {
        Button(action: {
            showingAddBuddiPopup = true
        }) {
            Image(systemName: "plus")
        }
    }

    private func addBuddiSheet() -> some View {
        VStack {
            TextField("Enter Buddi's name", text: $newBuddiName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Add Buddi") {
                viewModel.addBuddi(name: newBuddiName)
                newBuddiName = ""
                showingAddBuddiPopup = false
            }
            .disabled(newBuddiName.isEmpty)
        }
        .padding()
    }

    private func move(from source: IndexSet, to destination: Int) {
        viewModel.buddis.move(fromOffsets: source, toOffset: destination)
    }
}
