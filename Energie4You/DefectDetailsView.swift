import SwiftUI

struct DefectDetailsView: View {
    @State private var defectName: String
    @State private var defectDescription: String
    @State private var selectedCategory: String
    @State private var defectImage: UIImage? // Placeholder

    init(defectName: String, defectDescription: String, defectImage: UIImage?, selectedCategory: String) {
        _defectName = State(initialValue: defectName)
        _defectDescription = State(initialValue: defectDescription)
        _selectedCategory = State(initialValue: selectedCategory)
        self.defectImage = defectImage
    }
    
    var body: some View {
        ZStack {
            // Achtergrond kleur
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Image("energie4you")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 70)
                        
                        Text("Defect Details")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .padding(.top, 20)
                    
                    // Editable kaarten
                    detailCard(title: "Naam", placeholder: "Enter defect name", text: $defectName)
                    detailCard(title: "Beschrijving", placeholder: "Enter description", text: $defectDescription, isLarge: true)
                    detailCard(title: "Categorie", placeholder: "Select a category", text: $selectedCategory)
                    
                    // Image sectie
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Afbeelding")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        if let image = defectImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .cornerRadius(12)
                                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)
                        } else {
                            Text("No image available")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            // Save actie
                            print("Defect saved with values: \(defectName), \(defectDescription), \(selectedCategory)")
                        }) {
                            Text("Save")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            // Cancel actie
                            print("Defect changes discarded")
                        }) {
                            Text("Cancel")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarTitle("Details", displayMode: .inline)
    }
    
    // Herbruikbare kaart voor input velden
    private func detailCard(title: String, placeholder: String, text: Binding<String>, isLarge: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            if isLarge {
                TextEditor(text: text)
                    .frame(height: 100)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)
            } else {
                TextField(placeholder, text: text)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct DefectDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DefectDetailsView(
            defectName: "Grondkabel defect",
            defectDescription: "Er is een probleem met de grondkabel in dit gebied.",
            defectImage: UIImage(named: "defectImage"),
            selectedCategory: "Grondkabels"
        )
    }
}
