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
                   participants: TestData.participants,
                   roundRobinStage: roundRobinStage,
                   knockoutStage: KnockoutStage(playoffSpots: 4, legsPerMatch: 2, finalLegsPerMatch: 1, rounds: [])),
        Tournament(id: IdUtils.newUuid,
                   name: "FIFA 22 Atlanta Cup II",
                   date: DateUtils.date(year: 2022, month: .february, day: 19)!,
                   type: .roundRobinAndKnockout,
                   participants: TestData.participants,
                   roundRobinStage: RoundRobinStage(matchesPerOpponent: 1, legsPerMatch: 1, rounds: [
                    Round(fixtures: [
                        Match(id: IdUtils.newUuid,
                              participant1: TestData.participants[0],
                              participant2: TestData.participants[1],
                              legs: [
                                MatchLeg(homeParticipant: TestData.participants[0],
                                         awayParticipant: TestData.participants[1])
                              ])
                    ])
                   ]),
                   knockoutStage: KnockoutStage(playoffSpots: 4, legsPerMatch: 2, finalLegsPerMatch: 1, rounds: [])),
        Tournament(id: IdUtils.newUuid,
                   name: "FIFA 22 Atlanta Cup III",
                   date: DateUtils.date(year: 2022, month: .july, day: 16)!,
                   type: .roundRobinAndKnockout,
                   participants: TestData.participants,
                   roundRobinStage: RoundRobinStage(matchesPerOpponent: 1, legsPerMatch: 1, rounds: [
                    Round(fixtures: [
                        Match(id: IdUtils.newUuid,
                              participant1: TestData.participants[0],
                              participant2: TestData.participants[1],
                              legs: [
                                MatchLeg(homeParticipant: TestData.participants[0],
                                         awayParticipant: TestData.participants[1])
                              ])
                    ])
                   ]),
                   knockoutStage: KnockoutStage(playoffSpots: 4, legsPerMatch: 2, finalLegsPerMatch: 1, rounds: []))
    ]
    
    static let roundRobinStage = RoundRobinStage(matchesPerOpponent: 1, legsPerMatch: 1, rounds: [
        Round(fixtures: [
            Match(id: IdUtils.newUuid,
                  participant1: TestData.participants[0],
                  participant2: TestData.participants[1],
                  legs: [
                    MatchLeg(homeParticipant: TestData.participants[0],
                             awayParticipant: TestData.participants[1])
                  ]),
            Match(id: IdUtils.newUuid,
                  participant1: TestData.participants[2],
                  participant2: TestData.participants[3],
                  legs: [
                    MatchLeg(homeParticipant: TestData.participants[2],
                             awayParticipant: TestData.participants[3])
                  ]),
            Match(id: IdUtils.newUuid,
                  participant1: TestData.participants[4],
                  participant2: TestData.participants[5],
                  legs: [
                    MatchLeg(homeParticipant: TestData.participants[4],
                             awayParticipant: TestData.participants[5])
                  ]),
            Match(id: IdUtils.newUuid,
                  participant1: TestData.participants[6],
                  participant2: TestData.participants[7],
                  legs: [
                    MatchLeg(homeParticipant: TestData.participants[6],
                             awayParticipant: TestData.participants[7])
                  ]),
            Match(id: IdUtils.newUuid,
                  participant1: TestData.participants[8],
                  participant2: TestData.participants[9],
                  legs: [
                    MatchLeg(homeParticipant: TestData.participants[8],
                             awayParticipant: TestData.participants[9])
                  ])
        ]),
        Round(fixtures: [
            Match(id: IdUtils.newUuid,
                  participant1: TestData.participants[0],
                  participant2: TestData.participants[2],
                  legs: [
                    MatchLeg(homeParticipant: TestData.participants[0],
                             awayParticipant: TestData.participants[2])
                  ]),
            Match(id: IdUtils.newUuid,
                  participant1: TestData.participants[1],
                  participant2: TestData.participants[3],
                  legs: [
                    MatchLeg(homeParticipant: TestData.participants[1],
                             awayParticipant: TestData.participants[3])
                  ]),
            Match(id: IdUtils.newUuid,
                  participant1: TestData.participants[4],
                  participant2: TestData.participants[6],
                  legs: [
                    MatchLeg(homeParticipant: TestData.participants[4],
                             awayParticipant: TestData.participants[6])
                  ]),
            Match(id: IdUtils.newUuid,
                  participant1: TestData.participants[9],
                  participant2: TestData.participants[5],
                  legs: [
                    MatchLeg(homeParticipant: TestData.participants[9],
                             awayParticipant: TestData.participants[5])
                  ]),
            Match(id: IdUtils.newUuid,
                  participant1: TestData.participants[7],
                  participant2: TestData.participants[8],
                  legs: [
                    MatchLeg(homeParticipant: TestData.participants[7],
                             awayParticipant: TestData.participants[8])
                  ])
        ])
    ])
    
    static let participants = [
        Participant(id: IdUtils.newUuid,
                    playerName: "Neeraj",
                    teamName: "Manchester City",
                    imageName: "man_city_logo"),
        Participant(id: IdUtils.newUuid,
                    playerName: "Saurav",
                    teamName: "FC Barcelona",
                    imageName: "fc_barcelona_logo"),
        Participant(id: IdUtils.newUuid,
                    playerName: "Mookie",
                    teamName: "Liverpool F.C.",
                    imageName: "liverpool_logo"),
        Participant(id: IdUtils.newUuid,
                    playerName: "Antriksh",
                    teamName: "Paris Saint-Germain",
                    imageName: "psg_logo"),
        Participant(id: IdUtils.newUuid,
                    playerName: "Ovi",
                    teamName: "FC Barcelona",
                    imageName: "fc_barcelona_logo"),
        Participant(id: IdUtils.newUuid,
                    playerName: "Mahendra",
                    teamName: "Real Madrid",
                    imageName: "real_madrid_logo"),
        Participant(id: IdUtils.newUuid,
                    playerName: "Pranshu",
                    teamName: "Atletico Madrid",
                    imageName: "atletico_madrid_logo"),
        Participant(id: IdUtils.newUuid,
                    playerName: "Siddhant",
                    teamName: "FC Bayern Munchen",
                    imageName: "fc_bayern_munchen_logo"),
        Participant(id: IdUtils.newUuid,
                    playerName: "Keerthi",
                    teamName: "Paris Saint-Germain",
                    imageName: "psg_logo"),
        Participant(id: IdUtils.newUuid,
                    playerName: "Aditya",
                    teamName: "Liverpool F.C.",
                    imageName: "liverpool_logo"),
    ]
}
