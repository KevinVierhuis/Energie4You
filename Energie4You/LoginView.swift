import SwiftUI
import SQLite3

// informatie velden
struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var errorMessage: String? = nil

    // SQLite database
    private var db: OpaquePointer?

    init() {
        // Opent de database 
        if sqlite3_open("path_to_your_database.db", &db) != SQLITE_OK {
            print("Error opening database.")
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Logo
                Image("energie4you") // bestand naam
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100) // Adjust size
                    .padding(.top, 40)
                
                // Pagina title
                Text("Log in Account")
                    .font(.title)
                    .bold()
                    .padding(.top, 20)
                
                // Input velden
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
                        .textContentType(.none)
                }
                .padding(.horizontal, 40)
                
                // Wachtwoord vergeten
                Button(action: {
                    print("Forgot Password tapped")
                }) {
                    Text("Wachtwoord vergeten?")
                        .font(.footnote)
                        .foregroundColor(.orange)
                }
                
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
                
                // Log In
                Button(action: {
                    
                    if !email.isEmpty && !password.isEmpty {
                        
                        if validateUserCredentials(email: email, password: password) {
                            isLoggedIn = true
                        } else {
                            errorMessage = "Ongeldige inloggegevens."                         }
                    } else {
                        errorMessage = "Vul zowel e-mailadres als wachtwoord in."
                    }
                }) {
                    Text("Log In")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                
                
                .navigationDestination(isPresented: $isLoggedIn) {
                    HomeView()
                }
            }
            .padding()
        }
    }

    
    private func validateUserCredentials(email: String, password: String) -> Bool {
        
        let selectQuery = "SELECT * FROM users WHERE email = ? AND password = ?;"
        var stmt: OpaquePointer?
        var isValid = false
        
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, email, -1, nil)
            sqlite3_bind_text(stmt, 2, password, -1, nil)
            
            
            if sqlite3_step(stmt) == SQLITE_ROW {
                isValid = true
            }
        } else {
            print("Error preparing select statement")
        }
        sqlite3_finalize(stmt)
        
        return isValid
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewDevice("iPhone 14") 
    }
}
