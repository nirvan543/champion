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
                
                if tournament.state != .completed {
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
            StandingsView(geo: geo, stats: tournament.tournamentStats)
            
            VStack {
                if tournament.state == .completed {
                    viewTournamentResultsButton
                }
                viewTournamentSummaryButton
            }
        }
    }
    
    private var viewTournamentResultsButton: some View {
        SecondaryLink {
            TournamentResultsView(results: TournamentResults(stats: tournament.tournamentStats),
                                  revistingResults: true)
        } label: {
            Text("View Tournament Results")
        }
    }
    
    private var viewTournamentSummaryButton: some View {
        SecondaryLink {
            TournamentSummaryView(tournament: tournament)
        } label: {
            Text("View Tournament Summary")
        }
    }
    
    private var completeTournamentButton: some View {
        PageSection {
            PrimaryButton("Finish Tournament") {
                tournament.state = .completed
                navigateToTournamentResultsView = true
            }
            .disabled(!tournament.roundsAreComplete)
        }
    }
    
    private var links: some View {
        VStack {
            NavigationLink(isActive: $navigateToTournamentResultsView) {
                TournamentResultsView(results: TournamentResults(stats: tournament.tournamentStats),
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
