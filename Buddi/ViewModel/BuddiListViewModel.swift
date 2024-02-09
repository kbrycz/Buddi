import Foundation

class BuddiListViewModel: ObservableObject {
    @Published var notes: [String] = []

    init() {
        // Load notes for a specific Buddi if needed, or initialize an empty array
    }

    func addNote(name: String) {
        notes.insert(name, at: 0)
        // Save notes for a specific Buddi if needed
    }

    // Add more functions as needed, for example, to load and save notes from persistent storage
}
