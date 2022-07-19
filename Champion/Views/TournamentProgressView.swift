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
            PageSection(headerText: "Round \(indexForRound(round: round.wrappedValue) + 1)") {
                VStack {
                    ForEach(round.fixtures) { fixture in
                        NavigationLink {
                            MatchProgressView(match: fixture)
                        } label: {
                            MatchCellView(match: fixture.wrappedValue)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    func indexForRound(round: Round) -> Int {
        tournament.roundRobinStage.rounds.firstIndex(where: { $0 == round })!
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
