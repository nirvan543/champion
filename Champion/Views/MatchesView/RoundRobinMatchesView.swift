//
//  MatchesView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct RoundRobinMatchesView: View {
    let rounds: [Round]
    
    var body: some View {
        PageView {
            RoundsView(rounds: rounds)
        }
        .navigationTitle("Matches")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RoundRobinMatchesView_Previews: PreviewProvider {
    static let rounds = MockData.rounds
    
    static var previews: some View {
        Group {
            NavigationView {
                RoundRobinMatchesView(rounds: rounds)
            }
            NavigationView {
                RoundRobinMatchesView(rounds: rounds)
            }
            .preferredColorScheme(.dark)
        }
    }
}
