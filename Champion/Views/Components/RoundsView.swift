//
//  RoundsView.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/30/22.
//

import SwiftUI

struct RoundsView: View {
    var roundsBinding: Binding<[Round]>?
    let rounds: [Round]?
    
    init(roundsBinding: Binding<[Round]>) {
        self.roundsBinding = roundsBinding
        rounds = nil
    }
    
    init(rounds: [Round]) {
        self.rounds = rounds
        roundsBinding = nil
    }
    
    var body: some View {
        if let roundsBinding {
            roundsView(with: roundsBinding)
        } else if let rounds {
            roundsView(from: rounds)
        } else {
            fatalError("roundsBinding and rounds are both nil")
        }
    }
    
    private func roundsView(with roundsBinding: Binding<[Round]>) -> some View {
        ForEach(Array(roundsBinding.enumerated()), id: \.element.wrappedValue.id) { index, round in
            PageSection("Round \(index + 1)") {
                RoundMatchesView(roundBinding: round)
            }
        }
    }
    
    private func roundsView(from rounds: [Round]) -> some View {
        ForEach(Array(rounds.enumerated()), id: \.element) { index, round in
            PageSection("Round \(index + 1)") {
                RoundMatchesView(round: round)
            }
        }
    }
}

private struct RoundMatchesView: View {
    let roundBinding: Binding<Round>?
    let round: Round?
    
    init(roundBinding: Binding<Round>) {
        self.roundBinding = roundBinding
        round = nil
    }
    
    init(round: Round) {
        self.round = round
        roundBinding = nil
    }
    
    var body: some View {
        VStack {
            if let roundBinding {
                roundMatches(with: roundBinding)
            } else if let round {
                roundMatches(from: round)
            } else {
                fatalError("round and roundBinding both are nil")
            }
        }
    }
    
    private func roundMatches(with roundBinding: Binding<Round>) -> some View {
        ForEach(roundBinding.matches) { match in
            NavigationLink {
                MatchProgressView(match: match)
            } label: {
                MatchCellView(participant1: match.wrappedValue.participant1,
                              participant2: match.wrappedValue.participant2,
                              participant1Score: match.wrappedValue.participant1Score,
                              participant2Score: match.wrappedValue.participant2Score,
                              matchState: match.wrappedValue.matchState,
                              winner: match.wrappedValue.winner,
                              endedInATie: match.wrappedValue.endedInATie)
            }
            .buttonStyle(.plain)
        }
    }
    
    private func roundMatches(from round: Round) -> some View {
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


struct RoundsView_Previews: PreviewProvider {
    @State private static var rounds = MockData.rounds
    
    static var previews: some View {
        Group {
            NavigationView {
                PageView {
                    RoundsView(roundsBinding: $rounds)
                }
            }
            NavigationView {
                PageView {
                    RoundsView(rounds: MockData.rounds)
                }
            }
        }
    }
}
