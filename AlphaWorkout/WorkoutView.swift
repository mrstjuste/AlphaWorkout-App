import SwiftUI

struct Workout: Identifiable {
    let id = UUID()
    let name: String
}

struct WorkoutView: View {
    @State private var navigateToLog = false
    @State private var selectedWorkout: Workout?
    @State private var showSuccess = false

    let placeholderWorkouts = [
        Workout(name: "Full Body Blast"),
        Workout(name: "Leg Day"),
        Workout(name: "Push Pull Split"),
        Workout(name: "Cardio Core")
    ]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Quick Start")
                    .font(.headline)
                    .padding(.horizontal)

                NavigationLink(destination: LogWorkoutView(), isActive: $navigateToLog) {
                    EmptyView()
                }

                Button(action: {
                    navigateToLog = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Start Empty Workout")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                Text("Routines")
                    .font(.headline)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(placeholderWorkouts) { workout in
                            Button(action: {
                                selectedWorkout = workout
                                showSuccess = true
                            }) {
                                VStack {
                                    Image(systemName: "figure.strengthtraining.functional")
                                        .font(.largeTitle)
                                    Text(workout.name)
                                        .font(.subheadline)
                                }
                                .padding()
                                .frame(width: 150)
                                .background(Color(.systemGray5))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                HStack(spacing: 16) {
                    Button(action: {
                        navigateToLog = true
                    }) {
                        VStack {
                            Image(systemName: "doc.plaintext")
                                .font(.largeTitle)
                            Text("New Routine")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                    }

                    Button(action: {
                        // Future: Explore routines
                    }) {
                        VStack {
                            Image(systemName: "magnifyingglass")
                                .font(.largeTitle)
                            Text("Explore Routines")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)

                Spacer()

                Button(action: {
                    // Navigate to help or onboarding screen
                }) {
                    HStack {
                        Text("How to get started")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(Color(.systemBlue).opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            }
            .padding(.top)
            .navigationTitle("Workout")
            .alert(isPresented: $showSuccess) {
                Alert(
                    title: Text("Workout Created"),
                    message: Text("You selected \"\(selectedWorkout?.name ?? "")\"."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkoutView()
        }
        .preferredColorScheme(.dark)
    }
}
