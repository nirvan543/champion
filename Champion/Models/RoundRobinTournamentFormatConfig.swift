//
//  RoundRobinTournamentFormatConfig.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct RoundRobinTournamentFormatConfig: TournamentFormatConfig {
    var matchesPerOpponent: Int
    var legsPerMatch: Int
    
    init(matchesPerOpponent: Int = 1, legsPerMatch: Int = 1) {
        self.matchesPerOpponent = matchesPerOpponent
        self.legsPerMatch = legsPerMatch
    }
    
    func validate() -> ChampionError? {
        if matchesPerOpponent < 1 {
            return ChampionError(errorMessage: "League stage 'Matches per Opponent' must be at least '1'.")
        }
        
        if legsPerMatch < 1 {
            return ChampionError(errorMessage: "League stage 'Legs per Match' must be at least '1'.")
        }
        
        return nil
    }
}
