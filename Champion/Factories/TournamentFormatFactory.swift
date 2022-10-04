//
//  AddEditTournamentFormatFactory.swift
//  Champion
//
//  Created by Nirvan Nagar on 8/17/22.
//

import SwiftUI

struct TournamentFormatFactory {
    static func addEditTournamentFormatView(for format: TournamentFormat, formatConfig: Binding<TournamentFormatConfig>) -> some View {
        switch format {
        case .roundRobin:
            let newFormatConfigBinding = Binding<RoundRobinTournamentFormatConfig> {
                if let tournamentFormatConfig = formatConfig.wrappedValue as? RoundRobinTournamentFormatConfig {
                    return tournamentFormatConfig
                } else {
                    fatalError("Expected the 'tournamentFormatConfig' to be of type 'RoundRobinTournamentFormatConfig'. But it is instead of type \(formatConfig.wrappedValue.self)")
                }
            } set: { newValue in
                formatConfig.wrappedValue = newValue
            }

            return AddEditRoundRobinFormatView(tournamentFormatConfig: newFormatConfigBinding)
        }
    }
    
    static func tournamentFormatConfigView(for format: TournamentFormat, formatConfig: TournamentFormatConfig) -> some View {
        switch format {
        case .roundRobin:
            guard let roundRobinFormatConfig = formatConfig as? RoundRobinTournamentFormatConfig else {
                fatalError("Expected the 'tournamentFormatConfig' to be of type 'RoundRobinTournamentFormatConfig'. But it is instead of type \(formatConfig.self)")
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
}
