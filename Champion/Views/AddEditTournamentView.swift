//
//  AddEditTournamentView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct AddEditTournamentView: View {
    private static let tournamentFormats: [TournamentFormat] = [ .roundRobin ]
    private static let defaultTournamentFormat: TournamentFormat = Self.tournamentFormats.first!
    private static let catalogService = ClubCatalogService.shared
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var environmentValues: EnvironmentValues
    
    @FocusState private var focusField: Bool
    
    @State private var tournamentName: String
    @State private var tournamentDate: Date
    @State private var fifaVersionName: String
    @State private var tournamentFormat: TournamentFormat
    @State private var participants: [Participant]
    
    @State private var presentAddParticipantView = false
    @State private var presentFormErrorAlert = false
    @State private var formError: ChampionError? = nil
    @State private var navigateToCreateMatchesView = false
    
    private var editingTournament: Binding<RoundRobinTournament>? = nil
    
    init(editingTournament: Binding<RoundRobinTournament>? = nil) {
        self.editingTournament = editingTournament

        _tournamentName = State(initialValue: editingTournament?.wrappedValue.name ?? "")
        _tournamentDate = State(initialValue: editingTournament?.wrappedValue.date ?? Date())
        _fifaVersionName = State(initialValue: Self.catalogService.defaultFifaVersion.name)
        
        if let editingTournament {
            _tournamentFormat = State(initialValue: Self.tournamentFormat(for: editingTournament.wrappedValue))
        } else {
            _tournamentFormat = State(initialValue: Self.defaultTournamentFormat)
        }
        
        _participants = State(initialValue: editingTournament?.wrappedValue.participants ?? [])
    }
    
    private static func tournamentFormat(for tournament: Tournament) -> TournamentFormat {
        if tournament is RoundRobinTournament {
            return .roundRobin
        }
        
        fatalError()
    }
    
    var body: some View {
        PageView {
            tournamentNameSection
            tournamentDateSection
            fifaVersionSection
            tournamentFormatSection
            participantsSection
            actionSection
            links
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
    }
    
    private var links: some View {
        NavigationLink(isActive: $navigateToCreateMatchesView) {
            CreateEditMatchesView(tournamentInfo: TournamentInfo(tournamentName: tournamentName,
                                                                 tournamentDate: tournamentDate,
                                                                 fifaVersionName: fifaVersionName,
                                                                 tournamentFormat: tournamentFormat,
                                                                 participants: participants))
        } label: {
            EmptyView()
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
            VStack(alignment: .leading) {
                ForEach(participants) { participant in
                    participantRow(participant: participant)
                }
                
                addParticipantButton
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
            deleteParticipantButton(participant: participant)
        }
        .padding()
        .background()
    }
    
    private func deleteParticipantButton(participant: Participant) -> some View {
        Button {
            participants.removeAll(where: { $0 == participant })
        } label: {
            Image(systemName: "xmark")
                .foregroundColor(.red)
        }
    }
    
    private var addParticipantButton: some View {
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
        .overlay(buttonOverlay)
    }
    
    private var actionSection: some View {
        PageSection {
            createFixuresLink
//            saveTournamentButton
        }
    }
    
    private var createFixuresLink: some View {
        Button {
            guard formIsValid() else {
                presentFormErrorAlert = true
                return
            }
            
            navigateToCreateMatchesView = true
        } label: {
            Text(createMatchesButtonText)
                .font(.title2)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .background()
        .overlay(buttonOverlay)
    }
    
    private var createMatchesButtonText: String {
        if let editingTournament, editingTournament.wrappedValue.matchesAreCreated {
            return "View Matches"
        } else {
            return "Create Matches"
        }
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
        .overlay(buttonOverlay)
    }
    
    private var buttonOverlay: some View {
        Rectangle().strokeBorder(Design.themeColor, lineWidth: 5)
    }
    
    private func formIsValid() -> Bool {
        if tournamentName.isEmpty {
            formError = ChampionError(errorMessage: "Tournament name is required.")
            return false
        }
        
        if participants.count < 2 {
            formError = ChampionError(errorMessage: "Minimum of 2 participants required.")
            return false
        }
        
        if let editingTournament, !editingTournament.wrappedValue.matchesAreCreated {
            formError = ChampionError(errorMessage: "Matches must be created before creating the tournament.")
            return false
        }
        
        return true
    }
    
    private func saveEditedTournament(editingTournament: Binding<RoundRobinTournament>) {
        editingTournament.wrappedValue.name = tournamentName
        editingTournament.wrappedValue.date = tournamentDate
        editingTournament.wrappedValue.fifaVersionName = fifaVersionName
        editingTournament.wrappedValue.participants = participants
    }
    
    private func saveNewTournament() {
        let newTournament = RoundRobinTournament(name: tournamentName,
                                                 date: tournamentDate,
                                                 fifaVersionName: fifaVersionName,
                                                 participants: participants,
                                                 state: .created,
                                                 rounds: [])
        
        environmentValues.addTournament(tournament: newTournament)
    }
}

struct AddEditTournamentView_Previews: PreviewProvider {
    @StateObject private static var environmentValues = EnvironmentValues(tournaments: MockTournamentRepository.shared.retreiveTournaments())
    @State private static var editingTournament = MockData.atlantaCup3
    
    static var previews: some View {
        NavigationView {
            AddEditTournamentView(editingTournament: $editingTournament)
                .environmentObject(environmentValues)
        }
    }
}
