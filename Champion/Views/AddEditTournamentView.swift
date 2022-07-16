//
//  AddEditTournamentView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct AddEditTournamentView: View {
    @State private var tournamentName = ""
    @State private var tournamentFormat = TournamentFormat.roundRobinAndKnockout
    @State private var leagueStageMatchesPerOpponent = 1
    @State private var leagueLegsPerMatch = 1
    @State private var knockoutStagePlayoffSpotCount = 4
    @State private var knockoutLegsPerMatch = 2
    @State private var participants = TestData.participants
    @State private var presentAddParticipantView = false
    @State private var leagueStageRounds = [Round]()
    
    private let tournamentFormats = MockTournamentRepository.shared.retrieveTournamentFormats()
    private let matchCellShape = Rectangle()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 42) {
                tournamentNameSection
                tournamentFormatSection
                leageStageConfigSection
                knockoutStageConfigSection
                participantsSection
                createFixuresSection
                startTournamentSection
            }
        }
        .frame(maxWidth: .infinity)
        .background(DesignValues.pageColor.ignoresSafeArea())
        .navigationTitle("New Tournament")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $presentAddParticipantView) {
            NavigationView {
                AddParticipantView(particiapnts: $participants)
            }
        }
    }
    
    private var tournamentNameSection: some View {
        PageSection {
            TextField("Tournament Name", text: $tournamentName)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    private var tournamentFormatSection: some View {
        PageSection(headerText: "Tournament Format") {
            HStack {
                Picker("Tournament Format",
                       selection: $tournamentFormat) {
                    ForEach(tournamentFormats, id: \.self) { format in
                        Text(format.rawValue)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background()
            .overlay(matchCellShape.strokeBorder(.quaternary, lineWidth: 1))
        }
    }
    
    private var leageStageConfigSection: some View {
        PageSection(headerText: "League Stage Config") {
            VStack(alignment: .leading, spacing: 8) {
                EditableConfigLineItemView(labelText: "Matches per Opponent",
                                           value: $leagueStageMatchesPerOpponent)
                
                EditableConfigLineItemView(labelText: "Legs per Match",
                                           value: $leagueLegsPerMatch)
            }
        }
    }
    
    private var knockoutStageConfigSection: some View {
        PageSection(headerText: "Knockout Stage Config") {
            EditableConfigLineItemView(labelText: "Playoff Spots",
                                       value: $knockoutStagePlayoffSpotCount)
            
            EditableConfigLineItemView(labelText: "Legs per Match",
                                       value: $knockoutLegsPerMatch)
        }
    }
    
    private var participantsSection: some View {
        PageSection(headerText: "Participants") {
            VStack(alignment: .leading) {
                ForEach(participants) { participant in
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
                
                Button {
                    presentAddParticipantView.toggle()
                } label: {
                    Text("Add Participant")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                }
                .background()
                .overlay(Rectangle().strokeBorder(DesignValues.themeColor, lineWidth: 5))
            }
        }
    }
    
    private var createFixuresSection: some View {
        PageSection {
            NavigationLink {
                CreateEditMatchesView(participants: participants,
                                      matchesPerOpponent: leagueStageMatchesPerOpponent,
                                      legsPerMatch: leagueLegsPerMatch,
                                      roundsBinding: $leagueStageRounds)
            } label: {
                Text("Create Fixtures")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
            }
            .background()
            .overlay(Rectangle().strokeBorder(DesignValues.themeColor, lineWidth: 5))
        }
    }
    
    private var startTournamentSection: some View {
        PageSection {
            NavigationLink {
                Text("Start Tournament")
            } label: {
                Text("Start Tournament")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
            }
            .background(DesignValues.themeColor)
            .overlay(Rectangle().strokeBorder(DesignValues.themeColor, lineWidth: 5))
        }
    }
}

struct EditableConfigLineItemView: View {
    let labelText: String
    @Binding var value: Int
    
    private let shape = Capsule()
    
    var body: some View {
        HStack {
            Text(labelText)
                .font(.title3)
            Spacer()
            TextField("",
                      value: $value,
                      formatter: NumberFormatter())
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(.title3)
            .padding(.horizontal)
            .padding(.vertical, 2)
            .background()
            .frame(maxWidth: 75)
            .clipShape(shape)
            .overlay(shape.strokeBorder(.quaternary, lineWidth: 1))
        }
    }
}

struct AddEditTournamentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddEditTournamentView()
        }
    }
}
