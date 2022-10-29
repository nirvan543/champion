//
//  RoundRobinFormatManager.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct RoundRobinTournamentManager: TournamentManager {
    let tournamentFormatConfig: TournamentFormatConfig
    
    init(tournamentFormatConfig: TournamentFormatConfig) {
        self.tournamentFormatConfig = tournamentFormatConfig
    }
}
