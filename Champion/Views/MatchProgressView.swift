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
        ScrollView {
            VStack(alignment: .leading, spacing: 42) {
                MatchCellView(participant1: match.participant1,
                              participant2: match.participant2,
                              participant1Score: match.participant1Score,
                              participant2Score: match.participant2Score,
                              matchState: match.matchState,
                              winner: match.winner,
                              endedInATie: match.endedInATie)
                
                PageSection("Legs") {
                    ForEach($match.legs) { leg in
                        NavigationLink {
                            MatchLegProgressView(matchLeg: leg, legNumber: number(for: leg.wrappedValue))
                        } label: {
                            LegsCellView(homeParticipant: leg.wrappedValue.homeParticipant,
                                         awayParticipant: leg.wrappedValue.awayParticipant,
                                         legState: leg.wrappedValue.legState,
                                         winner: leg.wrappedValue.winner,
                                         endedInATie: leg.wrappedValue.endedInATie)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity)
        .background(Design.pageColor.ignoresSafeArea())
        .navigationTitle("Match")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func number(for leg: MatchLeg) -> Int {
        if let index = match.legs.firstIndex(where: { $0 == leg }) {
            return index + 1
        } else {
            fatalError("Expected to find the index for leg: \(leg)")
        }
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
