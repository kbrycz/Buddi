import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var showMessage = false
    @State private var messageText = ""
    @State private var showingImportPicker = false

    var body: some View {
        VStack(spacing: 10) { // Add spacing between elements
            Text("Buddi does not store your data! Because of this, you are responsible for backing up all of your notes! Export your data to a json file to later import it if you switch devices!")
                .font(.custom("Quicksand-Medium", size: 16))
                .lineSpacing(8.0)
                .foregroundColor(.customText) // Custom text color
                .padding(.top, 40) // Increased top padding
                .padding(.bottom, 40) // Increased top padding
                .padding(.horizontal) // Add horizontal padding

            Button(action: {
                self.showMessage = false
                viewModel.exportData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adjust delay as needed
                    self.showMessageWithText("Exported successfully.")
                }
            }) {
                Text("Save Data")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.customText) // Custom button color
                    .foregroundColor(.customBackground) // For better contrast
                    .cornerRadius(10)
                    .shadow(radius: 5) // Add subtle shadow
                    .font(.custom("Quicksand-Medium", size: 18))
            }
            .sheet(isPresented: $viewModel.showExportDocumentPicker) {
                // This ensures the sheet is presented when showExportDocumentPicker is true
                if let document = viewModel.document {
                    DocumentPicker(document: document, mode: .export) { urls in
                    }
                }
            }
            Button(action: {
                self.showMessage = false
                showingImportPicker = true
            }) {
                Text("Import Data")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.buttonGray) // Custom button color
                    .foregroundColor(.customText) // For better contrast
                    .cornerRadius(10)
                    .shadow(radius: 5) // Add subtle shadow
                    .font(.custom("Quicksand-Medium", size: 18))
            }
            .fileImporter(
                isPresented: $showingImportPicker,
                allowedContentTypes: [.json],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                    case .success(let urls):
                        guard let url = urls.first else { return }
                        viewModel.importData(from: url) { success in
                            // Optionally show a message based on the success/failure
                            showMessageWithText(success ? "Imported successfully." : "Failed to import data.")
                        }
                    case .failure(let error):
                        print("Error importing file: \(error.localizedDescription)")
                        // Optionally show an error message to the user
                        showMessageWithText("Failed to import data.")
                }
            }

            if showMessage {
                
                Text(messageText)
                    .font(.custom("Quicksand-Regular", size: 16))
                    .foregroundColor(.customText)
                    .transition(.scale.combined(with: .opacity)) // Animated appearance
                    .onAppear {
                        if messageText.starts(with: "E") {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 25) {
                                withAnimation {
                                    self.showMessage = false
                                }
                            }
                        }
                        else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    self.showMessage = false
                                }
                            }
                        }
                    }
            }
            
            Text("Version 1.0.0")
                .font(.custom("Quicksand-Regular", size: 12))
                .foregroundColor(.customText) // Custom text color
                .padding() // Add padding around the text

            Spacer()
        }
        .padding(.horizontal) // Add horizontal padding
        .background(Color.customBackground.edgesIgnoringSafeArea(.all)) // Set background color
        .navigationBarTitle("Settings", displayMode: .inline)
    }

    private func showMessageWithText(_ text: String) {
        withAnimation {
            messageText = text
            showMessage = true
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    var document: BuddiFileDocument
    
    enum Mode {
        case imp, export
    }
    
    var mode: Mode
    var completion: ([URL]) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        switch mode {
            case .export:
                if let fileURL = document.writeDataToTemporaryFile() {
                    let picker = UIDocumentPickerViewController(forExporting: [fileURL], asCopy: true)
                    return picker
                } else {
                    return UIDocumentPickerViewController(forOpeningContentTypes: [UTType.json])
                }
            case .imp:
                let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.json], asCopy: true)
                picker.allowsMultipleSelection = false
                picker.delegate = context.coordinator
                return picker
        }
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        // No update code needed for export picker
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, completion: completion)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        var completion: ([URL]) -> Void
        
        init(_ documentPicker: DocumentPicker, completion: @escaping ([URL]) -> Void) {
            self.parent = documentPicker
            self.completion = completion
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            completion(urls)
        }
    }
}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
