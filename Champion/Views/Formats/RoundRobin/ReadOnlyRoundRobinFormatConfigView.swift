//
//  RoundRobinFormatConfigView.swift
//  Champion
//
//  Created by Nirvan Nagar on 8/21/22.
//

import SwiftUI

struct ReadOnlyRoundRobinFormatConfigView: View {
    let tournamentFormatConfig: RoundRobinTournamentFormatConfig
    
    var body: some View {
        PageSection(headerText: "League Stage Config") {
            VStack(alignment: .leading, spacing: 8) {
                ReadOnlyConfigLineItemView(labelText: "Matches per Opponent",
                                           value: "\(tournamentFormatConfig.matchesPerOpponent)")
                
                ReadOnlyConfigLineItemView(labelText: "Legs per Match",
                                           value: "\(tournamentFormatConfig.legsPerMatch)")
            }
        }
    }
}

struct RoundRobinFormatConfigView_Previews: PreviewProvider {
    private static let tournamentFormatConfig = RoundRobinTournamentFormatConfig()
    
    static var previews: some View {
        ReadOnlyRoundRobinFormatConfigView(tournamentFormatConfig: tournamentFormatConfig)
    }
}
