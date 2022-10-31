//
//  RoundsView.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/30/22.
//

import SwiftUI

struct RoundsView: View {
    var roundsBinding: Binding<[Round]>?
    
    var body: some View {
        if let roundsBinding {
            roundsFrom(binding: roundsBinding)
        } else {
            EmptyView()
        }
    }
    
    private func roundsFrom(binding rounds: Binding<[Round]>) -> some View {
        ForEach(Array(rounds.enumerated()), id: \.element.wrappedValue.id) { index, round in
            PageSection("Round \(index + 1)") {
                VStack {
                    ForEach(round.matches) { match in
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
            }
        }
    }
}

struct RoundsView_Previews: PreviewProvider {
    @State private static var rounds = MockData.rounds
    
    static var previews: some View {
        NavigationView {
            PageView {
                RoundsView(roundsBinding: $rounds)
            }
        }
    }
}
