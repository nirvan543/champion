//
//  ChampionApp.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/8/22.
//

import SwiftUI

@main
struct ChampionApp: App {
    @StateObject private var environmentValues = EnvironmentValues()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    do {
                        environmentValues.tournaments = try await EnvironmentValues.loadTournaments()
                    } catch {
                        // TODO: Handle this error
                        fatalError("Could not load tournaments. Error: \(error)")
                    }
                }
                .environmentObject(environmentValues)
        }
    }
}
