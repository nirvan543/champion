//
//  CreateEditMatchesView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/12/22.
//

import SwiftUI

struct TournamentInfo {
    let tournamentName: String
    let tournamentDate: Date
    let fifaVersionName: String
    let tournamentFormat: TournamentFormat
    let participants: [Participant]
}

struct CreateEditRoundRobinMatchesView: View {
    static private let defaultLegsPerMatch = 1
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var environmentValues: EnvironmentValues
    
    @FocusState private var focusField: Bool
    
    @State private var legsPerMatch: Int
    @State private var rounds: [Round]
    
    @State private var formError: ChampionError? = nil
    @State private var presentFormErrorAlert = false
    
    let tournamentInfo: TournamentInfo?
    var editingTournament: Binding<RoundRobinTournament>?
    
    init(tournamentInfo: TournamentInfo) {
        self.tournamentInfo = tournamentInfo
        editingTournament = nil
        
        _legsPerMatch = State(initialValue: Self.defaultLegsPerMatch)
        _rounds = State(initialValue: [])
    }
    
    init(editingTournament: Binding<RoundRobinTournament>) {
        self.editingTournament = editingTournament
        tournamentInfo = nil
        
        _legsPerMatch = State(initialValue: editingTournament.wrappedValue.legsPerMatch)
        _rounds = State(initialValue: editingTournament.wrappedValue.rounds)
    }
    
    var body: some View {
        PageView {
            configSection
            roundsViews
            actionSection
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
    }
    
    private var configSection: some View {
        PageSection("League Stage Config") {
            VStack(alignment: .leading, spacing: 8) {
                EditableConfigLineItemView(labelText: "Legs per Match", value: $legsPerMatch)
                    .focused($focusField)
            }
        }
    }
    
    private var roundsViews: some View {
        ForEach(Array(rounds.enumerated()), id: \.element) { index, round in
            PageSection("Round \(index + 1)") {
                VStack {
                    ForEach(round.matches) { match in
                        MatchCellView(participant1: match.participant1,
                                      participant2: match.participant2,
                                      participant1Score: match.participant1Score,
                                      participant2Score: match.participant2Score,
                                      matchState: match.matchState,
                                      winner: match.winner,
                                      endedInATie: match.endedInATie)
                    }
                }
            }
        }
    }
    
    private var actionSection: some View {
        PageSection {
            VStack {
                autoGenerateButton
                cancelButton
                saveButton
            }
        }
    }
    
    private var autoGenerateButton: some View {
        Button {
            rounds = MatchesService.shared.createMatches(participants: participants,
                                                         legsPerMatch: legsPerMatch)
        } label: {
            Text("Auto-Generate")
                .font(.title2)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .background()
        .overlay(overlay)
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
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
                .font(.title2)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .background()
        .overlay(overlay)
    }
    
    private var saveButton: some View {
        Button {
            guard formIsValid() else {
                presentFormErrorAlert = true
                return
            }
            
            if let editingTournament {
                saveEditedTournament(editingTournament: editingTournament)
            } else {
                saveNewTournament()
            }
        } label: {
            Text("Save")
                .font(.title2)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .background(Design.themeColor)
        .overlay(overlay)
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
        editingTournament.wrappedValue.rounds = rounds
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveNewTournament() {
        guard let tournamentInfo = tournamentInfo else {
            fatalError("tournamentInfo should not be nil here")
        }
        
        let newTournament = RoundRobinTournament(name: tournamentInfo.tournamentName,
                                                 date: tournamentInfo.tournamentDate,
                                                 fifaVersionName: tournamentInfo.fifaVersionName,
                                                 participants: tournamentInfo.participants,
                                                 state: .created,
                                                 rounds: rounds,
                                                 legsPerMatch: legsPerMatch)
        
        environmentValues.addTournament(tournament: newTournament)
        environmentValues.navigateToCreateTournamentView = false
    }
    
    private var overlay: some View {
        Design.defaultShape.strokeBorder(Design.themeColor, lineWidth: 5)
    }
}

struct CreateEditRoundRobinMatchesView_Previews: PreviewProvider {
    @StateObject private static var environmentValues = EnvironmentValues(tournaments: MockTournamentRepository.shared.retreiveTournaments())
    private static let tournamentInfo = TournamentInfo(tournamentName: "FIFA Pro World Cup IV",
                                                       tournamentDate: Date(),
                                                       fifaVersionName: "FIFA 23",
                                                       tournamentFormat: .roundRobin,
                                                       participants: MockData.participants)
    
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
