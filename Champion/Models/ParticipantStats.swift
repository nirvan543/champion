//
//  ParticipantState.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct ParticipantStats: Equatable, Hashable {
    private let halfMarker = 45
    
    let participant: Participant
    let matchesWon: Int
    let matchesTied: Int
    let matchesLost: Int
    let goals: [Goal]
    
    var matchesPlayed: Int {
        matchesWon + matchesTied + matchesLost
    }
    
    var goalsFor: Int {
        goals.filter({ $0.scorer == participant }).count
    }
    
    var goalsAgainst: Int {
        goals.filter({ $0.against == participant }).count
    }
    
    var goalsDifference: Int {
        goalsFor - goalsAgainst
    }
    
    /*
    var goalsForFirstHalf: Int {
        goals.filter({ $0.scorer == participant && $0.minute <= halfMarker }).count
    }
    
    var goalsForSecondHalf: Int {
        goals.filter({ $0.scorer == participant && $0.minute > halfMarker }).count
    }
    
    var goalsAgainstFirstHalf: Int {
        goals.filter({ $0.against == participant && $0.minute <= halfMarker }).count
    }
    
    var goalsAgainstSecondHalf: Int {
        goals.filter({ $0.against == participant && $0.minute > halfMarker }).count
    }
    */
    
    var points: Int {
        (matchesWon * 3) + (matchesTied * 1) + (matchesLost * 0)
    }
}
