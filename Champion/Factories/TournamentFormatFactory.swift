//
//  AddEditTournamentFormatFactory.swift
//  Champion
//
//  Created by Nirvan Nagar on 8/17/22.
//

import SwiftUI

struct TournamentFormatFactory {
    static func addEditTournamentFormatView(for format: TournamentFormat, tournamentFormatConfig: Binding<TournamentFormatConfig>) -> some View {
        switch format {
        case .roundRobin:
            let newFormatConfigBinding = Binding<RoundRobinTournamentFormatConfig> {
                if let tournamentFormatConfig = tournamentFormatConfig.wrappedValue as? RoundRobinTournamentFormatConfig {
                    return tournamentFormatConfig
                } else {
                    fatalError("Expected the 'tournamentFormatConfig' to be of type 'RoundRobinTournamentFormatConfig'. But it is instead of type \(tournamentFormatConfig.wrappedValue.self)")
                }
            } set: { newValue in
                tournamentFormatConfig.wrappedValue = newValue
            }

            return AddEditRoundRobinFormatView(tournamentFormatConfig: newFormatConfigBinding)
        }
    }
    
    static func tournamentFormatConfigView(for format: TournamentFormat, tournamentFormatConfig: TournamentFormatConfig) -> some View {
        switch format {
        case .roundRobin:
            guard let roundRobinFormatConfig = tournamentFormatConfig as? RoundRobinTournamentFormatConfig else {
                fatalError("Expected the 'tournamentFormatConfig' to be of type 'RoundRobinTournamentFormatConfig'. But it is instead of type \(tournamentFormatConfig.self)")
            }
            
            return ReadOnlyRoundRobinFormatConfigView(tournamentFormatConfig: roundRobinFormatConfig)
        }
    }
    
    static func tournamentFormatConfig(for format: TournamentFormat) -> TournamentFormatConfig {
        switch format {
        case .roundRobin:
            return RoundRobinTournamentFormatConfig()
        }
    }
    
    static func tournamentFormatManager(for format: TournamentFormat) -> TournamentManager {
        switch format {
        case .roundRobin:
            return RoundRobinTournamentManager(tournamentFormatConfig: RoundRobinTournamentFormatConfig())
        }
    }
}
