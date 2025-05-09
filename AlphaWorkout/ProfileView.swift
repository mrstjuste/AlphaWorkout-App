import SwiftUI
import Charts

struct ProfileView: View {
    var username: String = "mrstjuste"
    var profileCompletion: Double = 0.8

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // Header
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                        }
                        Button(action: {}) {
                            Image(systemName: "gear")
                        }
                    }
                    .padding(.horizontal)

                    // Profile
                    VStack(spacing: 8) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 60, height: 60)
                            .overlay(Text("B").font(.title).foregroundColor(.white))

                        Text(username)
                            .font(.title3)
                            .bold()

                        HStack(spacing: 30) {
                            VStack {
                                Text("0").bold()
                                Text("Workouts")
                            }
                            VStack {
                                Text("0").bold()
                                Text("Volume")
                            }
                            VStack {
                                Text("0").bold()
                                Text("Reps")
                            }
                        }
                        .foregroundColor(.gray)
                    }

                    // Profile Completion
//                    Button(action: {}) {
//                        HStack {
//                            Text("Your profile is \(Int(profileCompletion * 100))% finished")
//                            Spacer()
//                            Image(systemName: "chevron.right")
//                        }
//                        .padding()
//                        .background(Color(.systemBlue).opacity(0.2))
//                        .cornerRadius(10)
//                    }
//                    .padding(.horizontal)

                    // Chart and Filter Buttons
                    VStack(alignment: .leading) {
                        UserDataPoints()
                    }

                    // Dashboard Buttons
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            DashboardButton(title: "Statistics", icon: "chart.line.uptrend.xyaxis")
                            DashboardButton(title: "Exercises", icon: "dumbbell.fill")
                        }
                        HStack(spacing: 10) {
                            DashboardButton(title: "Measures", icon: "figure.stand")
                            DashboardButton(title: "Calendar", icon: "calendar")
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 100)
                }
                .padding(.top)
                .navigationTitle(username)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct DashboardButton: View {
    let title: String
    let icon: String

    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct FilterButtonStyle: ButtonStyle {
    var selected: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.footnote)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(selected ? Color.blue : Color(.systemGray5))
            .foregroundColor(selected ? .white : .primary)
            .cornerRadius(10)
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
