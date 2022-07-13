//
//  TournamentRepository.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/8/22.
//

import Foundation
import SwiftUI

class MockTournamentRepository: TournamentRepository {
    
    static let shared = MockTournamentRepository(loadMockData: true)
    
    private var tournaments: [Tournament]
    
    init(loadMockData: Bool = true) {
        tournaments = []
        
        if loadMockData {
            tournaments = loadData()
        }
    }
    
    private func loadData() -> [Tournament] {
        TestData.tournaments
    }
    
    func retreiveTournaments() -> [Tournament] {
        tournaments
    }
    
    func addTournament(tournament: Tournament) {
        tournaments.append(tournament)
    }
    
    func saveTournaments(tournaments: [Tournament]) {
        self.tournaments = tournaments
    }
    
    func retrieveTournamentFormats() -> [TournamentFormat] {
        [
            .roundRobinAndKnockout
        ]
    }
    
    func retrieveImageOptions() -> [String] {
        [
            "atletico_madrid_logo",
            "fc_barcelona_logo",
            "fc_bayern_munchen_logo",
            "liverpool_logo",
            "man_city_logo",
            "psg_logo",
            "real_madrid_logo",
            "fifa_logo"
        ]
    }
}

struct TestData {
    static let tournaments = [
        Tournament(id: IdUtils.newUuid,
                   name: "FIFA 22 Atlanta Cup I",
                   date: DateUtils.date(year: 2021, month: .december, day: 15)!,
                   type: .roundRobinAndKnockout,
                   gameConfig: GameConfig(leagueStageConfig: LeagueStageGameConfig(matchesPerOpponent: 1, legsPerMatch: 1),
                                          knockoutStageConfig: KnockoutStageGameConfig(playoffSpotCount: 4, legsPerMatch: 2)),
                   participants: TestData.participants,
                   roundRobinStage: roundRobinStage,
                   knockoutStage: KnockoutStage(rounds: [])),
        Tournament(id: IdUtils.newUuid,
                   name: "FIFA 22 Atlanta Cup II",
                   date: DateUtils.date(year: 2022, month: .february, day: 19)!,
                   type: .roundRobinAndKnockout,
                   gameConfig: GameConfig(leagueStageConfig: LeagueStageGameConfig(matchesPerOpponent: 1, legsPerMatch: 1),
                                          knockoutStageConfig: KnockoutStageGameConfig(playoffSpotCount: 4, legsPerMatch: 2)),
                   participants: TestData.participants,
                   roundRobinStage: RoundRobinStage(rounds: [
                    Round(id: IdUtils.newUuid, fixtures: [
                        Match(id: IdUtils.newUuid,
                              participant1: TestData.participants[0],
                              participant2: TestData.participants[1],
                              participant1Score: 0,
                              participant2Score: 0)
                    ])
                   ]),
                   knockoutStage: KnockoutStage(rounds: [])),
        Tournament(id: IdUtils.newUuid,
                   name: "FIFA 22 Atlanta Cup III",
                   date: DateUtils.date(year: 2022, month: .july, day: 16)!,
                   type: .roundRobinAndKnockout,
                   gameConfig: GameConfig(leagueStageConfig: LeagueStageGameConfig(matchesPerOpponent: 1, legsPerMatch: 1),
                                          knockoutStageConfig: KnockoutStageGameConfig(playoffSpotCount: 4, legsPerMatch: 2)),
                   participants: TestData.participants,
                   roundRobinStage: RoundRobinStage(rounds: [
                    Round(id: IdUtils.newUuid, fixtures: [
                        Match(id: IdUtils.newUuid,
                              participant1: TestData.participants[0],
                              participant2: TestData.participants[1],
                              participant1Score: 0,
                              participant2Score: 0)
                    ])
                   ]),
                   knockoutStage: KnockoutStage(rounds: []))
    ]
    
    static let roundRobinStage = RoundRobinStage(rounds: [
        Round(id: IdUtils.newUuid,
              fixtures: [
                Match(id: IdUtils.newUuid,
                      participant1: TestData.participants[0],
                      participant2: TestData.participants[1],
                      participant1Score: 0,
                      participant2Score: 0),
                Match(id: IdUtils.newUuid,
                      participant1: TestData.participants[2],
                      participant2: TestData.participants[3],
                      participant1Score: 0,
                      participant2Score: 0),
                Match(id: IdUtils.newUuid,
                      participant1: TestData.participants[4],
                      participant2: TestData.participants[5],
                      participant1Score: 0,
                      participant2Score: 0),
                Match(id: IdUtils.newUuid,
                      participant1: TestData.participants[6],
                      participant2: TestData.participants[7],
                      participant1Score: 0,
                      participant2Score: 0),
                Match(id: IdUtils.newUuid,
                      participant1: TestData.participants[8],
                      participant2: TestData.participants[9],
                      participant1Score: 0,
                      participant2Score: 0)
              ]),
        Round(id: IdUtils.newUuid,
              fixtures: [
                Match(id: IdUtils.newUuid,
                      participant1: TestData.participants[0],
                      participant2: TestData.participants[2],
                      participant1Score: 0,
                      participant2Score: 0),
                Match(id: IdUtils.newUuid,
                      participant1: TestData.participants[1],
                      participant2: TestData.participants[3],
                      participant1Score: 0,
                      participant2Score: 0),
                Match(id: IdUtils.newUuid,
                      participant1: TestData.participants[4],
                      participant2: TestData.participants[6],
                      participant1Score: 0,
                      participant2Score: 0),
                Match(id: IdUtils.newUuid,
                      participant1: TestData.participants[9],
                      participant2: TestData.participants[5],
                      participant1Score: 0,
                      participant2Score: 0),
                Match(id: IdUtils.newUuid,
                      participant1: TestData.participants[7],
                      participant2: TestData.participants[8],
                      participant1Score: 0,
                      participant2Score: 0)
              ])
    ])
    
    static let participants = [
        Participant(id: IdUtils.newUuid,
                    playerName: "Neeraj",
                    teamName: "Manchester City",
                    image: Image("man_city_logo")),
        Participant(id: IdUtils.newUuid,
                    playerName: "Saurav",
                    teamName: "FC Barcelona",
                    image: Image("fc_barcelona_logo")),
        Participant(id: IdUtils.newUuid,
                    playerName: "Mookie",
                    teamName: "Liverpool F.C.",
                    image: Image("liverpool_logo")),
        Participant(id: IdUtils.newUuid,
                    playerName: "Antriksh",
                    teamName: "Paris Saint-Germain",
                    image: Image("psg_logo")),
        Participant(id: IdUtils.newUuid,
                    playerName: "Ovi",
                    teamName: "FC Barcelona",
                    image: Image("fc_barcelona_logo")),
        Participant(id: IdUtils.newUuid,
                    playerName: "Mahendra",
                    teamName: "Real Madrid",
                    image: Image("real_madrid_logo")),
        Participant(id: IdUtils.newUuid,
                    playerName: "Pranshu",
                    teamName: "Atletico Madrid",
                    image: Image("atletico_madrid_logo")),
        Participant(id: IdUtils.newUuid,
                    playerName: "Siddhant",
                    teamName: "FC Bayern Munchen",
                    image: Image("fc_bayern_munchen_logo")),
        Participant(id: IdUtils.newUuid,
                    playerName: "Keerthi",
                    teamName: "Paris Saint-Germain",
                    image: Image("psg_logo")),
        Participant(id: IdUtils.newUuid,
                    playerName: "Aditya",
                    teamName: "Liverpool F.C.",
                    image: Image("liverpool_logo")),
    ]
}
