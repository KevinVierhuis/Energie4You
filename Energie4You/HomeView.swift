import SwiftUI

struct HomeView: View {
    // Categorien
    let categories = ["Grondkabels", "Hoogspanning", "Schakelkasten", "Luchtkabels"]
    
    var body: some View {
        // ScrollView om te scrollen
        ScrollView {
            VStack(spacing: 20) {
                // Category knoppen
                HStack(spacing: 10) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                            .font(.subheadline)
                            .padding(10)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 20)
                
                // Knop om naar DefectRegistratie te gaan
                NavigationLink(destination: RegistrationView()) {
                    Text("Defect Registreren")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarTitle("Home", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            // Kan gebruikt worden voor settings
        }) {
            Image(systemName: "gear")
                .foregroundColor(.orange)
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
