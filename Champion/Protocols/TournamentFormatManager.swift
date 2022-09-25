//
//  TournamentFormatManager.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

protocol TournamentFormatManager: Codable {
    var tournamentFormatConfig: TournamentFormatConfig { get set }
    
    func generateMatches(participants: [Participant]) -> [Round]
    
    func matchStats(participants: [Participant], rounds: [Round]) -> [ParticipantStats]
}
