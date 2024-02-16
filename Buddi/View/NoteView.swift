import SwiftUI

struct NoteView: View {
    var group: Group
    var buddiId: UUID
    @EnvironmentObject var listViewModel: ListViewModel
    @State private var todoItems: [Item] = [] // Changed to work with Item directly
    @State private var newItemText: String = ""
    @FocusState private var isInputFocused: Bool
    @Environment(\.colorScheme) var colorScheme // Access the color scheme

    var body: some View {
        VStack {
            List {
                Section(header: TextField("Add new item", text: $newItemText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.custom("Quicksand-Medium", size: 16))
                            .foregroundColor(.primary)
                            .submitLabel(.done)
                            .focused($isInputFocused)
                            .onSubmit {
                                addNewItem()
                                isInputFocused = true // Keep the focus on the TextField
                            }
                            .cornerRadius(5)
                            .padding()
                            .background(colorScheme == .dark ? Color.customBackgroundDarker : Color.white) // Adapt background to theme
                ) {
                    ForEach(todoItems, id: \.self) { item in
                        VStack(alignment: .leading, spacing: 0) {
                            Text(item.text)
                                .font(.custom("Quicksand-Medium", size: 16))
                                .foregroundColor(.customText)
                                .padding(.top, 3)
                                .padding(.bottom, 8)
                            
                            if colorScheme == .light {
                                Divider()
                                    .background(Color.gray.opacity(0.5))
                            }
                        }
                        .background(Color.customBackground)
                     }
                     .onDelete(perform: deleteItem)
                 }
                 .listRowBackground(Color.customBackground) // This ensures each row in the list also has the custom background color
                 .simultaneousGesture(TapGesture().onEnded { _ in
                     self.isInputFocused = false
                 })
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
            loadItems()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isInputFocused = true
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func loadItems() {
        todoItems = group.items
    }

    private func addNewItem() {
        if !newItemText.isEmpty {
            let newItem = Item(text: newItemText)
            listViewModel.addItem(toGroupWithID: group.id, newItem: newItem, inBuddiWithID: buddiId)
            // Optionally update local state if immediate reflection in UI is needed // Clear the text field
            todoItems.insert(newItem, at: 0) // Adds the item to the start of the list
            // Force the TextField to maintain focus
            newItemText = ""
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.isInputFocused = true
            }
        }
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
