//
//  CreateEditMatchesView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/12/22.
//

import SwiftUI

struct CreateEditMatchesView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var rounds: [Round]
    
    private let matchCellShape = Rectangle()
    
    let participants: [Participant]
    let tournamentManager: TournamentManager
    @Binding var roundsBinding: [Round]
    
    init(participants: [Participant],
         tournamentFormatManager: TournamentManager,
         roundsBinding: Binding<[Round]>) {
        
        self.participants = participants
        self.tournamentManager = tournamentFormatManager
        _roundsBinding = roundsBinding
        _rounds = State(initialValue: roundsBinding.wrappedValue)
    }
    
    var body: some View {
        PageView {
            roundsViews
            actionSection
        }
        .navigationTitle("Create Matches")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                rounds.removeAll()
            } label: {
                Text("Clear")
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
            rounds = tournamentManager.generateMatches(participants: participants)
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
            roundsBinding = rounds
            presentationMode.wrappedValue.dismiss()
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
    
    private var overlay: some View {
        Design.defaultShape.strokeBorder(Design.themeColor, lineWidth: 5)
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
}

struct CreateEditMatchesView_Previews: PreviewProvider {
    private static let participants = MockData.participants
    private static let tournamentFormatManager = RoundRobinTournamentManager(tournamentFormatConfig: RoundRobinTournamentFormatConfig())
    @State private static var rounds = MockData.rounds
    @State private static var emptyRounds = [Round]()
    
    static var previews: some View {
        Group {
            NavigationView {
                CreateEditMatchesView(participants: participants,
                                      tournamentFormatManager: tournamentFormatManager,
                                      roundsBinding: $rounds)
            }
            
            NavigationView {
                CreateEditMatchesView(participants: participants,
                                      tournamentFormatManager: tournamentFormatManager,
                                      roundsBinding: $emptyRounds)
            }
        }
    }
}
