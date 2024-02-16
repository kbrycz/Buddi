import Foundation
import SwiftUI
import UniformTypeIdentifiers

class SettingsViewModel: ObservableObject {
    @Published var showExportDocumentPicker = false
    @Published var showImportDocumentPicker = false
    @Published var document: BuddiFileDocument?
    @Published var importCompletion: ((Bool) -> Void)?
    
    func exportData() {
        let buddies = loadBuddis()
        do {
            let jsonData = try JSONEncoder().encode(buddies)
            let file = BuddiFileDocument(data: jsonData)
            self.document = file
            self.showExportDocumentPicker = true // This should trigger the sheet to open
        } catch {
            print("Error encoding data: \(error)")
        }
    }

    func importData(from url: URL, completion: @escaping (Bool) -> Void) {
        let fileCoordinator = NSFileCoordinator()
        var error: NSError? = nil

        // Requesting access to the security-scoped resource.
        url.startAccessingSecurityScopedResource()
        
        fileCoordinator.coordinate(readingItemAt: url, options: [], error: &error) { (newURL) in
            do {
                let data = try Data(contentsOf: newURL)
                let importedBuddies = try JSONDecoder().decode([Buddi].self, from: data)
                
                DispatchQueue.main.async {
                    self.saveBuddis(importedBuddies)
                    completion(true) // Import successful
                }
            } catch {
                print("Failed to import Buddis: \(error)")
                DispatchQueue.main.async {
                    completion(false) // Import failed
                }
            }
        }
        
        // Relinquishing access to the security-scoped resource.
        url.stopAccessingSecurityScopedResource()

        if let error = error {
            print("Failed to read file due to error: \(error.localizedDescription)")
            completion(false)
        }
    }

    private func saveBuddis(_ buddis: [Buddi]) {
        if let data = try? JSONEncoder().encode(buddis) {
            UserDefaults.standard.set(data, forKey: "buddis")
        }
    }
    
    private func share(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    private func loadBuddis() -> [Buddi] {
        if let data = UserDefaults.standard.data(forKey: "buddis"),
           let savedBuddis = try? JSONDecoder().decode([Buddi].self, from: data) {
            return savedBuddis.sorted { $0.lastUpdated > $1.lastUpdated }
        }
        return []
    }
}
