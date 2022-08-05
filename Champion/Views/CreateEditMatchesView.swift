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
    let matchesPerOpponent: Int
    let legsPerMatch: Int
    @Binding var roundsBinding: [Round]
    
    init(participants: [Participant],
         matchesPerOpponent: Int,
         legsPerMatch: Int,
         roundsBinding: Binding<[Round]>) {
        
        self.participants = participants
        self.matchesPerOpponent = matchesPerOpponent
        self.legsPerMatch = legsPerMatch
        _roundsBinding = roundsBinding
        _rounds = State(initialValue: roundsBinding.wrappedValue)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 42) {
                roundsViews
                actionSection
            }
        }
        .frame(maxWidth: .infinity)
        .background(DesignValues.pageColor.ignoresSafeArea())
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
                Button {
                    rounds = MatchesService.shared.createMatches(participants: participants,
                                                                  matchesPerOpponent: matchesPerOpponent,
                                                                  legsPerMatch: legsPerMatch)
                } label: {
                    Text("Auto-Generate")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                }
                .background()
                .overlay(Rectangle().strokeBorder(DesignValues.themeColor, lineWidth: 5))
                
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
                .overlay(Rectangle().strokeBorder(DesignValues.themeColor, lineWidth: 5))
                
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
                .background(DesignValues.themeColor)
                .overlay(Rectangle().strokeBorder(DesignValues.themeColor, lineWidth: 5))
            }
        }
    }
    
    private var roundsViews: some View {
        ForEach(Array(rounds.enumerated()), id: \.element) { index, round in
            PageSection(headerText: "Round \(index + 1)") {
                VStack {
                    ForEach(round.matches) { match in
                        MatchCellView(participant1: match.participant1,
                                      participant2: match.participant2,
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
    @State private static var rounds = MockData.roundRobinStage.rounds
    @State private static var emptyRounds = [Round]()
    
    static var previews: some View {
        Group {
            NavigationView {
                CreateEditMatchesView(participants: participants,
                                      matchesPerOpponent: 1,
                                      legsPerMatch: 1,
                                      roundsBinding: $rounds)
            }
            
            NavigationView {
                CreateEditMatchesView(participants: participants,
                                      matchesPerOpponent: 1,
                                      legsPerMatch: 1,
                                      roundsBinding: $emptyRounds)
            }
        }
    }
}
