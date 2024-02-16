import SwiftUI
import UniformTypeIdentifiers

class BuddiFileDocument: FileDocument {
    var data: Data
    
    static var readableContentTypes: [UTType] { [.json] }
    static var writableContentTypes: [UTType] { [.json] }
    
    init(data: Data) {
        self.data = data
    }
    
    required init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.data = data
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
    
    // This function is used to write data to a temporary file and return its URL.
    func writeDataToTemporaryFile() -> URL? {
        let temporaryDirectoryURL = FileManager.default.temporaryDirectory
        let temporaryFilename = temporaryDirectoryURL.appendingPathComponent("buddi-data.json")
        
        do {
            try data.write(to: temporaryFilename)
            return temporaryFilename
        } catch {
            print("Failed to write JSON data to temporary file: \(error)")
            return nil
        }
    }
}

