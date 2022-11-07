//
//  MockData.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/15/22.
//

import Foundation

struct MockData {
    static let tournaments: [any Tournament] = [
        atlantaCup3,
        proWorldCup4
    ]
    
    // MARK: Tournaments
    static let atlantaCup3 = RoundRobinTournament(name: "FIFA 22 Atlanta Cup III",
                                                  date: DateUtils.date(year: 2022, month: .july, day: 16)!,
                                                  fifaVersionName: "FIFA 22",
                                                  participants: participants,
                                                  state: .created,
                                                  rounds: rounds,
                                                  legsPerMatch: 1)
    
    static let proWorldCup4 = GroupedTournament(name: "FIFA Pro World Cup IV",
                                                date: DateUtils.date(year: 2022, month: .november, day: 12)!,
                                                fifaVersionName: "FIFA 23",
                                                participants: groupTournamentParticipants,
                                                state: .created,
                                                groups: groups,
                                                legsPerMatch: 1)
    
    // MARK: Rounds
    // Round Robin Rounds
    static let rounds = [
        round1,
        round2,
        round3,
        round4,
        round5,
        round6,
        round7,
        round8,
        round9
    ]
    
    static let round1 = Round(matches: [
        Match(participant1: saurav, participant2: pranshu, legsPerMatch: 1),
        Match(participant1: mookie, participant2: siddhant, legsPerMatch: 1),
        Match(participant1: aditya, participant2: antriksh, legsPerMatch: 1),
        Match(participant1: ovi, participant2: neeraj, legsPerMatch: 1),
        Match(participant1: mahendra, participant2: keerti, legsPerMatch: 1)
    ])
    
    static let round2 = Round(matches: [
        Match(participant1: pranshu, participant2: ovi, legsPerMatch: 1),
        Match(participant1: mookie, participant2: saurav, legsPerMatch: 1),
        Match(participant1: keerti, participant2: antriksh, legsPerMatch: 1),
        Match(participant1: siddhant, participant2: mahendra, legsPerMatch: 1),
        Match(participant1: neeraj, participant2: aditya, legsPerMatch: 1)
        
    ])
    
    static let round3 = Round(matches: [
        Match(participant1: aditya, participant2: ovi, legsPerMatch: 1),
        Match(participant1: pranshu, participant2: mookie, legsPerMatch: 1),
        Match(participant1: mahendra, participant2: saurav, legsPerMatch: 1),
        Match(participant1: keerti, participant2: neeraj, legsPerMatch: 1),
        Match(participant1: antriksh, participant2: siddhant, legsPerMatch: 1),
    ])
    
    static let round4 = Round(matches: [
        Match(participant1: aditya, participant2: pranshu, legsPerMatch: 1),
        Match(participant1: siddhant, participant2: neeraj, legsPerMatch: 1),
        Match(participant1: saurav, participant2: antriksh, legsPerMatch: 1),
        Match(participant1: ovi, participant2: keerti, legsPerMatch: 1),
        Match(participant1: mookie, participant2: mahendra, legsPerMatch: 1)
    ])
    
    static let round5 = Round(matches: [
        Match(participant1: mahendra, participant2: pranshu, legsPerMatch: 1),
        Match(participant1: siddhant, participant2: ovi, legsPerMatch: 1),
        Match(participant1: keerti, participant2: aditya, legsPerMatch: 1),
        Match(participant1: antriksh, participant2: mookie, legsPerMatch: 1),
        Match(participant1: neeraj, participant2: saurav, legsPerMatch: 1)
    ])
    
    static let round6 = Round(matches: [
        Match(participant1: saurav, participant2: ovi, legsPerMatch: 1),
        Match(participant1: aditya, participant2: siddhant, legsPerMatch: 1),
        Match(participant1: mookie, participant2: neeraj, legsPerMatch: 1),
        Match(participant1: antriksh, participant2: mahendra, legsPerMatch: 1),
        Match(participant1: pranshu, participant2: keerti, legsPerMatch: 1),
    ])
    
    static let round7 = Round(matches: [
        Match(participant1: ovi, participant2: mookie, legsPerMatch: 1),
        Match(participant1: saurav, participant2: aditya, legsPerMatch: 1),
        Match(participant1: neeraj, participant2: mahendra, legsPerMatch: 1),
        Match(participant1: siddhant, participant2: keerti, legsPerMatch: 1),
        Match(participant1: pranshu, participant2: antriksh, legsPerMatch: 1)
    ])
    
    static let round8 = Round(matches: [
        Match(participant1: siddhant, participant2: pranshu, legsPerMatch: 1),
        Match(participant1: antriksh, participant2: neeraj, legsPerMatch: 1),
        Match(participant1: keerti, participant2: saurav, legsPerMatch: 1),
        Match(participant1: mahendra, participant2: ovi, legsPerMatch: 1),
        Match(participant1: mookie, participant2: aditya, legsPerMatch: 1)
    ])
    
    static let round9 = Round(matches: [
        Match(participant1: neeraj, participant2: pranshu, legsPerMatch: 1),
        Match(participant1: aditya, participant2: mahendra, legsPerMatch: 1),
        Match(participant1: mookie, participant2: keerti, legsPerMatch: 1),
        Match(participant1: ovi, participant2: antriksh, legsPerMatch: 1),
        Match(participant1: saurav, participant2: siddhant, legsPerMatch: 1)
    ])
    
    // Groupd Rounds
    static let groups = [
        groupA,
        groupB
    ]
    static let groupA = TournamentGroup(participants: groupAParticipants, rounds: groupARounds)
    static let groupB = TournamentGroup(participants: groupBParticipants, rounds: groupBRounds)
    
    static let groupARounds = [
        Round(matches: [
            Match(participant1: matteo, participant2: saurav, legsPerMatch: 1),
            Match(participant1: keerti, participant2: harshit, legsPerMatch: 1),
            Match(participant1: solo, participant2: aditya, legsPerMatch: 1),
            Match(participant1: antriksh, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: antriksh, participant2: keerti, legsPerMatch: 1),
            Match(participant1: aditya, participant2: matteo, legsPerMatch: 1),
            Match(participant1: harshit, participant2: solo, legsPerMatch: 1),
            Match(participant1: saurav, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: saurav, participant2: aditya, legsPerMatch: 1),
            Match(participant1: solo, participant2: antriksh, legsPerMatch: 1),
            Match(participant1: matteo, participant2: harshit, legsPerMatch: 1),
            Match(participant1: keerti, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: solo, participant2: keerti, legsPerMatch: 1),
            Match(participant1: saurav, participant2: harshit, legsPerMatch: 1),
            Match(participant1: matteo, participant2: antriksh, legsPerMatch: 1),
            Match(participant1: aditya, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: harshit, participant2: aditya, legsPerMatch: 1),
            Match(participant1: keerti, participant2: matteo, legsPerMatch: 1),
            Match(participant1: antriksh, participant2: saurav, legsPerMatch: 1),
            Match(participant1: solo, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: matteo, participant2: solo, legsPerMatch: 1),
            Match(participant1: aditya, participant2: antriksh, legsPerMatch: 1),
            Match(participant1: saurav, participant2: keerti, legsPerMatch: 1),
            Match(participant1: harshit, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: antriksh, participant2: harshit, legsPerMatch: 1),
            Match(participant1: solo, participant2: saurav, legsPerMatch: 1),
            Match(participant1: keerti, participant2: aditya, legsPerMatch: 1),
            Match(participant1: matteo, participant2: nil, legsPerMatch: 1)
        ])
    ]
    
    static let groupBRounds = [
        Round(matches: [
            Match(participant1: mookie, participant2: rohan, legsPerMatch: 1),
            Match(participant1: mahendra, participant2: pranshu, legsPerMatch: 1),
            Match(participant1: tarun, participant2: dylan, legsPerMatch: 1),
            Match(participant1: neeraj, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: neeraj, participant2: mahendra, legsPerMatch: 1),
            Match(participant1: dylan, participant2: mookie, legsPerMatch: 1),
            Match(participant1: pranshu, participant2: tarun, legsPerMatch: 1),
            Match(participant1: rohan, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: rohan, participant2: dylan, legsPerMatch: 1),
            Match(participant1: tarun, participant2: neeraj, legsPerMatch: 1),
            Match(participant1: mookie, participant2: pranshu, legsPerMatch: 1),
            Match(participant1: mahendra, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: tarun, participant2: mahendra, legsPerMatch: 1),
            Match(participant1: rohan, participant2: pranshu, legsPerMatch: 1),
            Match(participant1: mookie, participant2: neeraj, legsPerMatch: 1),
            Match(participant1: dylan, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: pranshu, participant2: dylan, legsPerMatch: 1),
            Match(participant1: mahendra, participant2: mookie, legsPerMatch: 1),
            Match(participant1: neeraj, participant2: rohan, legsPerMatch: 1),
            Match(participant1: tarun, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: mookie, participant2: tarun, legsPerMatch: 1),
            Match(participant1: dylan, participant2: neeraj, legsPerMatch: 1),
            Match(participant1: rohan, participant2: mahendra, legsPerMatch: 1),
            Match(participant1: pranshu, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: neeraj, participant2: pranshu, legsPerMatch: 1),
            Match(participant1: tarun, participant2: rohan, legsPerMatch: 1),
            Match(participant1: mahendra, participant2: dylan, legsPerMatch: 1),
            Match(participant1: mookie, participant2: nil, legsPerMatch: 1)
        ])
    ]
    
    // MARK: Participants
    // Round Robin Participants
    static let participants = [
        neeraj,
        saurav,
        mookie,
        antriksh,
        ovi,
        mahendra,
        pranshu,
        siddhant,
        keerti,
        aditya
    ]
    
    // Group Tournament Participants
    static let groupTournamentParticipants = groupAParticipants + groupBParticipants
    static let groupAParticipants = [
        keerti,
        saurav,
        matteo,
        aditya,
        harshit,
        solo,
        antriksh
    ]
    static let groupBParticipants = [
        pranshu,
        mahendra,
        mookie,
        dylan,
        rohan,
        tarun,
        neeraj
    ]
    
    static let keerti = Participant(id: IdUtils.newUuid,
                                    playerName: "Keerthi",
                                    clubSelection: ClubSelection(clubName: "Paris SG",
                                                                 leagueName: "LIGUE 1 UBER EATS",
                                                                 clubAssociation: "FRANCE"))
    static let saurav = Participant(id: IdUtils.newUuid,
                                    playerName: "Saurav",
                                    clubSelection: ClubSelection(clubName: "FC Barcelona",
                                                                 leagueName: "LALIGA SANTANDER",
                                                                 clubAssociation: "SPAIN"))
    static let matteo = Participant(id: IdUtils.newUuid,
                                    playerName: "Matteo",
                                    clubSelection: ClubSelection(clubName: "Juventus",
                                                                 leagueName: "SERIE A TIM",
                                                                 clubAssociation: "ITALY"))
    static let aditya = Participant(id: IdUtils.newUuid,
                                    playerName: "Aditya",
                                    clubSelection: ClubSelection(clubName: "Liverpool",
                                                                 leagueName: "PREMIER LEAGUE",
                                                                 clubAssociation: "ENGLAND"))
    static let harshit = Participant(id: IdUtils.newUuid,
                                     playerName: "Harshit",
                                     clubSelection: ClubSelection(clubName: "Manchester City",
                                                                  leagueName: "PREMIER LEAGUE",
                                                                  clubAssociation: "ENGLAND"))
    static let solo = Participant(id: IdUtils.newUuid,
                                  playerName: "Solo",
                                  clubSelection: ClubSelection(clubName: "Atlético de Madrid",
                                                               leagueName: "LALIGA SANTANDER",
                                                               clubAssociation: "SPAIN"))
    static let antriksh = Participant(id: IdUtils.newUuid,
                                      playerName: "Nirvan",
                                      clubSelection: ClubSelection(clubName: "Paris SG",
                                                                   leagueName: "LIGUE 1 UBER EATS",
                                                                   clubAssociation: "FRANCE"))
    static let pranshu = Participant(id: IdUtils.newUuid,
                                     playerName: "Pranshu",
                                     clubSelection: ClubSelection(clubName: "Paris SG",
                                                                  leagueName: "LIGUE 1 UBER EATS",
                                                                  clubAssociation: "FRANCE"))
    static let mahendra = Participant(id: IdUtils.newUuid,
                                      playerName: "Mahendra",
                                      clubSelection: ClubSelection(clubName: "Real Madrid",
                                                                   leagueName: "LALIGA SANTANDER",
                                                                   clubAssociation: "SPAIN"))
    static let mookie = Participant(id: IdUtils.newUuid,
                                    playerName: "Mookie",
                                    clubSelection: ClubSelection(clubName: "Manchester City",
                                                                 leagueName: "PREMIER LEAGUE",
                                                                 clubAssociation: "ENGLAND"))
    static let dylan = Participant(id: IdUtils.newUuid,
                                   playerName: "Dylan",
                                   clubSelection: ClubSelection(clubName: "Chelsea",
                                                                leagueName: "PREMIER LEAGUE",
                                                                clubAssociation: "ENGLAND"))
    static let rohan = Participant(id: IdUtils.newUuid,
                                   playerName: "Rohan",
                                   clubSelection: ClubSelection(clubName: "Real Madrid",
                                                                leagueName: "LALIGA SANTANDER",
                                                                clubAssociation: "SPAIN"))
    static let tarun = Participant(id: IdUtils.newUuid,
                                   playerName: "Tarun",
                                   clubSelection: ClubSelection(clubName: "Paris SG",
                                                                leagueName: "LIGUE 1 UBER EATS",
                                                                clubAssociation: "FRANCE"))
    static let neeraj = Participant(id: IdUtils.newUuid,
                                    playerName: "Neeraj",
                                    clubSelection: ClubSelection(clubName: "Manchester City",
                                                                 leagueName: "PREMIER LEAGUE",
                                                                 clubAssociation: "ENGLAND"))
    static let siddhant = Participant(id: IdUtils.newUuid,
                                      playerName: "Siddhant",
                                      clubSelection: ClubSelection(clubName: "FC Bayern Munchen",
                                                                   leagueName: "Bundesliga",
                                                                   clubAssociation: "Germany"))
    static let ovi = Participant(id: IdUtils.newUuid,
                                 playerName: "Ovi",
                                 clubSelection: ClubSelection(clubName: "FC Barcelona",
                                                              leagueName: "LaLiga",
                                                              clubAssociation: "Spain"))
}
