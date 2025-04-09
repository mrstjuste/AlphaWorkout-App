import SwiftUI

struct Exercise: Identifiable {
    let id = UUID()
    var name: String
    var reps: String
    var sets: String
    var restTime: String
}

struct WorkoutDay: Identifiable {
    let id = UUID()
    var day: String
    var workoutType: String
    var focus: String
    var exercises: [Exercise]
}

struct CalendarView: View {
    @State private var workouts: [WorkoutDay] = [
        WorkoutDay(day: "Monday", workoutType: "Push", focus: "Chest, Shoulders, Triceps", exercises: [
            Exercise(name: "Bench Press", reps: "8-12", sets: "4", restTime: "60s"),
            Exercise(name: "Shoulder Press", reps: "8-12", sets: "4", restTime: "60s")
        ]),
        WorkoutDay(day: "Tuesday", workoutType: "Pull", focus: "Back, Biceps, Rear Delts", exercises: [
            Exercise(name: "Pull-Ups", reps: "8-12", sets: "4", restTime: "60s"),
            Exercise(name: "Barbell Rows", reps: "8-12", sets: "4", restTime: "60s")
        ]),
        WorkoutDay(day: "Wednesday", workoutType: "Conditioning", focus: "Cardio, Agility, Core", exercises: [
            Exercise(name: "Jump Rope", reps: "1 min", sets: "4", restTime: "30s"),
            Exercise(name: "Plank Hold", reps: "45s", sets: "3", restTime: "30s")
        ]),
        WorkoutDay(day: "Thursday", workoutType: "Push", focus: "Legs (Quads, Glutes, Calves)", exercises: [
            Exercise(name: "Squats", reps: "8-12", sets: "4", restTime: "60s"),
            Exercise(name: "Lunges", reps: "12 reps/leg", sets: "3", restTime: "45s")
        ]),
        WorkoutDay(day: "Friday", workoutType: "Pull", focus: "Posterior Chain (Hamstrings, Glutes, Back)", exercises: [
            Exercise(name: "Deadlifts", reps: "6-10", sets: "4", restTime: "90s"),
            Exercise(name: "Hamstring Curls", reps: "10-12", sets: "3", restTime: "45s")
        ]),
        WorkoutDay(day: "Saturday", workoutType: "Recovery", focus: "Mobility, Yoga, Light Cardio", exercises: [
            Exercise(name: "Yoga Flow", reps: "20 mins", sets: "1", restTime: "N/A"),
            Exercise(name: "Foam Rolling", reps: "10 mins", sets: "1", restTime: "N/A")
        ]),
        WorkoutDay(day: "Sunday", workoutType: "Conditioning", focus: "HIIT, Core, Sprints", exercises: [
            Exercise(name: "Sprints", reps: "30s", sets: "6", restTime: "30s"),
            Exercise(name: "Burpees", reps: "15", sets: "4", restTime: "45s")
        ])
    ]
    
    @State private var selectedDayIndex = 0
    @State private var showingAddExercise = false
    @State private var newExercise = Exercise(name: "", reps: "", sets: "", restTime: "")

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Workout Planner")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .padding(.top, 40)

                Picker("Select a Day", selection: $selectedDayIndex) {
                    ForEach(workouts.indices, id: \.self) { index in
                        Text(workouts[index].day).tag(index)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color.red.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)

                VStack(spacing: 15) {
                    Text(workouts[selectedDayIndex].day)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text("Workout Type: \(workouts[selectedDayIndex].workoutType)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)

                    Text("Focus: \(workouts[selectedDayIndex].focus)")
                        .font(.body)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)

                    Divider().background(Color.black)

                    Text("Exercises")
                        .font(.headline)
                        .foregroundColor(.red)

                    List {
                        ForEach(workouts[selectedDayIndex].exercises.indices, id: \.self) { index in
                            VStack(alignment: .leading) {
                                Text(workouts[selectedDayIndex].exercises[index].name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                HStack {
                                    Text("Reps: \(workouts[selectedDayIndex].exercises[index].reps)")
                                    Spacer()
                                    Text("Sets: \(workouts[selectedDayIndex].exercises[index].sets)")
                                    Spacer()
                                    Text("Rest: \(workouts[selectedDayIndex].exercises[index].restTime)")
                                        .foregroundColor(.red)
                                }
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .onTapGesture {
                                editExercise(dayIndex: selectedDayIndex, exerciseIndex: index)
                            }
                        }
                        .onDelete { indexSet in
                            workouts[selectedDayIndex].exercises.remove(atOffsets: indexSet)
                        }
                    }
                    .frame(height: 200)
                    .cornerRadius(10)

                    Button(action: {
                        showingAddExercise.toggle()
                    }) {
                        Text("Add Exercise")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
            }
            .sheet(isPresented: $showingAddExercise) {
                VStack {
                    Text("Add/Edit Exercise")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()

                    TextField("Exercise Name", text: $newExercise.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Reps", text: $newExercise.reps)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Sets", text: $newExercise.sets)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("Rest Time", text: $newExercise.restTime)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: {
                        workouts[selectedDayIndex].exercises.append(newExercise)
                        showingAddExercise = false
                        newExercise = Exercise(name: "", reps: "", sets: "", restTime: "")
                    }) {
                        Text("Save Exercise")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
        }
    }
    
    private func editExercise(dayIndex: Int, exerciseIndex: Int) {
        newExercise = workouts[dayIndex].exercises[exerciseIndex]
        workouts[dayIndex].exercises.remove(at: exerciseIndex)
        showingAddExercise = true
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
