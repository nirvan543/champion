//
//  LegsCellView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/16/22.
//

import SwiftUI

struct LegsCellView: View {
    @Environment(\.colorScheme) var colorScheme
    private let matchCellShape = Rectangle()
    
    let homeParticipant: Participant
    let awayParticipant: Participant
    let legState: GameState
    let winner: Participant?
    let endedInATie: Bool
    
    var body: some View {
        HStack {
            HStack {
                leadingImage(for: homeParticipant)
                Text(homeParticipant.playerName)
                    .font(.title3)
            }
            Spacer()
            Text("vs")
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
            HStack {
                leadingImage(for: awayParticipant)
                Text(awayParticipant.playerName)
                    .font(.title3)
                    .frame(alignment: .trailing)
            }
        }
        .padding()
        .background(backgroundColor)
        .overlay(matchCellShape.strokeBorder(.quaternary, lineWidth: 1))
    }
    
    private var backgroundColor: Color {
        if legState == .completed {
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

struct LegsCellView_Previews: PreviewProvider {
    private static let leg = MatchLeg(homeParticipant: MockData.antriksh, awayParticipant: MockData.neeraj)
    
    static var previews: some View {
        LegsCellView(homeParticipant: leg.homeParticipant,
                     awayParticipant: leg.awayParticipant,
                     legState: leg.legState,
                     winner: leg.winner,
                     endedInATie: leg.endedInATie)
    }
}
