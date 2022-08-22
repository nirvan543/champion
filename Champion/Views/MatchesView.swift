//
//  MatchesView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct MatchesView: View {
    let rounds: [Round]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 42) {
                ForEach(Array(rounds.enumerated()), id: \.element) { index, round in
                    PageSection(headerText: "Round \(index + 1)") {
                        VStack {
                            ForEach(round.matches) { match in
                                MatchCellView(participant1: match.participant1,
                                              participant2: match.participant2,
                                              matchState: match.matchState,
                                              winner: match.winner,
                                              endedInATie: match.endedInATie)
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
    static let rounds = MockData.rounds
    
    static var previews: some View {
        Group {
            NavigationView {
                MatchesView(rounds: rounds)
            }
            NavigationView {
                MatchesView(rounds: rounds)
            }
            .preferredColorScheme(.dark)
        }
    }
}
