//
//  ChampionApp.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/8/22.
//

import SwiftUI

@main
struct ChampionApp: App {
    @StateObject private var environmentValues = EnvironmentValues(tournaments: MockTournamentRepository.shared.retreiveTournaments())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(environmentValues)
        }
    }
}
