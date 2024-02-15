import Foundation
import Combine
import SwiftUI

class ListViewModel: ObservableObject {
    var buddis: [Buddi] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadBuddis()
    }
    
    // Load Buddis and sort by lastUpdated
    func loadBuddis() {
        if let data = UserDefaults.standard.data(forKey: "buddis"),
           var savedBuddis = try? JSONDecoder().decode([Buddi].self, from: data) {
            savedBuddis.sort { $0.lastUpdated > $1.lastUpdated } // Sort by most recently updated
            self.buddis = savedBuddis
        }
    }

    func saveBuddis() {
        if let data = try? JSONEncoder().encode(buddis) {
            UserDefaults.standard.set(data, forKey: "buddis")
        }
    }

    // Update the lastUpdated field whenever a change is made
    func updateLastUpdated(forBuddiID id: UUID) {
        if let index = buddis.firstIndex(where: { $0.id == id }) {
            buddis[index].lastUpdated = Date()
            saveBuddis()
            loadBuddis() // Reload to apply sorting
        }
    }

    func addBuddi(name: String) {
        let newBuddi = Buddi(name: name, groups: [])
        buddis.insert(newBuddi, at: 0)
        saveBuddis()
        loadBuddis() // Reload to apply sorting
    }

    func deleteBuddi(at index: Int) {
        buddis.remove(at: index)
        saveBuddis()
        loadBuddis() // Reload to apply sorting
    }

    // Assuming you will call this method when adding or removing groups/items to update the lastUpdated
    func addGroup(toBuddiWithID buddiID: UUID, newGroup: Group) {
        if let index = buddis.firstIndex(where: { $0.id == buddiID }) {
            buddis[index].groups.insert(newGroup, at: 0)
            updateLastUpdated(forBuddiID: buddiID) // Update lastUpdated date
        }
    }

    // Update this method to ensure lastUpdated is refreshed when items are added/removed
    func addItem(toGroupWithID groupId: UUID, newItem: Item, inBuddiWithID buddiID: UUID) {
        guard let buddiIndex = buddis.firstIndex(where: { $0.id == buddiID }),
              let groupIndex = buddis[buddiIndex].groups.firstIndex(where: { $0.id == groupId }) else {
            return
        }
        buddis[buddiIndex].groups[groupIndex].items.insert(newItem, at: 0) // Add new item at the start of the list
        updateLastUpdated(forBuddiID: buddiID) // Update lastUpdated date
    }

    func removeItem(withItemID itemId: UUID, fromGroupWithID groupId: UUID, inBuddiWithID buddiID: UUID) {
        guard let buddiIndex = buddis.firstIndex(where: { $0.id == buddiID }),
              let groupIndex = buddis[buddiIndex].groups.firstIndex(where: { $0.id == groupId }),
              let itemIndex = buddis[buddiIndex].groups[groupIndex].items.firstIndex(where: { $0.id == itemId }) else {
            return
        }
        buddis[buddiIndex].groups[groupIndex].items.remove(at: itemIndex)
        updateLastUpdated(forBuddiID: buddiID) // Update lastUpdated date
    }
    
    func fetchBuddiById(_ id: UUID) -> Buddi? {
        return buddis.first { $0.id == id }
    }

}
