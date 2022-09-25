//
//  TournamentResults.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct TournamentResults {
    let stats: [ParticipantStats]
    
    var firstPlace: ParticipantStats {
        guard let first = stats.first else {
            fatalError("Expected there to a first place winner in `stats` array: \(stats)")
        }
        
        return first
    }
    
    var secondPlace: ParticipantStats {
        guard let second = stats.prefix(through: 1).last else {
            fatalError("Expected there to a second place winner in `stats` array: \(stats)")
        }
        
        return second
    }
    
    var thirdPlace: ParticipantStats? {
        if stats.count >= 3, let third = stats.prefix(through: 2).last {
            return third
        } else {
            return nil
        }
    }
}
