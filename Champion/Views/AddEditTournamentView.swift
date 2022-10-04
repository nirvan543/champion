//
//  AddEditTournamentView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct AddEditTournamentView: View {
    private static let defaultTournamentFormat: TournamentFormat = .roundRobin
    private static let tournamentFormats: [TournamentFormat] = [ .roundRobin ]
    private static let catalogService = ClubCatalogService.shared
    
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var environmentValues: EnvironmentValues
    
    private var editingTournament: Binding<Tournament>? = nil
    @State private var tournamentName = ""
    @State private var tournamentDate = Date()
    @State private var fifaVersionName: String
    @State private var tournamentFormat: TournamentFormat = defaultTournamentFormat
    @State private var tournamentFormatConfig = Self.tournamentFormatManager(for: defaultTournamentFormat)
    @State private var participants = [Participant]()
    @State private var tournamentRounds = [Round]()
    
    @State private var presentAddParticipantView = false
    @State private var presentFormErrorAlert = false
    @State private var formError: ChampionError? = nil
    
    @FocusState private var focusField: Bool
    
    init(editingTournament: Binding<Tournament>? = nil) {
        self.editingTournament = editingTournament
        _fifaVersionName = State(initialValue: Self.catalogService.defaultFifaVersion.name)
    }
    
    private static func tournamentFormatManager(for format: TournamentFormat) -> TournamentFormatConfig {
        switch format {
        case .roundRobin:
            return RoundRobinTournamentFormatConfig()
        }
    }
    
    var body: some View {
        PageView {
            tournamentNameSection
            tournamentDateSection
            fifaVersionSection
            tournamentFormatSection
            TournamentFormatFactory.addEditTournamentFormatView(for: tournamentFormat,
                                                                formatConfig: $tournamentFormatConfig)
            participantsSection
            actionSection
        }
        .navigationTitle(editingTournament == nil ? "New Tournament" : "Edit Tournament")
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
                AddParticipantView(participants: $participants, fifaVersion: fifaVersion)
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
            tournamentFormatConfig = editingTournament.wrappedValue.formatConfig
        }
    }
    
    private var fifaVersion: FifaVersion {
        return Self.catalogService.fifaVersion(for: fifaVersionName)
    }
    
    private var tournamentNameSection: some View {
        PageSection("Tournament Name") {
            TextField("Tournament Name", text: $tournamentName)
                .textFieldStyle(.roundedBorder)
                .focused($focusField)
        }
    }
    
    private var tournamentDateSection: some View {
        PageSection("Tournament Date") {
            HStack {
                DatePicker("Tournament Date", selection: $tournamentDate)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background()
            .overlay(sectionOverlay)
        }
    }
    
    private var fifaVersionSection: some View {
        PageSection("FIFA Version") {
            HStack {
                Picker("FIFA Version", selection: $fifaVersionName) {
                    ForEach(Self.catalogService.fifaVersions) { fifaGameVersion in
                        Text(fifaGameVersion.name)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background()
            .overlay(sectionOverlay)
        }
    }
    
    private var tournamentFormatSection: some View {
        PageSection("Tournament Format") {
            HStack {
                Picker("Tournament Format", selection: $tournamentFormat) {
                    ForEach(Self.tournamentFormats, id: \.self) { format in
                        Text(format.rawValue)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background()
            .overlay(sectionOverlay)
        }
    }
    
    private var sectionOverlay: some View {
        Design.defaultShape.strokeBorder(.quaternary, lineWidth: 1)
    }
    
    private var participantsSection: some View {
        PageSection("Participants") {
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
                .overlay(Rectangle().strokeBorder(Design.themeColor, lineWidth: 5))
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
        .overlay(Rectangle().strokeBorder(Design.themeColor, lineWidth: 5))
    }
    
    private var tournamentManager: TournamentManager {
        TournamentManagerFactory.tournamentManager(for: tournamentFormat, with: tournamentFormatConfig)
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
        .background(Design.themeColor)
        .overlay(Rectangle().strokeBorder(Design.themeColor, lineWidth: 5))
    }
    
    private func formIsValid() -> Bool {
        if tournamentName.isEmpty {
            formError = ChampionError(errorMessage: "Tournament name is required.")
            return false
        }
        
        if let configError = tournamentFormatConfig.validate() {
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
        editingTournament.wrappedValue.formatConfig = tournamentFormatConfig
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
                                       formatConfig: tournamentFormatConfig)
        
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
