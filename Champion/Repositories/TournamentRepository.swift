//
//  ITournamentRepository.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/8/22.
//

import Foundation

protocol TournamentRepository {
    func retreiveTournaments() -> [Tournament]
    
    func addTournament(tournament: Tournament)
    
    func saveTournaments(tournaments: [Tournament])
}
