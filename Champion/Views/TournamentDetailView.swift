//
//  TournamentDetailView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct TournamentDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var tournament: any Tournament
    
    var body: some View {
        PageView {
            tournamentTypeSection
            tournamentDateSection
            participantsSection
            finalActionSection
        }
        .navigationTitle(tournament.name)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if tournament.state != .completed {
                    NavigationLink {
                        AddEditTournamentView(editingTournament: $tournament)
                    } label: {
                        Text("Edit")
                    }
                }
            }
        }
    }
    
    private var tournamentTypeSection: some View {
        PageSection("Tournament Format") {
            FormContent {
                Text(tournament.format.rawValue)
                    .font(.title2)
            }
        }
    }
    
    private var sectionOverlay: some View {
        Design.defaultShape.strokeBorder(.quaternary, lineWidth: 1)
    }
    
    private var tournamentDateSection: some View {
        PageSection("Tournament Date") {
            FormContent {
                Text(DateUtils.displayString(for: tournament.date))
                    .font(.title2)
            }
        }
    }
    
    private var participantsSection: some View {
        PageSection("Participants") {
            ParticipantsListView(participants: tournament.participants)
        }
    }
    
    private var finalActionSection: some View {
        PageSection {
            VStack(spacing: 14) {
                viewMatchesButton
                startTournamentButton
            }
        }
    }
    
    private var viewMatchesButton: some View {
        SecondaryLink {
            switch tournament.format {
            case .roundRobin:
                RoundRobinMatchesView(rounds: (tournament as! RoundRobinTournament).rounds)
            case .grouped:
                GroupedMatchesView(groups: (tournament as! GroupedTournament).groups)
            }
        } label: {
            Text("View Matches")
        }
    }
    
    private var startTournamentButton: some View {
        PrimaryLink {
            tournamentProgressView
        } label: {
            Text(primaryActionText)
        }
    }
    
    @ViewBuilder
    private var tournamentProgressView: some View {
        switch tournament.format {
        case .roundRobin:
            RoundRobinTournamentProgressView(tournament: roundRobinTournamentBinding)
        case .grouped:
            GroupedTournamentProgressView(tournament: groupedTournamentBinding)
        }
    }
    
    private var roundRobinTournamentBinding: Binding<RoundRobinTournament> {
        Binding {
            tournament as! RoundRobinTournament
        } set: { newValue in
            self.tournament = newValue
        }
    }
    
    private var groupedTournamentBinding: Binding<GroupedTournament> {
        Binding {
            tournament as! GroupedTournament
        } set: { newValue in
            self.tournament = newValue
        }
    }
    
    private var primaryActionText: String {
        switch tournament.state {
        case .created:
            return "Start Tournament"
        case .inProgress:
            return "Continue Tournament"
        case .completed:
            return "View Results"
        }
    }
}

struct TournamentDetailView_Previews: PreviewProvider {
    @StateObject private static var environmentValues = EnvironmentValues(tournaments: MockTournamentRepository.shared.retreiveTournaments())
    @State private static var tournament: any Tournament = MockData.atlantaCup3
    
    static var previews: some View {
        Group {
            NavigationView {
                TournamentDetailView(tournament: $tournament)
            }
        }
        .environmentObject(environmentValues)
    }
}
