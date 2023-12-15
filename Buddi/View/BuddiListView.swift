import SwiftUI

struct BuddiListView: View {
    var buddi: Buddi
    @State private var items: [String] = [] // Placeholder for list items
    @State private var showingAddNotePopup = false
    @State private var newNoteName = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    NavigationLink(destination: NoteView(noteTitle: item)) {
                        Text(item)
                    }
                }
            }
            .navigationBarTitle(buddi.name)
            .navigationBarItems(trailing: Button(action: {
                showingAddNotePopup = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddNotePopup, content: addNoteSheet)
        }
    }

    private func addNoteSheet() -> some View {
        VStack {
            TextField("Enter Note", text: $newNoteName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Add Note") {
                if !newNoteName.isEmpty {
                    items.append(newNoteName)
                    newNoteName = ""
                    showingAddNotePopup = false
                }
            }
            .disabled(newNoteName.isEmpty)
        }
        .padding()
    }
}

struct BuddyListView_Previews: PreviewProvider {
    static var previews: some View {
//        let viewModel = BuddyListViewModel()
        let buddi = Buddi(name: "Karl")
        BuddiListView(buddi: buddi)
    }
}
