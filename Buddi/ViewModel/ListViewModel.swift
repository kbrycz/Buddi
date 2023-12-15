import Foundation

class ListViewModel: ObservableObject {
    @Published var buddis: [Buddi] = []

    init() {
        loadBuddis()
    }

    func addBuddi(name: String) {
        let newBuddi = Buddi(name: name)
        buddis.insert(newBuddi, at: 0)
        saveBuddis()
    }

    func moveBuddis(from source: IndexSet, to destination: Int) {
        buddis.move(fromOffsets: source, toOffset: destination)
        saveBuddis()
    }

    private func loadBuddis() {
        if let data = UserDefaults.standard.data(forKey: "buddis"),
           let savedBuddis = try? JSONDecoder().decode([Buddi].self, from: data) {
            buddis = savedBuddis
        }
    }

    private func saveBuddis() {
        if let data = try? JSONEncoder().encode(buddis) {
            UserDefaults.standard.set(data, forKey: "buddis")
        }
    }
}
