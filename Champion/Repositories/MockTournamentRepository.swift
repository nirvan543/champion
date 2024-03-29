//
//  TournamentRepository.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/8/22.
//

import Foundation
import SwiftUI

class MockTournamentRepository: TournamentRepository {
    
    static let shared = MockTournamentRepository(loadMockData: true)
    
    private var tournaments: [any Tournament]
    
    init(loadMockData: Bool = true) {
        tournaments = []
        
        if loadMockData {
            tournaments = loadData()
        }
    }
    
    private func loadData() -> [any Tournament] {
        MockData.tournaments
    }
    
    func retreiveTournaments() -> [any Tournament] {
        tournaments
    }
    
    func addTournament(tournament: any Tournament) {
        tournaments.append(tournament)
    }
    
    func saveTournaments(tournaments: [any Tournament]) {
        self.tournaments = tournaments
    }
    
    func retrieveTournamentFormats() -> [TournamentFormat] {
        [
            .roundRobin,
            .grouped
        ]
    }
    
    func retrieveImageOptions() -> [String] {
        [
            "atletico_madrid_logo",
            "fc_barcelona_logo",
            "fc_bayern_munchen_logo",
            "liverpool_logo",
            "man_city_logo",
            "psg_logo",
            "real_madrid_logo",
            "fifa_logo"
        ]
    }
}
