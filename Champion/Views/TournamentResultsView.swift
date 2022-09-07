//
//  TournamentResultsView.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/6/22.
//

import SwiftUI

struct TournamentResultsView: View {
    @EnvironmentObject private var environmentValues: EnvironmentValues
    
    let results: TournamentResults
    let revistingResults: Bool
    
    var body: some View {
        TabView {
            TournamentResultRankView(rank: 1, stats: results.firstPlace)
            TournamentResultRankView(rank: 2, stats: results.secondPlace)
            if let thirdPlace = results.thirdPlace {
                TournamentResultRankView(rank: 3, stats: thirdPlace)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(shouldShowCheckmark)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if shouldShowCheckmark {
                    Button {
                        environmentValues.selectedTournamentId = nil
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
    
    private var shouldShowCheckmark: Bool {
        revistingResults == false
    }
}

struct TournamentResultRankView: View {
    let rank: Int
    let stats: ParticipantStats
    
    var body: some View {
        VStack {
            HStack {
                Text("\(rank)")
                    .font(.system(size: 300))
                    .minimumScaleFactor(0.01)
                VStack {
                    Text(placementSuffix)
                        .font(.system(size: 100))
                        .minimumScaleFactor(0.01)
                }
            }
            
            Text(stats.participant.playerName)
                .font(.system(size: 50))
                .minimumScaleFactor(0.01)
        }
    }
    
    private var placementSuffix: String {
        if rank == 1 {
            return "st"
        } else if rank == 2 {
            return "nd"
        } else if rank == 3 {
            return "rd"
        } else {
            fatalError("Unrecognized rank: \(rank)")
        }
    }
}

struct TournamentResultsView_Previews: PreviewProvider {
    @StateObject private static var environmentValues = EnvironmentValues(tournaments: MockTournamentRepository.shared.retreiveTournaments())
    
    private static let results = TournamentResults(stats: [
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
    
    static var previews: some View {
        NavigationView {
            TournamentResultsView(results: results, revistingResults: false)
                .environmentObject(environmentValues)
        }
    }
}
