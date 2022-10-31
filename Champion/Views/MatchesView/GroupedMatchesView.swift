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
            RoundsView(rounds: groups[groupIndex].rounds)
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
}

struct GroupedMatchesView_Previews: PreviewProvider {
    static var previews: some View {
        GroupedMatchesView(groups: MockData.groups)
    }
}
