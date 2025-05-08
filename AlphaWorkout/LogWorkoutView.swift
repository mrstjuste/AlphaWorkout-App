import SwiftUI

struct LogWorkoutView: View {
    var onFinish: (Routine) -> Void

    @Environment(\.dismiss) var dismiss
    @State private var routineExercises: [ExerciseInRoutine] = []
    @State private var showExercisePicker = false
    @State private var newRoutineName: String = ""

    @State private var editingExercise: ExerciseInRoutine?
    @State private var editingIndex: Int?

    let mockExercises = [
        Exercise(name: "Push-Up"),
        Exercise(name: "Squat"),
        Exercise(name: "Deadlift"),
        Exercise(name: "Pull-Up"),
        Exercise(name: "Bench Press")
    ]

    var totalSets: Int {
        routineExercises.reduce(0) { $0 + $1.sets }
    }

    var totalVolume: Int {
        routineExercises.reduce(0) { $0 + ($1.sets * $1.reps * $1.weight) }
    }

    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Create Routine")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button("Finish") {
                    let routine = Routine(
                        name: newRoutineName.isEmpty ? "Untitled Routine" : newRoutineName,
                        workouts: routineExercises.map {
                            Workout(
                                name: $0.exercise.name,
                                sets: $0.sets,
                                reps: $0.reps,
                                weight: $0.weight
                            )
                        }
                    )
                    onFinish(routine)
                    dismiss()
                }
                .disabled(routineExercises.isEmpty)
            }
            .padding()

            // Routine name input
            TextField("Enter Routine Name", text: $newRoutineName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // Metrics
            HStack {
                VStack(alignment: .leading) {
                    Text("Volume")
                    Text("\(totalVolume) lbs")
                        .foregroundColor(.blue)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Sets")
                    Text("\(totalSets)")
                }
            }
            .padding(.horizontal)

            Divider()

            // Exercise List
            List {
                ForEach(Array(routineExercises.enumerated()), id: \.element.id) { index, item in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(item.exercise.name)
                                .font(.headline)
                            Spacer()
                            Button("Edit") {
                                editingExercise = item
                                editingIndex = index
                            }
                            .foregroundColor(.blue)
                        }

                        HStack {
                            Text("Sets: \(item.sets)")
                            Text("Reps: \(item.reps)")
                            Text("Weight: \(item.weight) lbs")
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { indexSet in
                    routineExercises.remove(atOffsets: indexSet)
                }
            }

            // Add Exercise Button
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

            Spacer()
        }
        .sheet(isPresented: $showExercisePicker) {
            ExercisePickerView(exercises: mockExercises) { exercise in
                let newItem = ExerciseInRoutine(exercise: exercise)
                routineExercises.append(newItem)
                showExercisePicker = false
            }
        }
        .sheet(item: $editingExercise) { exercise in
            EditExerciseView(exercise: exercise) { updatedExercise in
                if let index = editingIndex {
                    routineExercises[index] = updatedExercise
                }
                editingExercise = nil
                editingIndex = nil
            }
        }
    }
}

// MARK: - Supporting Models
struct ExerciseInRoutine: Identifiable, Equatable {
    let id = UUID()
    var exercise: Exercise
    var sets: Int = 3
    var reps: Int = 10
    var weight: Int = 50
}

// MARK: - Supporting Models

struct Exercise: Hashable {
    let name: String
}


// MARK: - Picker

struct ExercisePickerView: View {
    let exercises: [Exercise]
    let onSelect: (Exercise) -> Void

    var body: some View {
        NavigationView {
            List(exercises, id: \.self) { exercise in
                Button(exercise.name) {
                    onSelect(exercise)
                }
            }
            .navigationTitle("Choose Exercise")
        }
    }
}

// MARK: - Edit View

struct EditExerciseView: View {
    @Environment(\.dismiss) var dismiss
    @State private var setsText: String
    @State private var repsText: String
    @State private var weightText: String
    var original: ExerciseInRoutine
    var onSave: (ExerciseInRoutine) -> Void

    init(exercise: ExerciseInRoutine, onSave: @escaping (ExerciseInRoutine) -> Void) {
        self.original = exercise
        self._setsText = State(initialValue: String(exercise.sets))
        self._repsText = State(initialValue: String(exercise.reps))
        self._weightText = State(initialValue: String(exercise.weight))
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Exercise")) {
                    Text(original.exercise.name)
                        .font(.headline)
                }

                Section(header: Text("Edit Values")) {
                    VStack(alignment: .leading, spacing: 16) {
                        // Sets
                        Text("Sets")
                        HStack {
                            Button(action: {
                                if let sets = Int(setsText), sets > 1 {
                                    setsText = "\(sets - 1)"
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                            }

                            TextField("Sets", text: $setsText)
                                .keyboardType(.numberPad)
                                .frame(width: 50)
                                .multilineTextAlignment(.center)

                            Button(action: {
                                if let sets = Int(setsText) {
                                    setsText = "\(sets + 1)"
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                            }
                        }

                        // Reps
                        Text("Reps")
                        HStack {
                            Button(action: {
                                if let reps = Int(repsText), reps > 1 {
                                    repsText = "\(reps - 1)"
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                            }

                            TextField("Reps", text: $repsText)
                                .keyboardType(.numberPad)
                                .frame(width: 50)
                                .multilineTextAlignment(.center)

                            Button(action: {
                                if let reps = Int(repsText) {
                                    repsText = "\(reps + 1)"
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                            }
                        }

                        // Weight
                        Text("Weight (lbs)")
                        HStack {
                            Button(action: {
                                if let weight = Int(weightText), weight > 0 {
                                    weightText = "\(weight - 5)"
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                            }

                            TextField("Weight", text: $weightText)
                                .keyboardType(.numberPad)
                                .frame(width: 60)
                                .multilineTextAlignment(.center)

                            Button(action: {
                                if let weight = Int(weightText) {
                                    weightText = "\(weight + 5)"
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Exercise")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updated = ExerciseInRoutine(
                            exercise: original.exercise,
                            sets: Int(setsText) ?? original.sets,
                            reps: Int(repsText) ?? original.reps,
                            weight: Int(weightText) ?? original.weight
                        )
                        onSave(updated)
                        dismiss()
                    }
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


struct LogWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        LogWorkoutView { _ in }
    }
}

