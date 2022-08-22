//
//  AddEditRoundRobinFormatView.swift
//  Champion
//
//  Created by Nirvan Nagar on 8/17/22.
//

import SwiftUI

struct AddEditRoundRobinFormatView: View {
    @Binding var tournamentFormatConfig: RoundRobinTournamentFormatConfig
    
    var body: some View {
        PageSection(headerText: "League Stage Config") {
            VStack(alignment: .leading, spacing: 8) {
                EditableConfigLineItemView(labelText: "Matches per Opponent",
                                           value: $tournamentFormatConfig.matchesPerOpponent)
                
                EditableConfigLineItemView(labelText: "Legs per Match",
                                           value: $tournamentFormatConfig.legsPerMatch)
            }
        }
    }
}

struct AddEditRoundRobinFormatView_Previews: PreviewProvider {
    @State private static var tournamentFormatConfig = RoundRobinTournamentFormatConfig(matchesPerOpponent: 1, legsPerMatch: 1)
    
    static var previews: some View {
        AddEditRoundRobinFormatView(tournamentFormatConfig: $tournamentFormatConfig)
    }
}