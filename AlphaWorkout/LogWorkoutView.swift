import SwiftUI

struct Workout: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

struct LogWorkoutView: View {
    @State private var selectedWorkout: Workout? = nil
    @State private var showWorkoutPicker = false
    @State private var showExercisePicker = false

    let mockWorkouts = [
        Workout(name: "Full Body Burn"),
        Workout(name: "Upper Body Strength"),
        Workout(name: "Leg Day Crusher"),
        Workout(name: "Cardio Core Blast"),
        Workout(name: "Push Pull Routine")
    ]

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Log Workout")
                        .font(.headline)
                    if let workout = selectedWorkout {
                        Text(workout.name)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Button("Finish") {
                    // Finish workout action
                }
                .padding(.horizontal)
            }
            .padding()

            HStack {
                VStack(alignment: .leading) {
                    Text("Duration")
                    Text("1s")
                        .foregroundColor(.blue)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Volume")
                    Text("0 lbs")
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Sets")
                    Text("0")
                }
            }
            .padding(.horizontal)

            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "dumbbell.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)

                Text(selectedWorkout == nil ? "Choose a workout" : "Get started")
                    .font(.headline)

                Text(selectedWorkout == nil
                     ? "Select a workout routine to begin"
                     : "Add an exercise to start your workout")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                if selectedWorkout == nil {
                    Button(action: {
                        showWorkoutPicker = true
                    }) {
                        Text("+ Choose Workout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                } else {
                    Button(action: {
                        showExercisePicker = true
                    }) {
                        Text("+ Add Exercise")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }

                HStack {
                    Button("Settings") {
                        // Workout settings
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)

                    Button("Discard Workout") {
                        selectedWorkout = nil
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(.red)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .sheet(isPresented: $showWorkoutPicker) {
            WorkoutPickerView(
                workouts: mockWorkouts,
                onSelect: { workout in
                    selectedWorkout = workout
                    showWorkoutPicker = false
                }
            )
        }
        .sheet(isPresented: $showExercisePicker) {
            Text("Exercise Picker Placeholder")
        }
    }
}

struct WorkoutPickerView: View {
    let workouts: [Workout]
    let onSelect: (Workout) -> Void

    var body: some View {
        NavigationView {
            List(workouts, id: \.self) { workout in
                Button(action: {
                    onSelect(workout)
                }) {
                    Text(workout.name)
                }
            }
            .navigationTitle("Choose Workout")
        }
    }
}

struct LogWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        LogWorkoutView()
            .preferredColorScheme(.dark)
    }
}
