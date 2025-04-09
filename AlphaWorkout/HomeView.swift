//
//  HomeView.swift
//  AlphaWorkout
//
//  Created by Brian St-Juste on 2/19/25.
//

import SwiftUI

struct HomeView: View {
    var username: String

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome, \(username)!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            Text("Choose your workout")
                .font(.headline)
                .foregroundColor(.gray)

            VStack(spacing: 15) {
                SportCategoryView(sport: "Strength", icon: "🏋️‍♂️", description: "Build muscle, strength, and power.")
                SportCategoryView(sport: "Recovery", icon: "🧘‍♂️", description: "Relax, stretch, and recover.")
                SportCategoryView(sport: "Conditioning", icon: "🏃‍♂️", description: "Improve endurance, speed, and stamina.")
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 10) {
                Text("Recent Workouts")
                    .font(.headline)
                HStack(spacing: 10) {
                    WorkoutCard(title: "🏋️‍♀️ Full-Body Strength", color: .blue)
                    WorkoutCard(title: "🏃‍♀️ Cardio Conditioning", color: .orange)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.vertical)
        .navigationBarTitle("Home", displayMode: .inline)
    }
}

struct SportCategoryView: View {
    var sport: String
    var icon: String
    var description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(icon)
                    .font(.title)
                Text(sport)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct WorkoutCard: View {
    var title: String
    var color: Color

    var body: some View {
        Text(title)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(color.opacity(0.2))
            .cornerRadius(8)
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(username: "Brian")
    }
}
