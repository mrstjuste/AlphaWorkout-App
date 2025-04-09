//
//  CreateworkoutView.swift
//  AlphaWorkout
//
//  Created by Brian St-Juste on 4/9/25.
//

import SwiftUI

struct CreateworkoutView: View {
    @State private var showCategories = false
    @State private var selectedCategory: String? = nil
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                selectedCategory = nil
                showCategories.toggle()
            }) {
                Text("+ Add Workout")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle("Create Workout")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .sheet(isPresented: $showCategories) {
            WorkoutCategoriesView(selectedCategory: $selectedCategory)
        }
    }
}

struct WorkoutCategoriesView: View {
    @Binding var selectedCategory: String?
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 60, height: 5)
                .cornerRadius(2.5)
                .padding(.top, 10)
            
            if selectedCategory == nil {
                Text("Select Workout Category")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Button(action: { selectedCategory = "Strength" }) {
                    Text("Strength (Weightlifting)")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                
                Button(action: { selectedCategory = "Recovery" }) {
                    Text("Recovery")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                
                Button(action: { selectedCategory = "Conditioning" }) {
                    Text("Conditioning (Cardio)")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            } else if selectedCategory == "Strength" {
                StrengthPageView(selectedCategory: $selectedCategory)
            } else if selectedCategory == "Recovery" {
                RecoveryPageView(selectedCategory: $selectedCategory)
            } else if selectedCategory == "Conditioning" {
                ConditioningPageView(selectedCategory: $selectedCategory)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct StrengthPageView: View {
    @Binding var selectedCategory: String?
    @State private var selectedWorkouts = Set<String>()
    @State private var searchText = ""
    @State private var scrollTarget: String?
    
    private let workoutSections = [
        ("Chest Workouts", ["Bench Press", "Incline Dumbbell Press", "Chest Flys"]),
        ("Back Workouts", ["Deadlift", "Pull-Ups", "Barbell Rows"])
    ]
    
    var filteredSections: [(String, [String])] {
        if searchText.isEmpty {
            return workoutSections
        } else {
            return workoutSections.map { section in
                let filteredWorkouts = section.1.filter { workout in
                    workout.localizedCaseInsensitiveContains(searchText)
                }
                return (section.0, filteredWorkouts)
            }.filter { !$0.1.isEmpty }
        }
    }
    
    var body: some View {
        VStack {
            BackButton(selectedCategory: $selectedCategory)
            
            Text("Strength Workouts")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Search Bar
            TextField("Search strength workouts...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onChange(of: searchText) { newValue in
                    if !newValue.isEmpty {
                        // Find the first matching workout and set it as scroll target
                        for section in workoutSections {
                            if let match = section.1.first(where: { $0.localizedCaseInsensitiveContains(newValue) }) {
                                scrollTarget = match
                                break
                            }
                        }
                    }
                }
            
            ScrollViewReader { proxy in
                List {
                    ForEach(filteredSections, id: \.0) { section in
                        Section(header: Text(section.0)) {
                            ForEach(section.1, id: \.self) { workout in
                                workoutButton(workout, selectedWorkouts: $selectedWorkouts)
                                    .id(workout)
                            }
                        }
                    }
                }
                .onChange(of: scrollTarget) { target in
                    if let target = target {
                        withAnimation {
                            proxy.scrollTo(target, anchor: .top)
                        }
                    }
                }
            }
            
            addButton(count: selectedWorkouts.count)
        }
        .padding()
    }
    
    private func workoutButton(_ title: String, selectedWorkouts: Binding<Set<String>>) -> some View {
        Button(action: {
            if selectedWorkouts.wrappedValue.contains(title) {
                selectedWorkouts.wrappedValue.remove(title)
            } else {
                selectedWorkouts.wrappedValue.insert(title)
            }
        }) {
            HStack {
                Text(title)
                Spacer()
                if selectedWorkouts.wrappedValue.contains(title) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
    }
    
    private func addButton(count: Int) -> some View {
        Button(action: {
            // Action for adding the selected workouts
        }) {
            Text("Add \(count) Workout\(count == 1 ? "" : "s")")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .disabled(count == 0)
    }
}

struct RecoveryPageView: View {
    @Binding var selectedCategory: String?
    @State private var selectedWorkouts = Set<String>()
    @State private var searchText = ""
    @State private var scrollTarget: String?
    
    private let workoutSections = [
        ("Stretching", ["Hamstring Stretch", "Hip Flexor Stretch", "Quad Stretch"]),
        ("Foam Rolling", ["Lower Back Roll", "Upper Back Roll", "Thigh Roll"])
    ]
    
    var filteredSections: [(String, [String])] {
        if searchText.isEmpty {
            return workoutSections
        } else {
            return workoutSections.map { section in
                let filteredWorkouts = section.1.filter { workout in
                    workout.localizedCaseInsensitiveContains(searchText)
                }
                return (section.0, filteredWorkouts)
            }.filter { !$0.1.isEmpty }
        }
    }
    
    var body: some View {
        VStack {
            BackButton(selectedCategory: $selectedCategory)
            
            Text("Recovery Workouts")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Search Bar
            TextField("Search recovery workouts...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onChange(of: searchText) { newValue in
                    if !newValue.isEmpty {
                        for section in workoutSections {
                            if let match = section.1.first(where: { $0.localizedCaseInsensitiveContains(newValue) }) {
                                scrollTarget = match
                                break
                            }
                        }
                    }
                }
            
            ScrollViewReader { proxy in
                List {
                    ForEach(filteredSections, id: \.0) { section in
                        Section(header: Text(section.0)) {
                            ForEach(section.1, id: \.self) { workout in
                                workoutButton(workout, selectedWorkouts: $selectedWorkouts)
                                    .id(workout)
                            }
                        }
                    }
                }
                .onChange(of: scrollTarget) { target in
                    if let target = target {
                        withAnimation {
                            proxy.scrollTo(target, anchor: .top)
                        }
                    }
                }
            }
            
            addButton(count: selectedWorkouts.count)
        }
        .padding()
    }
    
    private func workoutButton(_ title: String, selectedWorkouts: Binding<Set<String>>) -> some View {
        Button(action: {
            if selectedWorkouts.wrappedValue.contains(title) {
                selectedWorkouts.wrappedValue.remove(title)
            } else {
                selectedWorkouts.wrappedValue.insert(title)
            }
        }) {
            HStack {
                Text(title)
                Spacer()
                if selectedWorkouts.wrappedValue.contains(title) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
    }
    
    private func addButton(count: Int) -> some View {
        Button(action: {
            // Action for adding the selected workouts
        }) {
            Text("Add \(count) Workout\(count == 1 ? "" : "s")")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .disabled(count == 0)
    }
}

struct ConditioningPageView: View {
    @Binding var selectedCategory: String?
    @State private var selectedWorkouts = Set<String>()
    @State private var searchText = ""
    @State private var scrollTarget: String?
    
    private let workoutSections = [
        ("Running", ["5K Run", "Sprints", "Interval Running"]),
        ("Cycling", ["10-mile Ride", "Interval Cycling", "Hill Sprints"])
    ]
    
    var filteredSections: [(String, [String])] {
        if searchText.isEmpty {
            return workoutSections
        } else {
            return workoutSections.map { section in
                let filteredWorkouts = section.1.filter { workout in
                    workout.localizedCaseInsensitiveContains(searchText)
                }
                return (section.0, filteredWorkouts)
            }.filter { !$0.1.isEmpty }
        }
    }
    
    var body: some View {
        VStack {
            BackButton(selectedCategory: $selectedCategory)
            
            Text("Conditioning Workouts")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Search Bar
            TextField("Search conditioning workouts...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onChange(of: searchText) { newValue in
                    if !newValue.isEmpty {
                        for section in workoutSections {
                            if let match = section.1.first(where: { $0.localizedCaseInsensitiveContains(newValue) }) {
                                scrollTarget = match
                                break
                            }
                        }
                    }
                }
            
            ScrollViewReader { proxy in
                List {
                    ForEach(filteredSections, id: \.0) { section in
                        Section(header: Text(section.0)) {
                            ForEach(section.1, id: \.self) { workout in
                                workoutButton(workout, selectedWorkouts: $selectedWorkouts)
                                    .id(workout)
                            }
                        }
                    }
                }
                .onChange(of: scrollTarget) { target in
                    if let target = target {
                        withAnimation {
                            proxy.scrollTo(target, anchor: .top)
                        }
                    }
                }
            }
            
            addButton(count: selectedWorkouts.count)
        }
        .padding()
    }
    
    private func workoutButton(_ title: String, selectedWorkouts: Binding<Set<String>>) -> some View {
        Button(action: {
            if selectedWorkouts.wrappedValue.contains(title) {
                selectedWorkouts.wrappedValue.remove(title)
            } else {
                selectedWorkouts.wrappedValue.insert(title)
            }
        }) {
            HStack {
                Text(title)
                Spacer()
                if selectedWorkouts.wrappedValue.contains(title) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
    }
    
    private func addButton(count: Int) -> some View {
        Button(action: {
            // Action for adding the selected workouts
        }) {
            Text("Add \(count) Workout\(count == 1 ? "" : "s")")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .disabled(count == 0)
    }
}

struct BackButton: View {
    @Binding var selectedCategory: String?
    
    var body: some View {
        Button(action: {
            selectedCategory = nil
        }) {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back")
            }
            .font(.title2)
            .padding()
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct CreateworkoutView_Previews: PreviewProvider {
    static var previews: some View {
        CreateworkoutView()
    }
}
