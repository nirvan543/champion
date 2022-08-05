//
//  MatchCellView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/12/22.
//

import SwiftUI

struct MatchCellView: View {
    @Environment(\.colorScheme) var colorScheme
    private let matchCellShape = Rectangle()
    
    let participant1: Participant
    let participant2: Participant
    let matchState: GameState
    let winner: Participant?
    let endedInATie: Bool
    
    var body: some View {
        ZStack {
            HStack {
                HStack {
                    leadingImage(for: participant1)
                    Text(participant1.playerName)
                        .font(.title3)
                }
                Spacer()
                HStack {
                    leadingImage(for: participant2)
                    Text(participant2.playerName)
                        .font(.title3)
                        .frame(alignment: .trailing)
                }
            }
            
            Text("vs")
                .font(.title3)
                .fontWeight(.bold)
        }
        .padding()
        .background(backgroundColor)
        .overlay(matchCellShape.strokeBorder(.quaternary, lineWidth: 1))
    }
    
    private var backgroundColor: Color {
        if matchState == .completed {
            return .green.opacity(0.30)
        } else {
            return colorScheme == .light ? .white : .black
        }
    }
    
    @ViewBuilder
    private func leadingImage(for participant: Participant) -> some View {
        if winner == participant {
            Image(systemName: "star.fill")
        } else if endedInATie {
            Image(systemName: "circle.fill")
        } else {
            EmptyView()
        }
    }
}

struct MatchCellView_Previews: PreviewProvider {
    static let oneLegMatch = Match(id: IdUtils.newUuid,
                                   participant1: MockData.antriksh,
                                   participant2: MockData.neeraj,
                                   legs: [leg])
    
    static let leg = MatchLeg(id: IdUtils.newUuid,
                              homeParticipant: MockData.antriksh,
                              awayParticipant: MockData.neeraj,
                              goals: [
                                Goal(id: IdUtils.newUuid,
                                     scorer: MockData.antriksh,
                                     against: MockData.neeraj,
                                     minute: 5),
                                Goal(id: IdUtils.newUuid,
                                     scorer: MockData.antriksh,
                                     against: MockData.neeraj,
                                     minute: 10),
                                Goal(id: IdUtils.newUuid,
                                     scorer: MockData.neeraj,
                                     against: MockData.antriksh,
                                     minute: 17),
                                Goal(id: IdUtils.newUuid,
                                     scorer: MockData.neeraj,
                                     against: MockData.antriksh,
                                     minute: 32),
                                Goal(id: IdUtils.newUuid,
                                     scorer: MockData.antriksh,
                                     against: MockData.neeraj,
                                     minute: 75)
                              ],
                              legState: .inProgress)
    
    static var previews: some View {
        Group {
            MatchCellView(participant1: oneLegMatch.participant1,
                          participant2: oneLegMatch.participant2,
                          matchState: oneLegMatch.matchState,
                          winner: oneLegMatch.winner,
                          endedInATie: oneLegMatch.endedInATie)
            MatchCellView(participant1: oneLegMatch.participant1,
                          participant2: oneLegMatch.participant2,
                          matchState: oneLegMatch.matchState,
                          winner: oneLegMatch.winner,
                          endedInATie: oneLegMatch.endedInATie)
                .preferredColorScheme(.dark)
        }
    }
}
