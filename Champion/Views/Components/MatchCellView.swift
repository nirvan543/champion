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
    
    let match: Match
    
    var body: some View {
        HStack {
            HStack {
                leadingImage(for: match.participant1)
                Text(match.participant1.playerName)
                    .font(.title3)
            }
            Spacer()
            Text("vs")
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
            HStack {
                leadingImage(for: match.participant2)
                Text(match.participant2.playerName)
                    .font(.title3)
                    .frame(alignment: .trailing)
            }
        }
        .padding()
        .background(backgroundColor)
        .overlay(matchCellShape.strokeBorder(.quaternary, lineWidth: 1))
    }
    
    private var backgroundColor: Color {
        if match.matchState == .completed {
            return .green.opacity(0.30)
        } else {
            return colorScheme == .light ? .white : .black
        }
    }
    
    @ViewBuilder
    private func leadingImage(for participant: Participant) -> some View {
        if match.winner == participant {
            Image(systemName: "star.fill")
        } else if match.endedInATie {
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
            MatchCellView(match: oneLegMatch)
            MatchCellView(match: oneLegMatch)
                .preferredColorScheme(.dark)
            MatchCellView(match: oneLegMatch)
            MatchCellView(match: oneLegMatch)
                .preferredColorScheme(.dark)
        }
    }
}
