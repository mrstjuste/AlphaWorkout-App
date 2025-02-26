//
//  LoginView.swift
//  AlphaWorkout
//
//  Created by Brian St-Juste on 2/4/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn: Bool = false
    @State private var username: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button(action: loginUser) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                NavigationLink(destination: SignupView()) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                }
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $isLoggedIn) {
                HomeView(username: username) // Navigates to HomeView when isLoggedIn is true
            }
        }
    }

    /// Function to handle login
    func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        guard let url = URL(string: "http://localhost:9090/v1/user/login/:user") else {
            errorMessage = "Invalid server URL"
            return
        }

        let loginData: [String: Any] = ["email": email, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: loginData) else {
            errorMessage = "Failed to encode request"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                    errorMessage = "Invalid server response"
                    return
                }

                if httpResponse.statusCode == 200 {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let user = json?["user"] as? [String: Any], let name = user["username"] as? String {
                            self.username = name
                            self.isLoggedIn = true
                        }
                    } catch {
                        errorMessage = "Error parsing response"
                    }
                } else {
                    errorMessage = "Invalid credentials"
                }
            }
        }.resume()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
} 
