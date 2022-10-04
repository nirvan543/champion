//
//  TournamentManagerFactory.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/3/22.
//

import Foundation

struct TournamentManagerFactory {
    static func tournamentManager(for format: TournamentFormat, with formatConfig: TournamentFormatConfig) -> TournamentManager {
        switch format {
        case .roundRobin:
            return RoundRobinTournamentManager(tournamentFormatConfig: formatConfig)
        }
    }
}
