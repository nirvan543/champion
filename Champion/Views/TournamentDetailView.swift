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
        ScrollView {
            VStack(alignment: .leading, spacing: 42) {
                tournamentTypeSection
                tournamentDateSection
                participantsSection
                leagueStageConfigSection
                knockoutStageConfigSection
                finalActionSection
            }
        }
        .background(DesignValues.pageColor.ignoresSafeArea())
        .navigationTitle(tournament.name)
    }
    
    private var tournamentTypeSection: some View {
        PageSection(headerText: "Tournament Format") {
            HStack {
                Text(tournament.type.rawValue)
                    .font(.title2)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
            }
            .background()
            .overlay(Rectangle().strokeBorder(.quaternary, lineWidth: 1))
        }
    }
    
    private var tournamentDateSection: some View {
        PageSection(headerText: "Tournament Date") {
            HStack {
                Text(DateUtils.displayString(for: tournament.date))
                    .font(.title2)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
            }
            .background()
            .overlay(Rectangle().strokeBorder(.quaternary, lineWidth: 1))
        }
    }
    
    private var participantsSectionOld: some View {
        PageSection(headerText: "Participants") {
            VStack(alignment: .leading) {
                ForEach(tournament.participants) { participant in
                    HStack(spacing: 14) {
                        Image(participant.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .padding(.vertical, 7)
                        
                        Text(participant.playerName)
                            .font(.title3)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background()
                    .overlay(Rectangle().strokeBorder(.quaternary, lineWidth: 1))
                }
            }
        }
    }
    
    private var participantsSection: some View {
        PageSection(headerText: "Participants") {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 150))
            ]) {
                ForEach(tournament.participants) { participant in
                    VStack {
                        Image(participant.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75, height: 75)
                            .padding(.vertical, 7)
                        
                        Text(participant.playerName)
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background()
                    .overlay(Rectangle().strokeBorder(.quaternary, lineWidth: 1))
                }
            }
        }
    }
    
    private var leagueStageConfigSection: some View {
        PageSection(headerText: "League Stage Config") {
            VStack(alignment: .leading, spacing: 8) {
                ReadOnlyConfigLineItemView(labelText: "Matches per Opponent",
                                           value: "\(tournament.roundRobinStage.matchesPerOpponent)")
                
                ReadOnlyConfigLineItemView(labelText: "Legs per Match",
                                           value: "\(tournament.roundRobinStage.legsPerMatch)")
            }
        }
    }
    
    private var knockoutStageConfigSection: some View {
        PageSection(headerText: "Knockout Stage Config") {
            VStack(alignment: .leading, spacing: 8) {
                ReadOnlyConfigLineItemView(labelText: "Playoff Spots",
                                           value: "\(tournament.knockoutStage.playoffSpots)")
                
                ReadOnlyConfigLineItemView(labelText: "Legs per Match",
                                           value: "\(tournament.knockoutStage.legsPerMatch)")
            }
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
        NavigationLink {
            MatchesView(roundRobinStage: tournament.roundRobinStage)
        } label: {
            Text("View Matches")
                .font(.title2)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .background()
        .overlay(Rectangle().strokeBorder(DesignValues.themeColor, lineWidth: 5))
    }
    
    private var startTournamentButton: some View {
        NavigationLink {
            TournamentProgressView(tournament: $tournament)
        } label: {
            Text(primaryActionText)
                .font(.title2)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .buttonStyle(.plain)
        .background(DesignValues.themeColor)
        .overlay(Rectangle().strokeBorder(DesignValues.themeColor, lineWidth: 5))
    }
    
    private var primaryActionText: String {
        switch tournament.state {
        case .created:
            return "Start Tournament"
        case .roundRobin:
            return "Continue Tournament"
        case .knockout:
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
    @State private static var tournament = MockData.atlantaCup3
    
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
