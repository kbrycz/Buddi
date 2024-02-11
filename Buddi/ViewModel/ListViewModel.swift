import Foundation
import Combine
import SwiftUI

class ListViewModel: ObservableObject {
    var buddis: [Buddi] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadBuddis()
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

    func loadBuddis() {
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
            buddis[index].groups.insert(newGroup, at: 0)
            saveBuddis()
            print(buddis[index])
        }
    }
    
    func deleteBuddi(at index: Int) {
        buddis.remove(at: index)
        saveBuddis()
    }


}
