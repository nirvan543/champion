//
//  StandingsView.swift
//  Champion
//
//  Created by Nirvan Nagar on 8/24/22.
//

import SwiftUI

struct StandingsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let geo: GeometryProxy
    let stats: [ParticipantStats]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyVStack(spacing: 0) {
                HStack(spacing: 5) {
                    headerCell(text: "Rank")
                        .frame(width: playerStatCellWidth(geo: geo))
                    headerCell(text: "Player")
                        .frame(width: playerNameCellWidth(geo: geo))
                    headerCell(text: "Pts")
                        .frame(width: playerStatCellWidth(geo: geo))
                    headerCell(text: "MP")
                        .frame(width: playerStatCellWidth(geo: geo))
                    headerCell(text: "W")
                        .frame(width: playerStatCellWidth(geo: geo))
                    headerCell(text: "D")
                        .frame(width: playerStatCellWidth(geo: geo))
                    headerCell(text: "L")
                        .frame(width: playerStatCellWidth(geo: geo))
                    headerCell(text: "GF")
                        .frame(width: playerStatCellWidth(geo: geo))
                    headerCell(text: "GA")
                        .frame(width: playerStatCellWidth(geo: geo))
                    headerCell(text: "GD")
                        .frame(width: playerStatCellWidth(geo: geo))
                }
                .padding(.vertical, 10)
                .frame(minWidth: geo.size.width)
                
                ForEach(Array(stats.enumerated()), id: \.element) { index, stat in
                    HStack(spacing: 5) {
                        Text("\(index + 1)")
                            .frame(width: playerStatCellWidth(geo: geo))
                        Text(stat.participant.playerName)
                            .frame(width: playerNameCellWidth(geo: geo))
                        Text("\(stat.points)")
                            .frame(width: playerStatCellWidth(geo: geo))
                        Text("\(stat.matchesPlayed)")
                            .frame(width: playerStatCellWidth(geo: geo))
                        Text("\(stat.matchesWon)")
                            .frame(width: playerStatCellWidth(geo: geo))
                        Text("\(stat.matchesTied)")
                            .frame(width: playerStatCellWidth(geo: geo))
                        Text("\(stat.matchesLost)")
                            .frame(width: playerStatCellWidth(geo: geo))
                        Text("\(stat.goalsFor)")
                            .frame(width: playerStatCellWidth(geo: geo))
                        Text("\(stat.goalsAgainst)")
                            .frame(width: playerStatCellWidth(geo: geo))
                        Text("\(gaolDifference(stat.goalsDifference))")
                            .frame(width: playerStatCellWidth(geo: geo))
                    }
                    .padding(.vertical, 10)
                    .background(index % 2 == 0 ? nonClearColor : Color.clear)
                    .frame(minWidth: geo.size.width)
                }
            }
        }
    }
    
    private func gaolDifference(_ goalDifference: Int) -> String {
        let sign = goalDifference > 0 ? "+" : ""
        
        return "\(sign)\(goalDifference)"
    }
    
    private func playerNameCellWidth(geo: GeometryProxy) -> CGFloat {
        return geo.size.width * 0.20
    }
    
    private func playerStatCellWidth(geo: GeometryProxy) -> CGFloat {
        return geo.size.width * 0.11
    }
    
    private func headerCell(text: String) -> some View {
        Text(text)
            .fontWeight(.bold)
    }
    
    private var nonClearColor: Color {
        if colorScheme == .light {
            return Color.white
        } else {
            return Color.gray
        }
    }
}

struct StandingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GeometryReader { geo in
                StandingsView(geo: geo, stats: [
                    ParticipantStats(participant: Participant(id: IdUtils.newUuid,
                                                              playerName: "Mahendra",
                                                              teamName: "Real Madrid",
                                                              imageName: ""),
                                     matchesWon: 5,
                                     matchesTied: 2,
                                     matchesLost: 1,
                                     goalsFor: 15,
                                     goalsAgainst: 10),
                    ParticipantStats(participant: Participant(id: IdUtils.newUuid,
                                                              playerName: "Saurav",
                                                              teamName: "Barcelona",
                                                              imageName: ""),
                                     matchesWon: 4,
                                     matchesTied: 3,
                                     matchesLost: 1,
                                     goalsFor: 17,
                                     goalsAgainst: 11),
                    ParticipantStats(participant: Participant(id: IdUtils.newUuid,
                                                              playerName: "Nirvan",
                                                              teamName: "PSG",
                                                              imageName: ""),
                                     matchesWon: 6,
                                     matchesTied: 0,
                                     matchesLost: 2,
                                     goalsFor: 20,
                                     goalsAgainst: 9)
                ])
            }
            GeometryReader { geo in
                StandingsView(geo: geo, stats: [
                    ParticipantStats(participant: Participant(id: IdUtils.newUuid,
                                                              playerName: "Mahendra",
                                                              teamName: "Real Madrid",
                                                              imageName: ""),
                                     matchesWon: 5,
                                     matchesTied: 2,
                                     matchesLost: 1,
                                     goalsFor: 15,
                                     goalsAgainst: 10),
                    ParticipantStats(participant: Participant(id: IdUtils.newUuid,
                                                              playerName: "Saurav",
                                                              teamName: "Barcelona",
                                                              imageName: ""),
                                     matchesWon: 4,
                                     matchesTied: 3,
                                     matchesLost: 1,
                                     goalsFor: 17,
                                     goalsAgainst: 11),
                    ParticipantStats(participant: Participant(id: IdUtils.newUuid,
                                                              playerName: "Nirvan",
                                                              teamName: "PSG",
                                                              imageName: ""),
                                     matchesWon: 6,
                                     matchesTied: 0,
                                     matchesLost: 2,
                                     goalsFor: 20,
                                     goalsAgainst: 9)
                ])
            }
            .preferredColorScheme(.dark)
        }
    }
}
