import Foundation
import Combine

class ListViewModel: ObservableObject {
    @Published var buddis: [Buddi] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadBuddis()
        
        $buddis
            .dropFirst() // Avoid triggering on initial load
            .debounce(for: 0.5, scheduler: RunLoop.main) // Debounce to minimize save operations
            .sink { [weak self] _ in
                self?.saveBuddis()
            }
            .store(in: &cancellables)
    }

    func addBuddi(name: String) {
        let newBuddi = Buddi(name: name, groups: [])
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

    func saveBuddis() {
        if let data = try? JSONEncoder().encode(buddis) {
            UserDefaults.standard.set(data, forKey: "buddis")
        }
    }
    
    func addGroup(toBuddiWithID buddiID: UUID, newGroup: Group) {
        if let index = buddis.firstIndex(where: { $0.id == buddiID }) {
            buddis[index].groups.append(newGroup)
            saveBuddis()
        }
    }
    
    func deleteBuddi(at index: Int) {
        buddis.remove(at: index)
        saveBuddis()
    }


}
