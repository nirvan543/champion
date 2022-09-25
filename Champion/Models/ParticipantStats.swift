//
//  ParticipantState.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct ParticipantStats: Equatable, Hashable {
    let participant: Participant
    let matchesWon: Int
    let matchesTied: Int
    let matchesLost: Int
    let goalsFor: Int
    let goalsAgainst: Int
    
    var matchesPlayed: Int {
        matchesWon + matchesTied + matchesLost
    }
    
    var goalsDifference: Int {
        goalsFor - goalsAgainst
    }
    
    var points: Int {
        (matchesWon * 3) + (matchesTied * 1) + (matchesLost * 0)
    }
}
