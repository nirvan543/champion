//
//  TournamentDetailView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct TournamentDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private let backgroundColor = Color(uiColor: .secondarySystemBackground)
    private let themeColor = Color(uiColor: UIColor(red: 112/225.0, green: 112/225.0, blue: 112/225.0, alpha: 1.0))
    
    let tournament: Tournament
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 42) {
                tournamentTypeSection
                tournamentDateSection
                participantsSection
                leagueStageConfigSection
                knockoutStageConfigSection
                viewMatchesButton
                finalActionSection
                    .padding(.top, 27)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .background(backgroundColor.ignoresSafeArea())
        .navigationTitle(tournament.name)
    }
    
    private var finalActionSection: some View {
        VStack(spacing: 14) {
            Button {
                // TODO
            } label: {
                Text("Edit Tournament")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
            }
            .background()
            .overlay(Rectangle().strokeBorder(themeColor, lineWidth: 5))
            
            Button {
                // TODO
            } label: {
                Text("Start Tournament")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
            }
            .background(themeColor)
            .overlay(Rectangle().strokeBorder(themeColor, lineWidth: 5))
        }
    }
    
    private var viewMatchesButton: some View {
        Button {
            // TODO
        } label: {
            Text("View Matches")
                .font(.title2)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .background()
        .overlay(Rectangle().strokeBorder(themeColor, lineWidth: 5))
    }
    
    private var participantsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeaderLabelView(text: "Participants")
            
            VStack(alignment: .leading) {
                ForEach(tournament.participants) { participant in
                    HStack(spacing: 14) {
                        participant.image
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
    
    private var knockoutStageConfigSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeaderLabelView(text: "Knockout Stage Config")
            
            VStack(alignment: .leading, spacing: 8) {
                ReadOnlyConfigLineItemView(labelText: "Playoff Spots",
                                           value: "\(tournament.gameConfig.knockoutStageConfig.playoffSpotCount)")
                
                ReadOnlyConfigLineItemView(labelText: "Legs per Match",
                                           value: "\(tournament.gameConfig.knockoutStageConfig.legsPerMatch)")
            }
        }
    }
    
    private var leagueStageConfigSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeaderLabelView(text: "League Stage Config")
            
            VStack(alignment: .leading, spacing: 8) {
                ReadOnlyConfigLineItemView(labelText: "Matches per Opponent",
                                           value: "\(tournament.gameConfig.leagueStageConfig.matchesPerOpponent)")
                
                ReadOnlyConfigLineItemView(labelText: "Legs per Match",
                                           value: "\(tournament.gameConfig.leagueStageConfig.legsPerMatch)")
            }
        }
    }
    
    private var tournamentDateSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeaderLabelView(text: "Tournament Date")
            
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
    
    private var tournamentTypeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeaderLabelView(text: "Tournament Type")
            
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
    private static let tournament = TestData.tournaments[0]
    static var previews: some View {
        Group {
            NavigationView {
                TournamentDetailView(tournament: tournament)
            }
            NavigationView {
                TournamentDetailView(tournament: tournament)
            }
            .preferredColorScheme(.dark)
        }
    }
}
