//
//  AddEditTournamentView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct AddEditTournamentView: View {
    static let defaultTournamentFormat: TournamentFormat = .roundRobin
    
    private let tournamentFormats = MockTournamentRepository.shared.retrieveTournamentFormats()
    private let catalogService = ClubCatalogService.shared
    private let matchCellShape = Rectangle()
    
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var environmentValues: EnvironmentValues
    
    private var editingTournament: Binding<Tournament>? = nil
    @State private var tournamentName = ""
    @State private var tournamentDate = Date()
    @State private var fifaVersionName: String
    @State private var tournamentFormat: TournamentFormat = defaultTournamentFormat
    @State private var participants = [Participant]()
    @State private var tournamentRounds = [Round]()
    @State private var tournamentManager = TournamentFormatFactory.tournamentFormatManager(for: defaultTournamentFormat)
    
    @State private var presentAddParticipantView = false
    @State private var presentFormErrorAlert = false
    @State private var formError: ChampionError? = nil
    
    @FocusState private var focusField: Bool
    
    init(editingTournament: Binding<Tournament>? = nil) {
        self.editingTournament = editingTournament
        _fifaVersionName = State(initialValue: catalogService.defaultSelections.fifaVersion.name)
    }
    
    var body: some View {
        PageView {
            tournamentNameSection
            tournamentDateSection
            fifaVersionSection
            tournamentFormatSection
            TournamentFormatFactory.addEditTournamentFormatView(for: tournamentFormat,
                                                                tournamentFormatConfig: $tournamentManager.tournamentFormatConfig)
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
                AddParticipantView2(participants: $participants, fifaVersion: fifaVersion)
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
        .onAppear {
            // TODO: Eventually move the state initialization into the `init`.
            guard let editingTournament = editingTournament else {
                return
            }

            tournamentName = editingTournament.wrappedValue.name
            tournamentDate = editingTournament.wrappedValue.date
            tournamentFormat = editingTournament.wrappedValue.format
            participants = editingTournament.wrappedValue.participants
            tournamentRounds = editingTournament.wrappedValue.rounds
            tournamentManager = editingTournament.wrappedValue.manager
        }
    }
    
    private var fifaVersion: FifaVersion {
        guard let version = catalogService.fifaVersions.first(where: { $0.name == fifaVersionName }) else {
            fatalError("Could not find FIFA Version of \(fifaVersionName)")
        }
        
        return version
    }
    
    private var tournamentNameSection: some View {
        PageSection(headerText: "Tournament Name") {
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
    
    private var fifaVersionSection: some View {
        PageSection(headerText: "FIFA Version") {
            HStack {
                Picker("FIFA Version", selection: $fifaVersionName) {
                    ForEach(catalogService.fifaVersions) { fifaGameVersion in
                        Text(fifaGameVersion.name)
                    }
                }
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
                                  tournamentFormatManager: tournamentManager,
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
            
            if let editingTournament = editingTournament {
                saveEditedTournament(editingTournament: editingTournament)
            } else {
                saveNewTournament()
            }
            
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
        
        if let configError = tournamentManager.tournamentFormatConfig.validate() {
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
    
    private func saveEditedTournament(editingTournament: Binding<Tournament>) {
        editingTournament.wrappedValue.name = tournamentName
        editingTournament.wrappedValue.participants = participants
        editingTournament.wrappedValue.rounds = tournamentRounds
        editingTournament.wrappedValue.date = tournamentDate
        editingTournament.wrappedValue.format = tournamentFormat
        editingTournament.wrappedValue.fifaVersionName = fifaVersionName
        editingTournament.wrappedValue.manager = tournamentManager
    }
    
    private func saveNewTournament() {
        let newTournament = Tournament(id: IdUtils.newUuid,
                                       name: tournamentName,
                                       participants: participants,
                                       rounds: tournamentRounds,
                                       date: tournamentDate,
                                       state: .created,
                                       type: tournamentFormat,
                                       fifaVersionName: fifaVersionName,
                                       manager: tournamentManager)
        
        environmentValues.addTournament(tournament: newTournament)
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
