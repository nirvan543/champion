//
//  GroupedMatchesView.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/26/22.
//

import SwiftUI

struct GroupedMatchesView: View {
    @State private var groupIndex = 0
    
    let groups: [TournamentGroup]
    
    var body: some View {
        PageView {
            groupPicker
            roundsSection
        }
        .navigationTitle("Matches")
        .navigationBarTitleDisplayMode(.inline)
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
}

struct GroupedMatchesView_Previews: PreviewProvider {
    static var previews: some View {
        GroupedMatchesView(groups: MockData.groups)
    }
}
