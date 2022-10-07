//
//  RoundRobinTournamentFormatConfig.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct RoundRobinTournamentFormatConfig: TournamentFormatConfig {
    var legsPerMatch: Int
    
    init(legsPerMatch: Int = 1) {
        self.legsPerMatch = legsPerMatch
    }
    
    func validate() -> ChampionError? {
        if legsPerMatch < 1 {
            return ChampionError(errorMessage: "League stage 'Legs per Match' must be at least '1'.")
        }
        
        return nil
    }
}
