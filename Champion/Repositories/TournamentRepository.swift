//
//  ITournamentRepository.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/8/22.
//

import Foundation

protocol TournamentRepository {
    func retreiveTournaments() -> [RoundRobinTournament]
    
    func addTournament(tournament: RoundRobinTournament)
    
    func saveTournaments(tournaments: [RoundRobinTournament])
    
    func retrieveTournamentFormats() -> [TournamentFormat]
    
    func retrieveImageOptions() -> [String]
}
