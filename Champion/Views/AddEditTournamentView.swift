//
//  AddEditTournamentView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct AddEditTournamentView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var environmentValues: EnvironmentValues
    
    @State private var tournamentName = ""
    @State private var tournamentFormat = TournamentFormat.roundRobinAndKnockout
    @State private var leagueStageMatchesPerOpponent = 1
    @State private var leagueLegsPerMatch = 1
    @State private var knockoutStagePlayoffSpotCount = 4
    @State private var knockoutLegsPerMatch = 2
    @State private var participants = [Participant]()
    @State private var presentAddParticipantView = false
    @State private var leagueStageRounds = [Round]()
    @State private var presentFormErrorAlert = false
    @State private var formError: ChampionError? = nil
    
    @FocusState private var focusField: Bool
    
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
                actionSection
            }
        }
        .frame(maxWidth: .infinity)
        .background(DesignValues.pageColor.ignoresSafeArea())
        .navigationTitle("New Tournament")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusField = false
                }
            }
        }
        .sheet(isPresented: $presentAddParticipantView) {
            NavigationView {
                AddParticipantView(particiapnts: $participants)
            }
        }
        .alert("There are some errors", isPresented: $presentFormErrorAlert) {
            Button("Dismiss", role: .cancel, action: {})
        } message: {
            if let formError = formError {
                Text(formError.errorMessage)
            } else {
                Text("There are some form errors")
            }
        }

    }
    
    private var tournamentNameSection: some View {
        PageSection {
            TextField("Tournament Name", text: $tournamentName)
                .textFieldStyle(.roundedBorder)
                .focused($focusField)
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
    
    private var actionSection: some View {
        PageSection {
            createFixuresLink
            saveTournamentButton
        }
    }
    
    private var createFixuresLink: some View {
        NavigationLink {
            CreateEditMatchesView(participants: participants,
                                  matchesPerOpponent: leagueStageMatchesPerOpponent,
                                  legsPerMatch: leagueLegsPerMatch,
                                  roundsBinding: $leagueStageRounds)
        } label: {
            Text(leagueStageRounds.isEmpty ? "Create Matches" : "View Matches")
                .font(.title2)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .background()
        .overlay(Rectangle().strokeBorder(DesignValues.themeColor, lineWidth: 5))
    }
    
    private var saveTournamentButton: some View {
        Button {
            guard formIsValid() else {
                presentFormErrorAlert = true
                return
            }
            
            let newTournament = Tournament(id: IdUtils.newUuid,
                                           state: .created,
                                           name: tournamentName,
                                           date: Date(), // TODO: Make this dynamic
                                           type: tournamentFormat,
                                           participants: participants,
                                           roundRobinStage: RoundRobinStage(matchesPerOpponent: leagueStageMatchesPerOpponent,
                                                                            legsPerMatch: leagueLegsPerMatch),
                                           knockoutStage: KnockoutStage(playoffSpots: knockoutStagePlayoffSpotCount,
                                                                        legsPerMatch: knockoutLegsPerMatch,
                                                                        finalLegsPerMatch: 1, // TODO: Make this dynamic
                                                                        rounds: []))
            
            environmentValues.addTournament(tournament: newTournament)
            
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Save")
                .font(.title2)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .background(DesignValues.themeColor)
        .overlay(Rectangle().strokeBorder(DesignValues.themeColor, lineWidth: 5))
    }
    
    private func formIsValid() -> Bool {
        if tournamentName.isEmpty {
            formError = ChampionError(errorMessage: "Tournament name is required.")
            return false
        }
        
        if leagueStageMatchesPerOpponent < 1 {
            formError = ChampionError(errorMessage: "League stage 'Matches per Opponent' must be at least '1'.")
            return false
        }
        
        if leagueLegsPerMatch < 1 {
            formError = ChampionError(errorMessage: "League stage 'Legs per Match' must be at least '1'.")
            return false
        }
        
        if knockoutStagePlayoffSpotCount < 2 {
            formError = ChampionError(errorMessage: "Knockout stage 'Playoff Spots' must be at least '2'.")
            return false
        }
        
        if knockoutLegsPerMatch < 1 {
            formError = ChampionError(errorMessage: "Knockout stage 'Legs per Match' must be at least '1'.")
            return false
        }
        
        if participants.count < 2 {
            formError = ChampionError(errorMessage: "Minimum of 2 participants required.")
            return false
        }
        
        if leagueStageRounds.isEmpty {
            formError = ChampionError(errorMessage: "Matches must be created before creating the tournament.")
            return false
        }
        
        return true
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
    @StateObject private static var environmentValues = EnvironmentValues(tournaments: MockTournamentRepository.shared.retreiveTournaments())
    
    static var previews: some View {
        NavigationView {
            AddEditTournamentView()
                .environmentObject(environmentValues)
        }
    }
}
