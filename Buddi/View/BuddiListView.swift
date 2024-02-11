import SwiftUI

struct BuddiListView: View {
    @Binding var buddiBinding: Buddi
    @State private var localBuddi: Buddi
    @EnvironmentObject var listViewModel: ListViewModel // Assuming this is how you access your parent VM
    @State private var showingAddGroupPopup = false
    @State private var newGroupName = ""
    
    init(buddiBinding: Binding<Buddi>) {
        _buddiBinding = buddiBinding
        _localBuddi = State(initialValue: buddiBinding.wrappedValue)
    }
    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all) // Set the background color for the entire view

            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(localBuddi.groups) { group in
                        NavigationLink(destination: NoteView(group: group)) {
                            HStack {
                                Text(group.title)
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
        .navigationBarTitle(localBuddi.name, displayMode: .inline)
        .navigationBarItems(trailing: addButton)
        .sheet(isPresented: $showingAddGroupPopup) {
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
            showingAddGroupPopup = true
        }) {
            Image(systemName: "plus")
                .foregroundColor(.customText)
        }
    }
    

    private func addNoteSheet() -> some View {
        VStack {
            TextField("", text: $newGroupName, prompt: Text("Group title").foregroundColor(.customText.opacity(0.5)))
                .padding()
                .background(Color.customBackground) // Make text field background the darker color
                .foregroundColor(.customText) // Set the text field text color to the light color
                .cornerRadius(5)
                .padding(.horizontal)

            Button("Add Group") {
                let newGroup = Group(updatedDate: Date(), title: newGroupName, items: [])
                self.listViewModel.addGroup(toBuddiWithID: self.localBuddi.id, newGroup: newGroup)
                localBuddi.groups.insert(newGroup, at: 0) // Inserts at the beginning for "top of the list"
                buddiBinding = localBuddi
                self.newGroupName = ""
                self.showingAddGroupPopup = false
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
        let buddi = Buddi(name: "Karl", groups: [Group(updatedDate: Date(), title: "Group 1", items: [Item(text: "Test 1")])])
        BuddiListView(buddiBinding: .constant(buddi))
    }
}
