//
//  MainAppView.swift
//  AlphaWorkout
//
//  Created by Brian St-Juste on 5/7/25.
//

import SwiftUI

struct MainAppView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WorkoutView()
                .tabItem {
                    Label("Workout", systemImage: "dumbbell.fill")
                }
                .tag(0)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(1)
        }
        .accentColor(.blue)
    }
}

struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
    }
}
