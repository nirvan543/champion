//
//  CreateEditMatchesView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/12/22.
//

import SwiftUI

struct CreateEditRoundRobinMatchesView: View {
    static private let defaultLegsPerMatch = 1
    static private let defaultMatchesPerOpponent = 1
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var environmentValues: EnvironmentValues
    
    @FocusState private var focusField: Bool
    
    @State private var legsPerMatch: Int
    @State private var matchesPerOpponent: Int
    @State private var rounds: [Round]
    
    @State private var formError: ChampionError? = nil
    @State private var presentFormErrorAlert = false
    
    let tournamentInfo: TournamentInfo?
    var editingTournament: Binding<RoundRobinTournament>?
    
    init(tournamentInfo: TournamentInfo) {
        self.tournamentInfo = tournamentInfo
        editingTournament = nil
        
        _legsPerMatch = State(initialValue: Self.defaultLegsPerMatch)
        _matchesPerOpponent = State(initialValue: Self.defaultMatchesPerOpponent)
        _rounds = State(initialValue: [])
    }
    
    init(editingTournament: Binding<RoundRobinTournament>) {
        self.editingTournament = editingTournament
        tournamentInfo = nil
        
        _legsPerMatch = State(initialValue: editingTournament.wrappedValue.legsPerMatch)
        _matchesPerOpponent = State(initialValue: editingTournament.wrappedValue.matchesPerOpponent)
        _rounds = State(initialValue: editingTournament.wrappedValue.rounds)
    }
    
    var body: some View {
        PageView {
            configSection
            RoundsView(rounds: rounds)
            PageSection {
                actionSection
            }
        }
        .navigationTitle("Create Matches")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    rounds.removeAll()
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
        .alert("There are some errors", isPresented: $presentFormErrorAlert) {
            Button("Dismiss", role: .cancel, action: {})
        } message: {
            if let formError = formError {
                Text(formError.errorMessage)
            } else {
                Text("There are some form errors")
            }
        }
        .onChange(of: legsPerMatch) { _ in
            rounds.removeAll()
        }
        .onChange(of: matchesPerOpponent) { _ in
            rounds.removeAll()
        }
    }
    
    private var configSection: some View {
        PageSection("League Stage Config") {
            FormContent {
                EditableConfigLineItemView(labelText: "Matches per Opponent", value: $matchesPerOpponent)
                    .focused($focusField)
            }
            FormContent {
                EditableConfigLineItemView(labelText: "Legs per Match", value: $legsPerMatch)
                    .focused($focusField)
            }
        }
    }
    
    private var actionSection: some View {
        VStack {
            autoGenerateButton
            cancelButton
            saveButton
        }
    }
    
    private var autoGenerateButton: some View {
        SecondaryButton("Auto-Generate") {
            rounds = MatchesService.shared.createMatches(
                participants: participants,
                legsPerMatch: legsPerMatch,
                matchesPerOpponent: matchesPerOpponent
            )
        }
    }
    
    private var participants: [Participant] {
        if let editingTournament {
            return editingTournament.wrappedValue.participants
        }
        
        if let tournamentInfo {
            return tournamentInfo.participants
        }
        
        fatalError("Both editingTournament and tournamentInfo are nil. This should not be possible.")
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
    }
    
    private func formIsValid() -> Bool {
        if legsPerMatch < 1 {
            formError = ChampionError(errorMessage: "Legs per match must be '1' or more")
            return false
        }
        
        if rounds.isEmpty {
            formError = ChampionError(errorMessage: "Matches must be created before saving")
            return false
        }
        
        return true
    }
    
    private func saveEditedTournament(editingTournament: Binding<RoundRobinTournament>) {
        editingTournament.wrappedValue.legsPerMatch = legsPerMatch
        editingTournament.wrappedValue.matchesPerOpponent = matchesPerOpponent
        editingTournament.wrappedValue.rounds = rounds
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveNewTournament() {
        guard let tournamentInfo = tournamentInfo else {
            fatalError("tournamentInfo should not be nil here")
        }
        
        let newTournament = RoundRobinTournament(
            name: tournamentInfo.tournamentName,
            date: tournamentInfo.tournamentDate,
            participants: tournamentInfo.participants,
            state: .created,
            rounds: rounds,
            legsPerMatch: legsPerMatch,
            matchesPerOpponent: matchesPerOpponent
        )
        
        environmentValues.addTournament(tournament: newTournament)
        environmentValues.navigateToCreateTournamentView = false
    }
}

struct CreateEditRoundRobinMatchesView_Previews: PreviewProvider {
    @StateObject private static var environmentValues = EnvironmentValues(tournaments: MockTournamentRepository.shared.retreiveTournaments())
    
    private static let tournamentInfo = TournamentInfo(
        tournamentName: "FIFA Pro World Cup IV",
        tournamentDate: Date(),
        tournamentFormat: .roundRobin,
        participants: MockData.participants
    )
    
    static var previews: some View {
        Group {
            NavigationView {
                CreateEditRoundRobinMatchesView(tournamentInfo: tournamentInfo)
            }
            
            NavigationView {
                CreateEditRoundRobinMatchesView(tournamentInfo: tournamentInfo)
            }
        }
        .environmentObject(environmentValues)
    }
}
