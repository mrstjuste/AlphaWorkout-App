import SwiftUI

struct Workout: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var sets: Int
    var reps: Int
    var weight: Int
}


struct Routine: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var workouts: [Workout] = []
}

struct WorkoutView: View {
    
    

    @State private var selectedRoutine: Routine?
    @State private var editingRoutine: Routine?
    @State private var editingRoutineName: String = ""

    @State private var selectedWorkout: Workout?
    @State private var showSuccess = false
    @State private var showingLogWorkout = false
    @State private var myRoutines: [Routine] = []
    @State private var showingAddToRoutine = false
    @State private var newRoutineName = ""
    
    @State private var showingExploreRoutines = false
    
    @State private var showingRoutineBuilder = false



    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    quickStartSection
                    routinesSection
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Workout")
            .navigationDestination(item: $selectedRoutine) { routine in
                RoutineDetailView(routine: routine)
            }
            .sheet(isPresented: $showingLogWorkout) {
                LogWorkoutView { newRoutine in
                    myRoutines.append(newRoutine)
                    showingLogWorkout = false
                }
            }
            .sheet(isPresented: $showingExploreRoutines) {
                ExploreRoutinesView { selected in
                    myRoutines.append(selected)
                    showingExploreRoutines = false
                }
            }
            .sheet(isPresented: $showingRoutineBuilder) {
                RoutineBuilderView { newRoutine in
                    myRoutines.append(newRoutine)
                    showingRoutineBuilder = false
                }
            }

//            .alert("New Routine", isPresented: $showingAddToRoutine) {
//                TextField("Routine Name", text: $newRoutineName)
//                Button("Cancel", role: .cancel) {
//                    newRoutineName = ""
//                }
//                Button("Create") {
//                    let newRoutine = Routine(name: newRoutineName)
//                    myRoutines.append(newRoutine)
//                    newRoutineName = ""
//                }
//            }
            .alert(isPresented: $showSuccess) {
                Alert(
                    title: Text("Workout Created"),
                    message: Text("You selected \"\(selectedWorkout?.name ?? "")\"."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert("Edit Routine Name", isPresented: Binding(
                get: { editingRoutine != nil },
                set: { if !$0 { editingRoutine = nil } }
            ), actions: {
                TextField("Routine Name", text: $editingRoutineName)
                Button("Cancel", role: .cancel) {
                    editingRoutine = nil
                    editingRoutineName = ""
                }
                Button("Save") {
                    if let routine = editingRoutine,
                       let index = myRoutines.firstIndex(where: { $0.id == routine.id }) {
                        myRoutines[index].name = editingRoutineName
                    }
                    editingRoutine = nil
                }
            })
        }
    }

    private var quickStartSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Quick Start")
                .font(.headline)
                .padding(.horizontal)

            Button(action: {
                showingLogWorkout = true
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

            HStack(spacing: 16) {
                Button(action: {
                    showingLogWorkout = true
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
                    showingExploreRoutines = true
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
        }
    }

    private var routinesSection: some View {
        VStack(alignment: .leading) {
            Text("My Routines (\(myRoutines.count))")
                .font(.headline)
                .padding(.horizontal)

            if myRoutines.isEmpty {
                Text("No routines yet. Create your first routine!")
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            } else {
                ForEach(myRoutines) { routine in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(routine.name)
                                .font(.subheadline)
                            Spacer()
                            Button("Edit") {
                                editingRoutine = routine
                                editingRoutineName = routine.name
                            }
                            .foregroundColor(.orange)

                            Button("Start Routine") {
                                selectedRoutine = routine
                            }
                            .foregroundColor(.blue)
                        }

                        if routine.workouts.isEmpty {
                            Text("No workouts added yet")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.leading)
                        } else {
                            ForEach(routine.workouts) { workout in
                                Text("\(workout.name) — \(workout.sets)x\(workout.reps) @ \(workout.weight)lbs")
                                    .font(.caption)
                                    .padding(.leading)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }
}

// MARK: - Routine Detail View

struct RoutineDetailView: View {
    var routine: Routine

    @State private var completedWorkoutIDs: Set<UUID> = []
    @State private var showCompletionModal = false
    @State private var navigateToProfile = false

    var body: some View {
        VStack {
            List {
                ForEach(routine.workouts) { workout in
                    HStack {
                        Image(systemName: completedWorkoutIDs.contains(workout.id) ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                toggle(workout)
                            }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(workout.name)
                                .font(.headline)
                                .strikethrough(completedWorkoutIDs.contains(workout.id))
                                .foregroundColor(completedWorkoutIDs.contains(workout.id) ? .gray : .primary)

                            Text("\(workout.sets)x\(workout.reps) @ \(workout.weight)lbs")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                    }
                }
            }

            // Navigation trigger
            .navigationDestination(isPresented: $navigateToProfile) {
                ProfileView()
            }
        }
        .navigationTitle(routine.name)
        .alert("Workout Complete!", isPresented: $showCompletionModal) {
            Button("Go to Profile") {
                navigateToProfile = true
            }
        }
    }

    private func toggle(_ workout: Workout) {
        if completedWorkoutIDs.contains(workout.id) {
            completedWorkoutIDs.remove(workout.id)
        } else {
            completedWorkoutIDs.insert(workout.id)
        }

        // Trigger success when all are completed
        if completedWorkoutIDs.count == routine.workouts.count && !routine.workouts.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showCompletionModal = true
            }
        }
    }
}


// MARK: - Preview

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}

// MARK: - Explore Routines View
struct ExploreRoutinesView: View {
    var onSelect: (Routine) -> Void

    let sampleRoutines: [Routine] = [
        Routine(name: "Leg Day", workouts: [
            Workout(name: "Squats", sets: 4, reps: 10, weight: 135),
            Workout(name: "Lunges", sets: 3, reps: 12, weight: 50),
            Workout(name: "Leg Press", sets: 4, reps: 10, weight: 200)
        ]),
        Routine(name: "Push Day", workouts: [
            Workout(name: "Bench Press", sets: 4, reps: 8, weight: 155),
            Workout(name: "Overhead Press", sets: 3, reps: 10, weight: 95),
            Workout(name: "Triceps Dips", sets: 3, reps: 12, weight: 0)
        ]),
        Routine(name: "Pull Day", workouts: [
            Workout(name: "Pull-Ups", sets: 3, reps: 8, weight: 0),
            Workout(name: "Barbell Rows", sets: 4, reps: 10, weight: 115),
            Workout(name: "Face Pulls", sets: 3, reps: 15, weight: 30)
        ])
    ]

    var body: some View {
        NavigationView {
            List(sampleRoutines) { routine in
                Button {
                    onSelect(routine)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(routine.name)
                            .font(.headline)

                        ForEach(routine.workouts) { workout in
                            Text("• \(workout.name) — \(workout.sets)x\(workout.reps) @ \(workout.weight)lbs")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Explore Routines")
        }
    }
}


struct RoutineBuilderView: View {
    @Environment(\.dismiss) var dismiss
    var onSave: (Routine) -> Void

    @State private var routineName: String
    @State private var exercises: [Workout] = []

    init(initialName: String = "", onSave: @escaping (Routine) -> Void) {
        self._routineName = State(initialValue: initialName)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Routine Name")) {
                    TextField("Enter a name", text: $routineName)
                }

                Section(header: Text("Exercises")) {
                    if exercises.isEmpty {
                        Text("No workouts yet").foregroundColor(.gray)
                    } else {
                        ForEach(exercises) { workout in
                            VStack(alignment: .leading) {
                                Text("\(workout.name)")
                                    .font(.headline)
                                Text("\(workout.sets)x\(workout.reps) @ \(workout.weight)lbs")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .onDelete { indexSet in
                            exercises.remove(atOffsets: indexSet)
                        }
                    }

                    Button("+ Add Exercise") {
                        let newWorkout = Workout(name: "New Exercise", sets: 3, reps: 10, weight: 50)
                        exercises.append(newWorkout)
                    }
                }
            }
            .navigationTitle("Build Routine")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let routine = Routine(name: routineName, workouts: exercises)
                        onSave(routine)
                        dismiss()
                    }
                    .disabled(routineName.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
