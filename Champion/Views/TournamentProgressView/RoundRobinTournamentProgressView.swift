//
//  TournamentInProgressView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/16/22.
//

import SwiftUI

struct RoundRobinTournamentProgressView: View {
    @State private var navigateToTournamentResultsView = false
    
    @Binding var tournament: RoundRobinTournament
    
    var body: some View {
        GeometryReader { geo in
            PageView {
                PageSection("Standings") {
                    StandingsView(geo: geo, stats: tournament.standingStats)
                    
                    if tournament.state == .completed {
                        viewTournamentResultsButton
                    }
                }
                matchesSection
                if showCompleteTournamentButton {
                    completeTournamentButton
                }
                NavigationLink(isActive: $navigateToTournamentResultsView) {
                    TournamentResultsView(results: TournamentResults(stats: tournament.standingStats),
                                          revistingResults: false)
                } label: {
                    EmptyView()
                }
            }
        }
        .navigationTitle(tournament.name)
        .onAppear {
            if tournament.state == .created {
                tournament.state = .inProgress
            }
        }
    }
    
    private var showCompleteTournamentButton: Bool {
        tournament.state != .completed && tournament.roundsAreComplete
    }
    
    private var viewTournamentResultsButton: some View {
        NavigationLink {
            TournamentResultsView(results: TournamentResults(stats: tournament.standingStats),
                                  revistingResults: true)
        } label: {
            Text("View Results")
                .font(.title2)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .background()
        .overlay(Rectangle().strokeBorder(Design.themeColor, lineWidth: 5))
    }
    
    private var completeTournamentButton: some View {
        PageSection {
            Button {
                tournament.state = .completed
                navigateToTournamentResultsView = true
            } label: {
                Text("Finish Tournament")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
            }
            .buttonStyle(.plain)
            .background(Design.themeColor)
            .overlay(Rectangle().strokeBorder(Design.themeColor, lineWidth: 5))
        }
    }
    
    private var matchesSection: some View {
        ForEach($tournament.rounds) { round in
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
        if let index = tournament.rounds.firstIndex(where: { $0 == round }) {
            return index + 1
        } else {
            fatalError("Expected to find the index for the round \(round) within the Round Robin stage.")
        }
    }
}

struct RoundRobinTournamentProgressView_Previews: PreviewProvider {
    @State private static var tournament = MockData.atlantaCup3
    
    static var previews: some View {
        Group {
            NavigationView {
                RoundRobinTournamentProgressView(tournament: $tournament)
            }
            NavigationView {
                RoundRobinTournamentProgressView(tournament: $tournament)
            }
            .preferredColorScheme(.dark)
        }
    }
}
