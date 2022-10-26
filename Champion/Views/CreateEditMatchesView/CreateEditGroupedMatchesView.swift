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
    
    init(tournamentInfo: TournamentInfo, groups: [TournamentGroup]) {
        self.tournamentInfo = tournamentInfo
        _groups = State(initialValue: groups)
        _legsPerMatch = State(initialValue: Self.defaultLegsPerMatch)
    }
    
    var body: some View {
        PageView {
            configSection
            groupPicker
            roundsSection
            
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
    }
    
    private var configSection: some View {
        PageSection("Tournament Config") {
            VStack(alignment: .leading, spacing: 8) {
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
    
    private var roundsSection: some View {
        ForEach(Array(groups[groupIndex].rounds.enumerated()), id: \.element) { index, round in
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
    
    private var autoGenerateButton: some View {
        Button {
            for i in 0 ..< groups.count {
                groups[i].generateMatches(legsPerMatch: legsPerMatch)
            }
        } label: {
            Text("Auto-Generate")
                .font(.title2)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .background()
        .overlay(buttonOverlay)
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
        .overlay(buttonOverlay)
    }
    
    private var saveButton: some View {
        Button {
            guard formIsValid() else {
                presentFormErrorAlert = true
                return
            }
            
            saveNewTournament()
        } label: {
            Text("Save")
                .font(.title2)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .disabled(!matchesAreCreated)
        .background(Design.themeColor)
        .overlay(buttonOverlay)
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
    
    private var buttonOverlay: some View {
        Rectangle().strokeBorder(Design.themeColor, lineWidth: 5)
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
