import SwiftUI

struct NoteView: View {
    var group: Group
    var buddiId: UUID
    @EnvironmentObject var listViewModel: ListViewModel
    @State private var todoItems: [Item] = [] // Changed to work with Item directly
    @State private var newItemText: String = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack {
            List {
                Section(header: TextField("Add new item", text: $newItemText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.custom("Quicksand-Medium", size: 16))
                            .foregroundColor(Color.customBackground)
                            .submitLabel(.done)
                            .focused($isInputFocused)
                            .onSubmit {
                                addNewItem()
                                isInputFocused = true // Keep the focus on the TextField
                            }
                            .cornerRadius(5)
                            .padding()
                            .background(Color.white) // Match the TextField background to your custom color
                ) {
                    ForEach(todoItems, id: \.self) { item in
                        VStack(alignment: .leading, spacing: 0) {
                            Text(item.text)
                                .font(.custom("Quicksand-Medium", size: 16))
                                .foregroundColor(.customText)
                                .padding(.top, 3)
                                .padding(.bottom, 8)
                        }
                        .background(Color.customBackground)
                     }
                     .onDelete(perform: deleteItem)
                 }
                 .listRowBackground(Color.customBackground) // This ensures each row in the list also has the custom background color
             }
             .listStyle(PlainListStyle())
             .background(Color.customBackground.edgesIgnoringSafeArea(.all)) // Apply background color to the List
         }
        .background(Color.customBackground.edgesIgnoringSafeArea(.all)) // Apply background color to the entire view
        .navigationBarTitle(group.title, displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isInputFocused = true
            }
        }
    }

    private func addNewItem() {
        if !newItemText.isEmpty {
            listViewModel.addItem(toGroupWithID: group.id, newItemText: newItemText, inBuddiWithID: buddiId)
            // Optionally update local state if immediate reflection in UI is needed
            newItemText = "" // Clear the text field
        }
        let newItem = Item(id: UUID(), text: newItemText)
        todoItems.insert(newItem, at: 0) // Adds the item to the start of the list
    }

    private func deleteItem(at offsets: IndexSet) {
        offsets.forEach { index in
            let itemId = todoItems[index].id
            listViewModel.removeItem(withItemID: itemId, fromGroupWithID: group.id, inBuddiWithID: buddiId)
        }
        todoItems.remove(atOffsets: offsets)
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView(group: Group(updatedDate: Date(), title: "Sample Group", items: []), buddiId: UUID())
    }
}
