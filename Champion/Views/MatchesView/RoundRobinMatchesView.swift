//
//  MatchesView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct RoundRobinMatchesView: View {
    let rounds: [Round]
    
    var body: some View {
        PageView {
            ForEach(Array(rounds.enumerated()), id: \.element) { index, round in
                PageSection("Round \(index + 1)") {
                    RoundMatchesView(round: round)
                }
            }
        }
        .navigationTitle("Matches")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct RoundMatchesView: View {
    let round: Round
    
    var body: some View {
        VStack {
            ForEach(round.matches) { match in
                MatchCellView(participant1: match.participant1,
                              participant2: match.participant2,
                              participant1Score: match.participant1Score,
                              participant2Score: match.participant2Score,
                              matchState: match.matchState,
                              winner: match.winner,
                              endedInATie: match.endedInATie)
            }
        }
    }
}

struct RoundRobinMatchesView_Previews: PreviewProvider {
    static let rounds = MockData.rounds
    
    static var previews: some View {
        Group {
            NavigationView {
                RoundRobinMatchesView(rounds: rounds)
            }
            NavigationView {
                RoundRobinMatchesView(rounds: rounds)
            }
            .preferredColorScheme(.dark)
        }
    }
}
