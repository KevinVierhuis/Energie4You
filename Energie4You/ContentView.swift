import SwiftUI
import SQLite3

// Informatie velden
struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isRegistered: Bool = false
    @State private var errorMessage: String? = nil
    
    // Input velden
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image("energie4you")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                    .padding(.top, 40)
                
                Text("Registreren")
                    .font(.title)
                    .bold()
                    .padding(.top, 20)
                
                VStack(spacing: 15) {
                    TextField("E-mailadres", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("Wachtwoord", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("Bevestig Wachtwoord", text: $confirmPassword)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                Button(action: {
                    if password == confirmPassword {
                        isRegistered = true
                    } else {
                        errorMessage = "Wachtwoorden komen niet overeen."
                    }
                }) {
                    Text("Account Aanmaken")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
            }
            .padding()
            .navigationDestination(isPresented: $isRegistered) {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
