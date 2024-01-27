//
//  TournamentSummaryView.swift
//  Champion
//
//  Created by Nirvan Nagar on 11/1/22.
//

import SwiftUI

struct TournamentSummaryView: View {
    let tournament: any Tournament
    
    var body: some View {
        GeometryReader { geo in
            PageView {
                PageSection("Tournament Standings") {
                    tournamentStandingsTableView(geo: geo)
                }
                
                if let tournament = tournament as? GroupedTournament {
                    groupStandingsTables(tournament: tournament, geo: geo)
                }
                
                PageSection("Top Scorer") {
                    topScorerView
                }
                
                PageSection("Best Defender") {
                    bestDefenderView
                }
                
                /*
                PageSection("Top First Half Scorer") {
                    firstHalfScorer
                }
                
                PageSection("Top Second Half Scorer") {
                    secondHalfScorer
                }
                
                PageSection("Best First Half Defender") {
                    firstHalfDefender
                }
                
                PageSection("Best Second Half Defender") {
                    secondHalfDefender
                }
                */
            }
        }
    }
    
    @ViewBuilder
    private func tournamentStandingsTableView(geo: GeometryProxy) -> some View {
        StandingsView(geo: geo, stats: tournament.tournamentStats)
    }
    
    private func groupStandingsTables(tournament: GroupedTournament, geo: GeometryProxy) -> some View {
        ForEach(Array(tournament.groups.enumerated()), id: \.element.id) { index, group in
            PageSection("Group \(index + 1) Standings") {
                StandingsView(geo: geo, stats: tournament.standingStats(for: index))
            }
        }
    }
    
    private var topScorerView: some View {
        let stats = tournament.tournamentStats.sorted(by: { $0.goalsFor > $1.goalsFor })
        
        return VStack {
            ForEach(stats, id: \.self) { element in
                FormContent(backgroundColor: backgroundColor(firstPlaceValue: stats[0].goalsFor,
                                                             currentValue: element.goalsFor)) {
                    listContent(stat: element, value: element.goalsFor)
                }
            }
        }
    }
    
    private var bestDefenderView: some View {
        let stats = tournament.tournamentStats.sorted(by: { $0.goalsAgainst < $1.goalsAgainst })
        
        return VStack {
            ForEach(stats, id: \.self) { element in
                FormContent(backgroundColor: backgroundColor(firstPlaceValue: stats[0].goalsAgainst,
                                                             currentValue: element.goalsAgainst)) {
                    listContent(stat: element, value: element.goalsAgainst)
                }
            }
        }
    }
    
    /*
    private var firstHalfScorer: some View {
        let stats = tournament.tournamentStats.sorted { stat1, stat2 in
            stat1.goalsForFirstHalf > stat2.goalsForFirstHalf
        }
        
        return VStack {
            ForEach(stats, id: \.self) { element in
                FormContent(backgroundColor: backgroundColor(firstPlaceValue: stats[0].goalsForFirstHalf,
                                                             currentValue: element.goalsForFirstHalf)) {
                    listContent(stat: element, value: element.goalsForFirstHalf)
                }
            }
        }
    }
    
    private var secondHalfScorer: some View {
        let stats = tournament.tournamentStats.sorted { stat1, stat2 in
            stat1.goalsForSecondHalf > stat2.goalsForSecondHalf
        }
        
        return VStack {
            ForEach(stats, id: \.self) { element in
                FormContent(backgroundColor: backgroundColor(firstPlaceValue: stats[0].goalsForSecondHalf,
                                                             currentValue: element.goalsForSecondHalf)) {
                    listContent(stat: element, value: element.goalsForSecondHalf)
                }
            }
        }
    }
    
    private var firstHalfDefender: some View {
        let stats = tournament.tournamentStats.sorted { stat1, stat2 in
            stat1.goalsAgainstFirstHalf < stat2.goalsAgainstFirstHalf
        }
        
        return VStack {
            ForEach(stats, id: \.self) { element in
                FormContent(backgroundColor: backgroundColor(firstPlaceValue: stats[0].goalsAgainstFirstHalf,
                                                             currentValue: element.goalsAgainstFirstHalf)) {
                    listContent(stat: element, value: element.goalsAgainstFirstHalf)
                }
            }
        }
    }
    
    private var secondHalfDefender: some View {
        let stats = tournament.tournamentStats.sorted { stat1, stat2 in
            stat1.goalsAgainstSecondHalf < stat2.goalsAgainstSecondHalf
        }
        
        return VStack {
            ForEach(stats, id: \.self) { element in
                FormContent(backgroundColor: backgroundColor(firstPlaceValue: stats[0].goalsAgainstSecondHalf,
                                                             currentValue: element.goalsAgainstSecondHalf)) {
                    listContent(stat: element, value: element.goalsAgainstSecondHalf)
                }
            }
        }
    }
    */
    
    private func listContent(stat: ParticipantStats, value: Int) -> some View {
        HStack(spacing: 25) {
            VStack(alignment: .leading) {
                Text(stat.participant.playerName)
                    .font(.title3)
                Text(stat.participant.teamName)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\(value)")
                .font(.title2)
                .fontWeight(.semibold)
        }
    }
    
    private func backgroundColor(firstPlaceValue: Int, currentValue: Int) -> Color {
        if currentValue == firstPlaceValue {
            return .gold
        } else {
            return .background
        }
    }
}

struct TournamentSummaryView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            TournamentSummaryView(tournament: MockData.proWorldCup4)
        }
        Group {
            TournamentSummaryView(tournament: MockData.atlantaCup3)
        }
    }
}
