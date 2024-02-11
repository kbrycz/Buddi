import SwiftUI

struct BuddiListView: View {
    @Binding var buddiBinding: Buddi
    @State private var localBuddi: Buddi
    @EnvironmentObject var listViewModel: ListViewModel // Assuming this is how you access your parent VM
    @State private var showingAddGroupPopup = false
    @State private var newGroupName = ""
    
    @State private var showingDeleteAlert = false
    @State private var indexToDelete: Int? = nil
    
    init(buddiBinding: Binding<Buddi>) {
        _buddiBinding = buddiBinding
        _localBuddi = State(initialValue: buddiBinding.wrappedValue)
    }
    
    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all) // Set the background color for the entire view

            ScrollView {
                LazyVStack(spacing: 10) {
                    
                    if (localBuddi.groups.isEmpty) {
                        Text("No groups yet... Go add one! Groups help you organize different times you've interacted with a buddi!")
                            .font(.custom("Quicksand-Medium", size: 16))
                            .lineSpacing(8.0)
                            .foregroundColor(.customText) // Custom text color
                            .padding(.top, 40) // Increased top padding
                            .padding(.bottom, 40) // Increased top padding
                            .padding(.horizontal) // Add horizontal padding
                    }
                    
                    ForEach(Array(localBuddi.groups.enumerated()), id: \.element.id) { index, group in
                        NavigationLink(destination: NoteView(group: group, buddiId: localBuddi.id)) {
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
                        .simultaneousGesture(LongPressGesture().onEnded { _ in
                            self.indexToDelete = index
                            self.showingDeleteAlert = true
                        })
                        .alert(isPresented: $showingDeleteAlert) {
                            Alert(title: Text("Delete \(localBuddi.groups[indexToDelete ?? 0].title)?"), message: Text("This action cannot be undone."), primaryButton: .destructive(Text("Delete")) {
                                if let indexToDelete = self.indexToDelete {
                                    // Perform deletion
                                    localBuddi.groups.remove(at: indexToDelete)
                                    // Update buddiBinding to reflect changes
                                    buddiBinding = localBuddi
                                    // Optionally, call a method to handle the deletion in your view model
                                    listViewModel.saveBuddis()
                                }
                            }, secondaryButton: .cancel())
                        }
                    }
                }
                .padding(.top)
            }
        }
        .onAppear {
            // Assuming you have a method in your ViewModel to fetch the latest data
            self.refreshLocalBuddiData()
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


    // Local function within BuddiListView
    func refreshLocalBuddiData() {
        // Fetch the latest data for the current buddi and update localBuddi
        if let updatedBuddi = listViewModel.fetchBuddiById(localBuddi.id) {
            self.localBuddi = updatedBuddi
            self.buddiBinding = localBuddi
        }
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
