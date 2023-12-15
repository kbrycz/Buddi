import SwiftUI
struct ListView: View {
    @ObservedObject var viewModel: ListViewModel
    @State private var showingAddBuddiPopup = false
    @State private var newBuddiName = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.buddis) { buddi in
                    NavigationLink(destination: BuddiListView(buddi: buddi)) {
                        HStack {
                            Text(buddi.name)
                            Spacer()
                        }
                    }
                }
                .onMove(perform: move)
            }
            .navigationBarItems(trailing: addButton)
            .navigationBarTitle("Buddies", displayMode: .inline)
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
        viewModel.moveBuddis(from: source, to: destination)
    }

}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ListViewModel()
        ListView(viewModel: viewModel)
    }
}

