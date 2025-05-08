//
//  LoginView.swift
//  AlphaWorkout
//
//  Created by Brian St-Juste on 2/4/25.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    @State private var isLoggedIn: Bool = false

    @AppStorage("username") var storedUsername: String = ""
    @AppStorage("authToken") var authToken: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                if isLoading {
                    ProgressView()
                        .padding()
                }

                Button(action: loginUser) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(isLoading)
                .padding(.horizontal)

                NavigationLink(destination: SignupView()) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                }

                NavigationLink(destination: WorkoutView(), isActive: $isLoggedIn) {
                    EmptyView()
                }

                Spacer()
            }
            .padding()
        }
    }

    /// Function to handle login
    func loginUser() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        guard let url = URL(string: "http://localhost:9090/v1/user/login/\(username)") else {
            errorMessage = "Invalid server URL"
            return
        }

        let loginData: [String: Any] = ["password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: loginData) else {
            errorMessage = "Failed to encode request"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        isLoading = true

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                    self.errorMessage = "Invalid server response"
                    return
                }

                if httpResponse.statusCode == 200 {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                        if let user = json?["user"] as? [String: Any],
                           let token = user["token"] as? String,
                           let name = user["username"] as? String {

                            self.storedUsername = name
                            self.authToken = token
                            self.isLoggedIn = true
                        } else {
                            self.errorMessage = "Invalid response data"
                        }

                    } catch {
                        self.errorMessage = "Error parsing response"
                    }
                } else {
                    self.errorMessage = "Invalid credentials"
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
