import Foundation

class UserAPI {
    static func createUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://storingspunt-d02668d953a7.herokuapp.com/api/users") else {
            completion(.failure(NSError(domain: "UserAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/ld+json", forHTTPHeaderField: "Accept")
        
        let body: [String: Any] = [
            "email": email, // Gebruik de email parameter die door de method is doorgepaast
            "roles": ["ROLE_USER"],
            "password": password // Gebruik de wachtwoord parameter die door de method is doorgepaast
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        // Maak de API request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "UserAPI", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseString)")
            }

            switch httpResponse.statusCode {
            case 201:
                completion(.success(()))
            case 400:
                completion(.failure(NSError(domain: "UserAPI", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid input"])))
            case 422:
                completion(.failure(NSError(domain: "UserAPI", code: 422, userInfo: [NSLocalizedDescriptionKey: "Unprocessable entity - invalid input data"])))
            default:
                completion(.failure(NSError(domain: "UserAPI", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Registration failed with status code: \(httpResponse.statusCode)"])))
            }
        }.resume()
    }
}
