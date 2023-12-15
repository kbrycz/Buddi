import SwiftUI

struct NoteView: View {
    var noteTitle: String
    @State private var todoItems: [String] = []
    @State private var newItem: String = ""

    var body: some View {
        VStack {
            List {
                ForEach(todoItems, id: \.self) { item in
                    Text(item)
                }

                TextField("Add new item", text: $newItem, onCommit: addNewItem)
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarTitle(noteTitle, displayMode: .inline)
    }

    private func addNewItem() {
        if !newItem.isEmpty {
            todoItems.append(newItem)
            newItem = "" // Clear the text field
        }
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView(noteTitle: "Sample Note")
    }
}
