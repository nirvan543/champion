//
//  StandingsView.swift
//  Champion
//
//  Created by Nirvan Nagar on 8/24/22.
//

import SwiftUI

private enum StandingTableCategory {
    case playerName
    case points
    case matchesPlayed
    case matchesWon
    case matchesDrawn
    case matchesLost
    case goalsFor
    case goalsAgainst
    case goalsDifference
}

struct StandingsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var sortCategory: StandingTableCategory = .points
    @State private var sortDescending: Bool = true
    
    let geo: GeometryProxy
    let stats: [ParticipantStats]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyVStack(spacing: 0) {
                HStack(spacing: 5) {
                    HeaderCell(title: "Rank",
                               width: playerStatCellWidth(geo: geo),
                               showSortIcon: false,
                               descending: sortDescending)
                    HeaderCell(title: "Player",
                               width: playerNameCellWidth(geo: geo),
                               showSortIcon: sortCategory == .playerName,
                               descending: sortDescending)
                        .onTapGesture {
                            setSortOrder(newCategory: .playerName)
                            sortCategory = .playerName
                        }
                    HeaderCell(title: "Pts",
                               width: playerStatCellWidth(geo: geo),
                               showSortIcon: sortCategory == .points,
                               descending: sortDescending)
                        .onTapGesture {
                            setSortOrder(newCategory: .points)
                            sortCategory = .points
                        }
                    HeaderCell(title: "MP",
                               width: playerStatCellWidth(geo: geo),
                               showSortIcon: sortCategory == .matchesPlayed,
                               descending: sortDescending)
                        .onTapGesture {
                            setSortOrder(newCategory: .matchesPlayed)
                            sortCategory = .matchesPlayed
                        }
                    HeaderCell(title: "W",
                               width: playerStatCellWidth(geo: geo),
                               showSortIcon: sortCategory == .matchesWon,
                               descending: sortDescending)
                        .onTapGesture {
                            setSortOrder(newCategory: .matchesWon)
                            sortCategory = .matchesWon
                        }
                    HeaderCell(title: "D",
                               width: playerStatCellWidth(geo: geo),
                               showSortIcon: sortCategory == .matchesDrawn,
                               descending: sortDescending)
                        .onTapGesture {
                            setSortOrder(newCategory: .matchesDrawn)
                            sortCategory = .matchesDrawn
                        }
                    HeaderCell(title: "L",
                               width: playerStatCellWidth(geo: geo),
                               showSortIcon: sortCategory == .matchesLost,
                               descending: sortDescending)
                        .onTapGesture {
                            setSortOrder(newCategory: .matchesLost)
                            sortCategory = .matchesLost
                        }
                    HeaderCell(title: "GF",
                               width: playerStatCellWidth(geo: geo),
                               showSortIcon: sortCategory == .goalsFor,
                               descending: sortDescending)
                        .onTapGesture {
                            setSortOrder(newCategory: .goalsFor)
                            sortCategory = .goalsFor
                        }
                    HeaderCell(title: "GA",
                               width: playerStatCellWidth(geo: geo),
                               showSortIcon: sortCategory == .goalsAgainst,
                               descending: sortDescending)
                        .onTapGesture {
                            setSortOrder(newCategory: .goalsAgainst)
                            sortCategory = .goalsAgainst
                        }
                    HeaderCell(title: "GD",
                               width: playerStatCellWidth(geo: geo),
                               showSortIcon: sortCategory == .goalsDifference,
                               descending: sortDescending)
                        .onTapGesture {
                            setSortOrder(newCategory: .goalsDifference)
                            sortCategory = .goalsDifference
                        }
                }
                .padding(.vertical, 10)
                .frame(minWidth: geo.size.width)
                
                ForEach(Array(statsSorted.enumerated()), id: \.element) { index, stat in
                    HStack(spacing: 5) {
                        DataCell(text: "\(index + 1)", width: playerStatCellWidth(geo: geo))
                        DataCell(text: stat.participant.playerName, width: playerNameCellWidth(geo: geo))
                        DataCell(text: "\(stat.points)", width: playerStatCellWidth(geo: geo))
                        DataCell(text: "\(stat.matchesPlayed)", width: playerStatCellWidth(geo: geo))
                        DataCell(text: "\(stat.matchesWon)", width: playerStatCellWidth(geo: geo))
                        DataCell(text: "\(stat.matchesTied)", width: playerStatCellWidth(geo: geo))
                        DataCell(text: "\(stat.matchesLost)", width: playerStatCellWidth(geo: geo))
                        DataCell(text: "\(stat.goalsFor)", width: playerStatCellWidth(geo: geo))
                        DataCell(text: "\(stat.goalsAgainst)", width: playerStatCellWidth(geo: geo))
                        DataCell(text: "\(gaolDifference(stat.goalsDifference))", width: playerStatCellWidth(geo: geo))
                    }
                    .padding(.vertical, 10)
                    .background(index % 2 == 0 ? nonClearColor : Color.clear)
                    .frame(minWidth: geo.size.width)
                }
            }
        }
    }
    
    private func playerNameCellWidth(geo: GeometryProxy) -> CGFloat {
        return geo.size.width * 0.24
    }
    
    private func playerStatCellWidth(geo: GeometryProxy) -> CGFloat {
        return geo.size.width * 0.15
    }
    
    private var statsSorted: [ParticipantStats] {
        stats.sorted { stat1, stat2 in
            switch sortCategory {
            case .playerName:
                return sortByPlayerName(stat1: stat1, stat2: stat2)
            case .points:
                return sortByPoints(stat1: stat1, stat2: stat2)
            case .matchesPlayed:
                return sortByMatchesPlayed(stat1: stat1, stat2: stat2)
            case .matchesWon:
                return sortByMatchesWon(stat1: stat1, stat2: stat2)
            case .matchesDrawn:
                return sortByMatchesDrawn(stat1: stat1, stat2: stat2)
            case .matchesLost:
                return sortByMatchesLost(stat1: stat1, stat2: stat2)
            case .goalsFor:
                return sortByGoalsFor(stat1: stat1, stat2: stat2)
            case .goalsAgainst:
                return sortByGoalsAgainst(stat1: stat1, stat2: stat2)
            case .goalsDifference:
                return sortByGoalsDifference(stat1: stat1, stat2: stat2)
            }
        }
    }
    
    private func sortByPlayerName(stat1: ParticipantStats, stat2: ParticipantStats) -> Bool {
        if sortDescending {
            return stat1.participant.playerName > stat2.participant.playerName
        } else {
            return stat1.participant.playerName < stat2.participant.playerName
        }
    }
    
    private func sortByPoints(stat1: ParticipantStats, stat2: ParticipantStats) -> Bool {
        if sortDescending {
            return (stat1.points, stat1.goalsDifference) > (stat2.points, stat2.goalsDifference)
        } else {
            return (stat1.points, stat1.goalsDifference) < (stat2.points, stat2.goalsDifference)
        }
    }
    
    private func sortByMatchesPlayed(stat1: ParticipantStats, stat2: ParticipantStats) -> Bool {
        if sortDescending {
            return stat1.matchesPlayed > stat2.matchesPlayed
        } else {
            return stat1.matchesPlayed < stat2.matchesPlayed
        }
    }
    
    private func sortByMatchesWon(stat1: ParticipantStats, stat2: ParticipantStats) -> Bool {
        if sortDescending {
            return stat1.matchesWon > stat2.matchesWon
        } else {
            return stat1.matchesWon < stat2.matchesWon
        }
    }
    
    private func sortByMatchesDrawn(stat1: ParticipantStats, stat2: ParticipantStats) -> Bool {
        if sortDescending {
            return stat1.matchesTied > stat2.matchesTied
        } else {
            return stat1.matchesTied < stat2.matchesTied
        }
    }
    
    private func sortByMatchesLost(stat1: ParticipantStats, stat2: ParticipantStats) -> Bool {
        if sortDescending {
            return stat1.matchesLost > stat2.matchesLost
        } else {
            return stat1.matchesLost < stat2.matchesLost
        }
    }
    
    private func sortByGoalsFor(stat1: ParticipantStats, stat2: ParticipantStats) -> Bool {
        if sortDescending {
            return stat1.goalsFor > stat2.goalsFor
        } else {
            return stat1.goalsFor < stat2.goalsFor
        }
    }
    
    private func sortByGoalsAgainst(stat1: ParticipantStats, stat2: ParticipantStats) -> Bool {
        if sortDescending {
            return stat1.goalsAgainst > stat2.goalsAgainst
        } else {
            return stat1.goalsAgainst < stat2.goalsAgainst
        }
    }
    
    private func sortByGoalsDifference(stat1: ParticipantStats, stat2: ParticipantStats) -> Bool {
        if sortDescending {
            return stat1.goalsDifference > stat2.goalsDifference
        } else {
            return stat1.goalsDifference < stat2.goalsDifference
        }
    }
    
    private func gaolDifference(_ goalDifference: Int) -> String {
        let sign = goalDifference > 0 ? "+" : ""
        
        return "\(sign)\(goalDifference)"
    }
    
    private var nonClearColor: Color {
        if colorScheme == .light {
            return Color.white
        } else {
            return Color.gray
        }
    }
    
    private func setSortOrder(newCategory: StandingTableCategory) {
        if newCategory != sortCategory {
            sortDescending = true
        } else {
            sortDescending.toggle()
        }
    }
}

private struct HeaderCell: View {
    let title: String
    let width: CGFloat
    let showSortIcon: Bool
    let descending: Bool
    
    var body: some View {
        HStack(spacing: 5) {
            Text(title)
                .fontWeight(.bold)
            if showSortIcon {
                Image(systemName: descending ? "chevron.down" : "chevron.up")
                    .foregroundColor(.blue)
            }
        }
        .frame(width: width)
    }
}

private struct DataCell: View {
    let text: String
    let width: CGFloat
    
    var body: some View {
        Text(text)
            .frame(width: width)
    }
}

struct StandingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GeometryReader { geo in
                StandingsView(geo: geo, stats: [
                    ParticipantStats(participant: MockData.mahendra,
                                     matchesWon: 5,
                                     matchesTied: 2,
                                     matchesLost: 1,
                                     goalsFor: 15,
                                     goalsAgainst: 10),
                    ParticipantStats(participant: MockData.saurav,
                                     matchesWon: 4,
                                     matchesTied: 3,
                                     matchesLost: 1,
                                     goalsFor: 17,
                                     goalsAgainst: 11),
                    ParticipantStats(participant: MockData.antriksh,
                                     matchesWon: 6,
                                     matchesTied: 0,
                                     matchesLost: 2,
                                     goalsFor: 20,
                                     goalsAgainst: 9)
                ])
            }
            GeometryReader { geo in
                StandingsView(geo: geo, stats: [
                    ParticipantStats(participant: MockData.mahendra,
                                     matchesWon: 5,
                                     matchesTied: 2,
                                     matchesLost: 1,
                                     goalsFor: 15,
                                     goalsAgainst: 10),
                    ParticipantStats(participant: MockData.saurav,
                                     matchesWon: 4,
                                     matchesTied: 3,
                                     matchesLost: 1,
                                     goalsFor: 17,
                                     goalsAgainst: 11),
                    ParticipantStats(participant: MockData.antriksh,
                                     matchesWon: 6,
                                     matchesTied: 0,
                                     matchesLost: 2,
                                     goalsFor: 20,
                                     goalsAgainst: 9)
                ])
            }
            .preferredColorScheme(.dark)
        }
        .padding(.horizontal)
    }
}
