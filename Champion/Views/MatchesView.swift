//
//  MatchesView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct MatchesView: View {
    let roundRobinStage: RoundRobinStage
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 42) {
                ForEach(Array(roundRobinStage.rounds.enumerated()), id: \.element) { index, round in
                    PageSection(headerText: "Round \(index + 1)") {
                        VStack {
                            ForEach(round.fixtures) { fixture in
                                MatchCellView(player1Name: fixture.participant1.playerName,
                                              player2Name: fixture.participant2.playerName)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(DesignValues.pageColor.ignoresSafeArea())
        .navigationTitle("Matches")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MatchesView_Previews: PreviewProvider {
    static let roundRobinStage = TestData.roundRobinStage
    
    static var previews: some View {
        Group {
            NavigationView {
                MatchesView(roundRobinStage: roundRobinStage)
            }
            NavigationView {
                MatchesView(roundRobinStage: roundRobinStage)
            }
            .preferredColorScheme(.dark)
        }
    }
}
