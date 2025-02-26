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
                .padding()

            Text("This is your home dashboard.")
                .font(.headline)
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
        .navigationBarTitle("Home", displayMode: .inline)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(username: "Brian") // Example preview
    }
}
