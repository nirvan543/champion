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
                standingsSection(geo: geo)
                RoundsView(roundsBinding: $tournament.rounds)
                
                if showCompleteTournamentButton {
                    completeTournamentButton
                }
                
                links
            }
        }
        .navigationTitle(tournament.name)
        .onAppear {
            if tournament.state == .created {
                tournament.state = .inProgress
            }
        }
    }
    
    private func standingsSection(geo: GeometryProxy) -> some View {
        PageSection("Standings") {
            StandingsView(geo: geo, stats: tournament.standingStats)
            
            if tournament.state == .completed {
                viewTournamentResultsButton
            }
        }
    }
    
    private var viewTournamentResultsButton: some View {
        SecondaryLink {
            TournamentResultsView(results: TournamentResults(stats: tournament.standingStats),
                                  revistingResults: true)
        } label: {
            Text("View Results")
        }
    }
    
    private var showCompleteTournamentButton: Bool {
        tournament.state != .completed && tournament.roundsAreComplete
    }
    
    private var completeTournamentButton: some View {
        PageSection {
            PrimaryButton("Finish Tournament") {
                tournament.state = .completed
                navigateToTournamentResultsView = true
            }
        }
    }
    
    private var links: some View {
        VStack {
            NavigationLink(isActive: $navigateToTournamentResultsView) {
                TournamentResultsView(results: TournamentResults(stats: tournament.standingStats),
                                      revistingResults: false)
            } label: {
                EmptyView()
            }
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
