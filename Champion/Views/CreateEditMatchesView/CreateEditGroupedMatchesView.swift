//
//  CreateEditGroupedMatchesView.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/25/22.
//

import SwiftUI

struct CreateEditGroupedMatchesView: View {
    static private let defaultLegsPerMatch = 1
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var environmentValues: EnvironmentValues
    
    @FocusState private var focusField: Bool
    @State private var formError: ChampionError? = nil
    @State private var presentFormErrorAlert = false
    
    @State private var legsPerMatch: Int
    @State private var groups: [TournamentGroup]
    @State private var groupIndex = 0
    
    let tournamentInfo: TournamentInfo?
    var editingTournament: Binding<GroupedTournament>?
    
    init(tournamentInfo: TournamentInfo, groups: [TournamentGroup]) {
        self.tournamentInfo = tournamentInfo
        editingTournament = nil
        
        _groups = State(initialValue: groups)
        _legsPerMatch = State(initialValue: Self.defaultLegsPerMatch)
    }
    
    init(editingTournament: Binding<GroupedTournament>, groups: [TournamentGroup]) {
        self.editingTournament = editingTournament
        tournamentInfo = nil
        
        _groups = State(initialValue: groups)
        _legsPerMatch = State(initialValue: editingTournament.wrappedValue.legsPerMatch)
    }
    
    var body: some View {
        PageView {
            configSection
            groupPicker
            RoundsView(rounds: groups[groupIndex].rounds)
            
            PageSection {
                autoGenerateButton
                cancelButton
                saveButton
            }
        }
        .navigationTitle(Text("Create Group Matches"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    for i in 0 ..< groups.count {
                        groups[i].rounds.removeAll()
                    }
                } label: {
                    Text("Clear")
                }
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusField = false
                }
            }
        }
        .onChange(of: legsPerMatch) { _ in
            for i in 0 ..< groups.count {
                groups[i].clearMatches()
            }
        }
    }
    
    private var configSection: some View {
        PageSection("Tournament Config") {
            FormContent {
                EditableConfigLineItemView(labelText: "Legs per Match", value: $legsPerMatch)
                    .focused($focusField)
            }
        }
    }
    
    private var groupPicker: some View {
        HStack {
            Spacer()
            Picker("Group \(groupIndex + 1)", selection: $groupIndex) {
                ForEach(Array(groups.enumerated()), id: \.element.id) { index, group in
                    Text("Group \(index + 1)").tag(index)
                }
            }
            Spacer()
        }
    }
    
    private var autoGenerateButton: some View {
        SecondaryButton("Auto-Generate") {
            for i in 0 ..< groups.count {
                groups[i].generateMatches(legsPerMatch: legsPerMatch)
            }
        }
    }
    
    private var cancelButton: some View {
        SecondaryButton("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private var saveButton: some View {
        PrimaryButton("Save") {
            guard formIsValid() else {
                presentFormErrorAlert = true
                return
            }
            
            if let editingTournament {
                saveEditedTournament(editingTournament: editingTournament)
            } else {
                saveNewTournament()
            }
        }
        .disabled(!matchesAreCreated)
    }
    
    private func formIsValid() -> Bool {
        if legsPerMatch < 1 {
            formError = ChampionError(errorMessage: "Legs per match must be '1' or more")
            return false
        }
        
        if !matchesAreCreated {
            formError = ChampionError(errorMessage: "Matches must be created before saving")
            return false
        }
        
        return true
    }
    
    private func saveNewTournament() {
        guard let tournamentInfo = tournamentInfo else {
            fatalError("tournamentInfo should not be nil here")
        }
        
        let newTournament = GroupedTournament(name: tournamentInfo.tournamentName,
                                              date: tournamentInfo.tournamentDate,
                                              fifaVersionName: tournamentInfo.fifaVersionName,
                                              participants: tournamentInfo.participants,
                                              state: .created,
                                              groups: groups,
                                              legsPerMatch: legsPerMatch)
        
        environmentValues.addTournament(tournament: newTournament)
        environmentValues.navigateToCreateTournamentView = false
    }
    
    private func saveEditedTournament(editingTournament: Binding<GroupedTournament>) {
        editingTournament.wrappedValue.legsPerMatch = legsPerMatch
        editingTournament.wrappedValue.groups = groups
        
        environmentValues.navigateToCreateMatchesView = false
    }
    
    private var matchesAreCreated: Bool {
        groups.allSatisfy({ !$0.rounds.isEmpty })
    }
}

struct CreateEditGroupedMatchesView_Previews: PreviewProvider {
    @StateObject private static var environmentValues = EnvironmentValues(tournaments: MockTournamentRepository.shared.retreiveTournaments())
    
    private static let tournamentInfo = TournamentInfo(tournamentName: "FIFA Pro World Cup IV",
                                                       tournamentDate: Date(),
                                                       fifaVersionName: "FIFA 23",
                                                       tournamentFormat: .grouped,
                                                       participants: MockData.participants)
    static var previews: some View {
        NavigationView {
            CreateEditGroupedMatchesView(tournamentInfo: tournamentInfo, groups: MockData.groups)
        }
        .environmentObject(environmentValues)
    }
}
