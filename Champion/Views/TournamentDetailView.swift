//
//  TournamentDetailView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct TournamentDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var tournament: Tournament
    
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
            HStack {
                Text(tournament.format.rawValue)
                    .font(.title2)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
            }
            .background()
            .overlay(sectionOverlay)
        }
    }
    
    private var sectionOverlay: some View {
        Design.defaultShape.strokeBorder(.quaternary, lineWidth: 1)
    }
    
    private var tournamentDateSection: some View {
        PageSection("Tournament Date") {
            HStack {
                Text(DateUtils.displayString(for: tournament.date))
                    .font(.title2)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
            }
            .background()
            .overlay(sectionOverlay)
        }
    }
    
    private var participantsSection: some View {
        PageSection("Participants") {
            VStack(alignment: .leading) {
                ForEach(tournament.participants) { participant in
                    participantRow(participant: participant)
                }
            }
        }
    }
    
    private func participantRow(participant: Participant) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(participant.playerName)
                    .font(.title3)
                Text(participant.clubSelection.clubName)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background()
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
        NavigationLink {
            if let tournament = tournament as? RoundRobinTournament {
                MatchesView(rounds: tournament.rounds)
            } else {
                fatalError("Unknown tournament type: \(tournament.self)")
            }
        } label: {
            Text("View Matches")
                .font(.title2)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .background()
        .overlay(buttonOverlay)
    }
    
    private var buttonOverlay: some View {
        Design.defaultShape.strokeBorder(Design.themeColor, lineWidth: 5)
    }
    
    private var startTournamentButton: some View {
        NavigationLink {
            tournamentProgressView
        } label: {
            Text(primaryActionText)
                .font(.title2)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .buttonStyle(.plain)
        .background(Design.themeColor)
        .overlay(buttonOverlay)
    }
    
    @ViewBuilder
    private var tournamentProgressView: some View {
        switch tournament.format {
        case .roundRobin:
            TournamentProgressView(tournament: roundRobinTournamentBinding)
        }
    }
    
    private var roundRobinTournamentBinding: Binding<RoundRobinTournament> {
        Binding {
            tournament as! RoundRobinTournament
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

struct HeaderLabelView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.secondary)
    }
}

struct ReadOnlyConfigLineItemView: View {
    let labelText: String
    let value: String
    
    private let shape = Capsule()
    
    var body: some View {
        HStack {
            Text(labelText)
                .font(.title3)
            Spacer()
            Text(value)
                .font(.title3)
                .padding(.horizontal)
                .padding(.vertical, 2)
                .background()
                .clipShape(shape)
                .overlay(shape.strokeBorder(.quaternary, lineWidth: 1))
        }
    }
}

struct TournamentDetailView_Previews: PreviewProvider {
    @StateObject private static var environmentValues = EnvironmentValues(tournaments: MockTournamentRepository.shared.retreiveTournaments())
    @State private static var tournament: Tournament = MockData.atlantaCup3
    
    static var previews: some View {
        Group {
            NavigationView {
                TournamentDetailView(tournament: $tournament)
            }
            NavigationView {
                TournamentDetailView(tournament: $tournament)
            }
            .preferredColorScheme(.dark)
        }
        .environmentObject(environmentValues)
    }
}
