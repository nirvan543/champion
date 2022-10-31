//
//  AddEditTournamentView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct AddEditTournamentView: View {
    private static let tournamentFormats: [TournamentFormat] = TournamentFormat.allCases
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
    
    private var editingTournament: Binding<any Tournament>? = nil
    
    init(editingTournament: Binding<any Tournament>? = nil) {
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
    
    private static func tournamentFormat(for tournament: any Tournament) -> TournamentFormat {
        if tournament is RoundRobinTournament {
            return .roundRobin
        }
        
        if tournament is GroupedTournament {
            return .grouped
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
            createMatchesLink
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
        .onChange(of: participants) { _ in
            if let editingTournament {
                editingTournament.wrappedValue.clearMatches()
            }
        }
    }
    
    private var isEditingTournament: Bool {
        editingTournament != nil
    }
    
    @ViewBuilder
    private var createMatchesLink: some View {
        switch tournamentFormat {
        case .roundRobin:
            createRoundRobinMatchesLink
        case .grouped:
            createGroupedMatchesLink
        }
    }
    
    private var createRoundRobinMatchesLink: some View {
        NavigationLink(isActive: $environmentValues.navigateToCreateMatchesView) {
            if let editingTournament {
                CreateEditRoundRobinMatchesView(editingTournament: roundRobinTournament(from: editingTournament))
            } else {
                CreateEditRoundRobinMatchesView(tournamentInfo: tournamentInfo)
            }
        } label: {
            EmptyView()
        }
    }
    
    private var tournamentInfo: TournamentInfo {
        TournamentInfo(tournamentName: tournamentName,
                       tournamentDate: tournamentDate,
                       fifaVersionName: fifaVersionName,
                       tournamentFormat: tournamentFormat,
                       participants: participants)
    }
    
    private func roundRobinTournament(from tournament: Binding<any Tournament>) -> Binding<RoundRobinTournament> {
        return Binding {
            tournament.wrappedValue as! RoundRobinTournament
        } set: { newValue in
            tournament.wrappedValue = newValue
        }
    }
    
    private var createGroupedMatchesLink: some View {
        NavigationLink(isActive: $environmentValues.navigateToCreateMatchesView) {
            if let editingTournament {
                CreateEditGroupsView(editingTournament: groupedTournament(from: editingTournament))
            } else {
                CreateEditGroupsView(tournamentInfo: tournamentInfo)
            }
        } label: {
            EmptyView()
        }
    }
    
    private func groupedTournament(from tournament: Binding<any Tournament>) -> Binding<GroupedTournament> {
        return Binding {
            tournament.wrappedValue as! GroupedTournament
        } set: { newValue in
            tournament.wrappedValue = newValue
        }
    }
    
    private var fifaVersion: FifaVersion {
        return Self.catalogService.fifaVersion(for: fifaVersionName)
    }
    
    private var tournamentNameSection: some View {
        PageSection("Tournament Name") {
            CustomTextField("Tournament Name", text: $tournamentName)
                .textInputAutocapitalization(.words)
                .focused($focusField)
        }
    }
    
    private var tournamentDateSection: some View {
        PageSection("Tournament Date") {
            FormContent {
                DatePicker("Tournament Date", selection: $tournamentDate)
                    .labelsHidden()
            }
        }
    }
    
    private var fifaVersionSection: some View {
        PageSection("FIFA Version") {
            FormContent {
                Picker("FIFA Version", selection: $fifaVersionName) {
                    ForEach(Self.catalogService.fifaVersions) { fifaGameVersion in
                        Text(fifaGameVersion.name)
                    }
                }
                .disabled(editingTournament != nil)
            }
        }
    }
    
    private var tournamentFormatSection: some View {
        PageSection("Tournament Format") {
            FormContent {
                Picker("Tournament Format", selection: $tournamentFormat) {
                    ForEach(Self.tournamentFormats, id: \.self) { format in
                        Text(format.rawValue)
                    }
                }
                .disabled(editingTournament != nil)
            }
        }
    }
    
    private var sectionOverlay: some View {
        Design.defaultShape.strokeBorder(.quaternary, lineWidth: 1)
    }
    
    private var participantsSection: some View {
        PageSection("Participants") {
            ParticipantsListView(participants: participants) { participant in
                participants.removeAll(where: { $0 == participant })
            } addParticipantAction: {
                presentAddParticipantView.toggle()
            }
        }
    }
    
    private var addParticipantButton: some View {
        Button {
            presentAddParticipantView.toggle()
        } label: {
            Text("+ Add Participant")
                .font(.headline)
                .foregroundColor(Design.themeColor)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity)
        }
    }
    
    private var actionSection: some View {
        PageSection {
            createFixuresLink
            
            if let editingTournament = editingTournament {
                saveTournamentButton(editingTournament: editingTournament)
            }
        }
    }
    
    @ViewBuilder
    private var createFixuresLink: some View {
        if isEditingTournament {
            SecondaryButton(createMatchesButtonText, action: createFixturesAction)
        } else {
            PrimaryButton(createMatchesButtonText, action: createFixturesAction)
        }
    }
    
    private func createFixturesAction() {
        guard formIsValid() else {
            presentFormErrorAlert = true
            return
        }
        
        environmentValues.navigateToCreateMatchesView = true
    }
    
    private var createMatchesButtonText: String {
        if let editingTournament, editingTournament.wrappedValue.matchesAreCreated {
            return "Edit Matches"
        } else {
            return "Create Matches"
        }
    }
    
    private func saveTournamentButton(editingTournament: Binding<any Tournament>) -> some View {
        PrimaryButton("Save") {
            guard formIsValid() else {
                presentFormErrorAlert = true
                return
            }
            
            saveEditedTournament(editingTournament: editingTournament)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func saveEditedTournament(editingTournament: Binding<any Tournament>) {
        editingTournament.wrappedValue.name = tournamentName
        editingTournament.wrappedValue.date = tournamentDate
        editingTournament.wrappedValue.participants = participants
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
        
        return true
    }
}

struct AddEditTournamentView_Previews: PreviewProvider {
    @StateObject private static var environmentValues = EnvironmentValues(tournaments: MockTournamentRepository.shared.retreiveTournaments())
    @State private static var editingTournament: any Tournament = MockData.atlantaCup3
    
    static var previews: some View {
        Group {
            NavigationView {
                AddEditTournamentView(editingTournament: $editingTournament)
            }
            NavigationView {
                AddEditTournamentView(editingTournament: nil)
            }
        }
        .environmentObject(environmentValues)
    }
}
