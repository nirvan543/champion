//
//  TournamentInProgressView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/16/22.
//

import SwiftUI

struct TournamentProgressView: View {
    @Binding var tournament: Tournament
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 42) {
                matchesSection
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity)
        .background(DesignValues.pageColor.ignoresSafeArea())
        .navigationTitle(tournament.name)
        .onAppear {
            if tournament.state == .created {
                tournament.state = .roundRobin
            }
        }
    }
    
    private var matchesSection: some View {
        ForEach($tournament.roundRobinStage.rounds) { round in
            PageSection(headerText: "Round \(number(for: round.wrappedValue))") {
                VStack {
                    ForEach(round.matches) { match in
                        NavigationLink {
                            MatchProgressView(match: match)
                        } label: {
                            MatchCellView(participant1: match.wrappedValue.participant1,
                                          participant2: match.wrappedValue.participant2,
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
    
    func number(for round: Round) -> Int {
        if let index = tournament.roundRobinStage.rounds.firstIndex(where: { $0 == round }) {
            return index + 1
        } else {
            fatalError("Expected to find the index for the round \(round) within the Round Robin stage.")
        }
    }
}

struct TournamentProgressView_Previews: PreviewProvider {
    @State private static var tournament = MockData.atlantaCup3
    
    static var previews: some View {
        NavigationView {
            TournamentProgressView(tournament: $tournament)
        }
    }
}
