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
    
    let leg: MatchLeg
    
    var body: some View {
        HStack {
            HStack {
                leadingImage(for: leg.homeParticipant)
                Text(leg.homeParticipant.playerName)
                    .font(.title3)
            }
            Spacer()
            Text("vs")
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
            HStack {
                leadingImage(for: leg.awayParticipant)
                Text(leg.awayParticipant.playerName)
                    .font(.title3)
                    .frame(alignment: .trailing)
            }
        }
        .padding()
        .background(backgroundColor)
        .overlay(matchCellShape.strokeBorder(.quaternary, lineWidth: 1))
    }
    
    private var backgroundColor: Color {
        if leg.legState == .completed {
            return .green.opacity(0.30)
        } else {
            return colorScheme == .light ? .white : .black
        }
    }
    
    @ViewBuilder
    private func leadingImage(for participant: Participant) -> some View {
        if leg.winner == participant {
            Image(systemName: "star.fill")
        } else if leg.endedInATie {
            Image(systemName: "circle.fill")
        } else {
            EmptyView()
        }
    }
}

struct LegsCellView_Previews: PreviewProvider {
    private static let leg = MatchLeg(homeParticipant: MockData.antriksh, awayParticipant: MockData.neeraj)
    
    static var previews: some View {
        LegsCellView(leg: leg)
    }
}
