//
//  AddEditTournamentView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct AddEditTournamentView: View {
    static let defaultTournamentFormat: TournamentFormat = .roundRobin
    
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var environmentValues: EnvironmentValues
    
    @State private var tournamentName = ""
    @State private var tournamentDate = Date()
    @State private var tournamentFormat: TournamentFormat = defaultTournamentFormat
    @State private var participants = [Participant]()
    @State private var presentAddParticipantView = false
    @State private var tournamentRounds = [Round]()
    @State private var presentFormErrorAlert = false
    @State private var formError: ChampionError? = nil
    @State private var tournamentFormatManager = TournamentFormatFactory.tournamentFormatManager(for: defaultTournamentFormat)
    
    @FocusState private var focusField: Bool
    
    private let tournamentFormats = MockTournamentRepository.shared.retrieveTournamentFormats()
    private let matchCellShape = Rectangle()
    
    var body: some View {
        PageView {
            tournamentNameSection
            tournamentDateSection
            tournamentFormatSection
            TournamentFormatFactory.addEditTournamentFormatView(for: tournamentFormat,
                                                                tournamentFormatConfig: $tournamentFormatManager.tournamentFormatConfig)
            participantsSection
            actionSection
        }
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
    
    private var tournamentDateSection: some View {
        PageSection(headerText: "Tournament Date") {
            HStack {
                DatePicker("Tournament Date", selection: $tournamentDate)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background()
            .overlay(matchCellShape.strokeBorder(.quaternary, lineWidth: 1))
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
    
    private var participantsSection: some View {
        PageSection(headerText: "Participants") {
            VStack {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 150))
                ]) {
                    ForEach(participants) { participant in
                        ZStack {
                            participantGridItem(imageName: participant.imageName,
                                                playerName: participant.playerName)
                            deleteParticipantButton(participant: participant)
                                .offset(x: 10, y: -10)
                        }
                    }
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
    
    private func participantGridItem(imageName: String, playerName: String) -> some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 75, height: 75)
                .padding(.vertical, 7)
            
            Text(playerName)
                .font(.title3)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background()
        .overlay(Rectangle().strokeBorder(.quaternary, lineWidth: 1))
    }
    
    private func deleteParticipantButton(participant: Participant) -> some View {
        HStack {
            Spacer()
            VStack {
                Button {
                    participants.removeAll(where: { $0 == participant })
                } label: {
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 22, height: 20)
                }
                Spacer()
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
                                  tournamentFormatManager: tournamentFormatManager,
                                  roundsBinding: $tournamentRounds)
        } label: {
            Text(tournamentRounds.isEmpty ? "Create Matches" : "View Matches")
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
                                           name: tournamentName,
                                           participants: participants,
                                           rounds: tournamentRounds,
                                           date: tournamentDate,
                                           state: .created,
                                           type: tournamentFormat,
                                           tournamentFormatManager: tournamentFormatManager)
            
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
        
        if let configError = tournamentFormatManager.tournamentFormatConfig.validate() {
            formError = configError
            return false
        }
        
        if participants.count < 2 {
            formError = ChampionError(errorMessage: "Minimum of 2 participants required.")
            return false
        }
        
        if tournamentRounds.isEmpty {
            formError = ChampionError(errorMessage: "Matches must be created before creating the tournament.")
            return false
        }
        
        return true
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
