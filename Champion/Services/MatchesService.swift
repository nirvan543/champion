//
//  MatchesService.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/12/22.
//

import Foundation

struct MatchesService {
    static let shared = MatchesService()
    
    func createMatches(participants: [Participant], matchesPerOpponent: Int, legsPerMatch: Int) -> [Round] {
        if participants.count % 2 == 0 {
            return evenNumberParticipants(participants: participants, legsPerMatch: legsPerMatch)
        } else {
            return oddNumberParticipants(participants: participants)
        }
    }
    
    private func evenNumberParticipants(participants: [Participant], legsPerMatch: Int) -> [Round] {
        fatalError("Even number flow not supported")
    }
    
    private func oddNumberParticipants(participants: [Participant]) -> [Round] {
        fatalError("Odd number flow not supported")
    }
}
