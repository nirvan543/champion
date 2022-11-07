//
//  ITournamentRepository.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/8/22.
//

import Foundation

protocol TournamentRepository {
    func retreiveTournaments() -> [any Tournament]
    
    func addTournament(tournament: any Tournament)
    
    func saveTournaments(tournaments: [any Tournament])
    
    func retrieveTournamentFormats() -> [TournamentFormat]
    
    func retrieveImageOptions() -> [String]
}
