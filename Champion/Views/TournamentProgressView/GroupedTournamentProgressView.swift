//
//  GroupedTournamentProgressView.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/26/22.
//

import SwiftUI

struct GroupedTournamentProgressView: View {
    @State private var selectedGroupIndex = 0
    
    @Binding var tournament: GroupedTournament
    
    var body: some View {
        GeometryReader { geo in
            PageView {
                PageSection("Tournament Standings") {
                    StandingsView(geo: geo, stats: tournament.allStandingStats)
                }
                
                groupPicker
                
                PageSection("Group \(selectedGroupIndex + 1) Standings") {
                    StandingsView(geo: geo, stats: tournament.standingStats(for: selectedGroupIndex))
                }
                
                matchesSection
            }
        }
        .navigationTitle(tournament.name)
        .onAppear {
            if tournament.state == .created {
                tournament.state = .inProgress
            }
        }
    }
    
    private var groupPicker: some View {
        HStack {
            Spacer()
            Picker("Group \(selectedGroupIndex + 1)", selection: $selectedGroupIndex) {
                ForEach(Array(tournament.groups.enumerated()), id: \.element.id) { index, group in
                    Text("Group \(index + 1)").tag(index)
                }
            }
            Spacer()
        }
    }

    private var matchesSection: some View {
        ForEach($tournament.groups[selectedGroupIndex].rounds) { round in
            PageSection("Round \(number(for: round.wrappedValue))") {
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
    
    func number(for round: Round) -> Int {
        if let index = selectedGroup.rounds.firstIndex(where: { $0 == round }) {
            return index + 1
        } else {
            fatalError("Expected to find the index for the round \(round) within the Round Robin stage.")
        }
    }
    
    private var selectedGroup: TournamentGroup {
        tournament.groups[selectedGroupIndex]
    }
}

struct GroupedTournamentProgressView_Previews: PreviewProvider {
    @State private static var tournament = MockData.proWorldCup4
    
    static var previews: some View {
        NavigationView {
            GroupedTournamentProgressView(tournament: $tournament)
        }
    }
}
