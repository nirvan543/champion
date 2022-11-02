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
                    StandingsView(geo: geo, stats: tournament.tournamentStats)
                    
                    viewTournamentSummaryButton
                }
                
                groupPicker
                
                PageSection("Group \(selectedGroupIndex + 1) Standings") {
                    StandingsView(geo: geo, stats: tournament.standingStats(for: selectedGroupIndex))
                }
                
                RoundsView(roundsBinding: $tournament.groups[selectedGroupIndex].rounds)
                
                if showCompleteTournamentButton {
                    completeTournamentButton
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
    
    private var viewTournamentSummaryButton: some View {
        SecondaryLink {
            TournamentSummaryView(tournament: tournament)
        } label: {
            Text("View Tournament Summary")
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
    
    private var showCompleteTournamentButton: Bool {
        tournament.state != .completed
    }
    
    private var completeTournamentButton: some View {
        PageSection {
            PrimaryButton("Finish Tournament") {
                tournament.state = .completed
            }
            .disabled(!tournament.roundsAreComplete)
        }
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
