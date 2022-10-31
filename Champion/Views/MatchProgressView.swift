//
//  MatchProgressView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/16/22.
//

import SwiftUI

struct MatchProgressView: View {
    @Binding var match: Match
    
    var body: some View {
        PageView {
            MatchCellView(participant1: match.participant1,
                          participant2: match.participant2,
                          participant1Score: match.participant1Score,
                          participant2Score: match.participant2Score,
                          matchState: match.matchState,
                          winner: match.winner,
                          endedInATie: match.endedInATie)
            
            PageSection("Legs") {
                ForEach(Array($match.legs.enumerated()), id: \.element.wrappedValue.id) { index, leg in
                    NavigationLink {
                        MatchLegProgressView(matchLeg: leg, legNumber: index + 1)
                    } label: {
                        LegsCellView(homeParticipant: leg.wrappedValue.homeParticipant,
                                     awayParticipant: leg.wrappedValue.awayParticipant,
                                     homeScore: leg.wrappedValue.homeScore,
                                     awayScore: leg.wrappedValue.awayScore,
                                     legState: leg.wrappedValue.legState,
                                     winner: leg.wrappedValue.winner,
                                     endedInATie: leg.wrappedValue.endedInATie)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Match")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MatchProgressView_Previews: PreviewProvider {
    @State static var match = Match(id: IdUtils.newUuid,
                                    participant1: MockData.antriksh,
                                    participant2: MockData.neeraj,
                                    legs: [leg1, leg2])
    
    static let leg1 = MatchLeg(id: IdUtils.newUuid,
                               homeParticipant: MockData.antriksh,
                               awayParticipant: MockData.neeraj,
                               goals: [],
                               legState: .inProgress)
    
    static let leg2 = MatchLeg(homeParticipant: MockData.neeraj,
                               awayParticipant: MockData.antriksh)
    
    static var previews: some View {
        NavigationView {
            MatchProgressView(match: $match)
        }
    }
}
