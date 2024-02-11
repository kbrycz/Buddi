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
    
    func fetchBuddiById(_ id: UUID) -> Buddi? {
        return buddis.first { $0.id == id }
    }

    // Adds an item to a specific group within a Buddi
    func addItem(toGroupWithID groupId: UUID, newItemText: String, inBuddiWithID buddiID: UUID) {
        guard let buddiIndex = buddis.firstIndex(where: { $0.id == buddiID }),
              let groupIndex = buddis[buddiIndex].groups.firstIndex(where: { $0.id == groupId }) else {
            print("Group or Buddi not found")
            return
        }
        let newItem = Item(text: newItemText)
        buddis[buddiIndex].groups[groupIndex].items.insert(newItem, at: 0) // Add new item at the start of the list
        saveBuddis()
    }

    // Removes an item from a specific group within a Buddi
    func removeItem(withItemID itemId: UUID, fromGroupWithID groupId: UUID, inBuddiWithID buddiID: UUID) {
        guard let buddiIndex = buddis.firstIndex(where: { $0.id == buddiID }),
              let groupIndex = buddis[buddiIndex].groups.firstIndex(where: { $0.id == groupId }) else {
            print("Group or Buddi not found")
            return
        }
        guard let itemIndex = buddis[buddiIndex].groups[groupIndex].items.firstIndex(where: { $0.id == itemId }) else {
            print("Item not found")
            return
        }
        buddis[buddiIndex].groups[groupIndex].items.remove(at: itemIndex)
        saveBuddis()
    }


}
