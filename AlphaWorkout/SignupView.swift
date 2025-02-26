import SwiftUI

struct SignupView: View {
    @State private var username: String = ""
    @State private var name: String = ""
    @State private var age: String = "0"
    @State private var height: String = "0"
    @State private var currweight: String = "0"
    @State private var month: Int = 1
    @State private var day: Int = 1
    @State private var year: Int = 2000
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var showSuccessModal: Bool = false
    @State private var navigateToLogin: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 80)

                    Group {
                        InputField(label: "Username", text: $username, placeholder: "Enter username")
                        InputField(label: "Full Name", text: $name, placeholder: "Enter full name")
                        InputField(label: "Age", text: $age, placeholder: "Enter age", keyboardType: .numberPad)
                        InputField(label: "Height (cm)", text: $height, placeholder: "Enter height", keyboardType: .numberPad)
                        InputField(label: "Current Weight (kg)", text: $currweight, placeholder: "Enter weight", keyboardType: .numberPad)
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Date of Birth")
                            .font(.headline)
                        HStack {
                            Picker("Month", selection: $month) {
                                ForEach(1...12, id: \.self) { Text("\($0)") }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)

                            Picker("Day", selection: $day) {
                                ForEach(1...31, id: \.self) { Text("\($0)") }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)

                            Picker("Year", selection: $year) {
                                ForEach(1900...2025, id: \.self) { Text("\($0)") }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)

                    InputField(label: "Email", text: $email, placeholder: "Enter email", keyboardType: .emailAddress)
                    InputField(label: "Password", text: $password, placeholder: "Enter password", isSecure: true)
                    InputField(label: "Confirm Password", text: $confirmPassword, placeholder: "Confirm password", isSecure: true)

                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }

                    Button(action: signupUser) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)

                    Spacer().frame(height: 150)
                }
                .padding(.horizontal)
            }
            .ignoresSafeArea(.keyboard)
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView() // Redirects to LoginView when navigateToLogin is true
            }
            .alert("Account Created Successfully!", isPresented: $showSuccessModal) {
                Button("OK") {
                    navigateToLogin = true // Redirect to login when OK is clicked
                }
            } message: {
                Text("You can now log in with your new account.")
            }
        }
    }

    func signupUser() {
        guard let url = URL(string: "http://localhost:9090/v1/user/create") else {
            errorMessage = "Invalid server URL"
            showError = true
            return
        }

        if password != confirmPassword {
            errorMessage = "Passwords do not match!"
            showError = true
            return
        }

        let userData: [String: Any] = [
            "username": username,
            "name": name,
            "age": Int(age) ?? 0,
            "height": Int(height) ?? 0,
            "currweight": Int(currweight) ?? 0,
            "birthdate": ["month": month, "day": day, "year": year],
            "email": email,
            "password": password
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: userData) else {
            errorMessage = "Failed to encode user data"
            showError = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    showError = true
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    errorMessage = "Invalid server response"
                    showError = true
                    return
                }

                if httpResponse.statusCode == 200 {
                    showSuccessModal = true // Show success modal
                } else {
                    errorMessage = "Signup failed. Status code: \(httpResponse.statusCode)"
                    showError = true
                }
            }
        }.resume()
    }
}

struct InputField: View {
    let label: String
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.headline)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(keyboardType)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(keyboardType)
            }
        }
        .padding(.horizontal)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
