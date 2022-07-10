//
//  MatchesView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct MatchesView: View {
    let roundRobinStage: RoundRobinStage
    
    private let matchCellShape = Rectangle()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 42) {
                ForEach(Array(roundRobinStage.rounds.enumerated()), id: \.element) { index, round in
                    PageSection(headerText: "Round \(index + 1)") {
                        VStack {
                            ForEach(round.fixtures) { fixture in
                                HStack {
                                    Text(fixture.participant1.playerName)
                                        .font(.title3)
                                    Spacer()
                                    Text("vs")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text(fixture.participant2.playerName)
                                        .font(.title3)
                                        .frame(alignment: .trailing)
                                }
                                .padding()
                                .background()
                                .overlay(matchCellShape.strokeBorder(.quaternary, lineWidth: 1))
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(DesignValues.pageColor.ignoresSafeArea())
        .navigationTitle("Matches")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MatchesView_Previews: PreviewProvider {
    static let roundRobinStage = TestData.roundRobinStage
    
    static var previews: some View {
        Group {
            NavigationView {
                MatchesView(roundRobinStage: roundRobinStage)
            }
            NavigationView {
                MatchesView(roundRobinStage: roundRobinStage)
            }
            .preferredColorScheme(.dark)
        }
    }
}
