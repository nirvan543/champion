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
    let homeScore: Int
    let awayScore: Int
    let legState: GameState
    let winner: Participant?
    let endedInATie: Bool
    
    var body: some View {
        HStack {
            homeSection
            Spacer()
            Text("vs")
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
            awaySection
        }
        .padding()
        .background(backgroundColor)
        .overlay(matchCellShape.strokeBorder(.quaternary, lineWidth: 1))
    }
    
    private var homeSection: some View {
        HStack {
            leadingImage(for: homeParticipant)
            Text(homeParticipant.playerName)
                .font(.title3)
            if shouldShowScore {
                Text("(\(homeScore))")
            }
        }
    }
    
    private var shouldShowScore: Bool {
        legState == .inProgress || legState == .completed
    }
    
    @ViewBuilder
    private var awaySection: some View {
        HStack {
            leadingImage(for: awayParticipant)
            Text(awayParticipant.playerName)
                .font(.title3)
                .frame(alignment: .trailing)
            if shouldShowScore {
                Text("(\(awayScore))")
            }
        }
    }
    
    private var backgroundColor: Color {
        if legState == .completed {
            return .green.opacity(0.30)
        } else if legState == .inProgress {
            return .yellow.opacity(0.40)
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
                     homeScore: leg.homeScore,
                     awayScore: leg.awayScore,
                     legState: leg.legState,
                     winner: leg.winner,
                     endedInATie: leg.endedInATie)
    }
}
