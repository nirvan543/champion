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
    static let atlantaCup3 = RoundRobinTournament(
        name: "FIFA 22 Atlanta Cup III",
        date: DateUtils.date(year: 2022, month: .july, day: 16)!,
        fifaVersionName: "FIFA 22",
        participants: participants,
        state: .created,
        rounds: rounds,
        legsPerMatch: 1,
        matchesPerOpponent: 1
    )
    
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
            Match(participant1: mckenzie, participant2: aditya, legsPerMatch: 1),
            Match(participant1: antriksh, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: antriksh, participant2: keerti, legsPerMatch: 1),
            Match(participant1: aditya, participant2: matteo, legsPerMatch: 1),
            Match(participant1: harshit, participant2: mckenzie, legsPerMatch: 1),
            Match(participant1: saurav, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: saurav, participant2: aditya, legsPerMatch: 1),
            Match(participant1: mckenzie, participant2: antriksh, legsPerMatch: 1),
            Match(participant1: matteo, participant2: harshit, legsPerMatch: 1),
            Match(participant1: keerti, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: mckenzie, participant2: keerti, legsPerMatch: 1),
            Match(participant1: saurav, participant2: harshit, legsPerMatch: 1),
            Match(participant1: matteo, participant2: antriksh, legsPerMatch: 1),
            Match(participant1: aditya, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: harshit, participant2: aditya, legsPerMatch: 1),
            Match(participant1: keerti, participant2: matteo, legsPerMatch: 1),
            Match(participant1: antriksh, participant2: saurav, legsPerMatch: 1),
            Match(participant1: mckenzie, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: matteo, participant2: mckenzie, legsPerMatch: 1),
            Match(participant1: aditya, participant2: antriksh, legsPerMatch: 1),
            Match(participant1: saurav, participant2: keerti, legsPerMatch: 1),
            Match(participant1: harshit, participant2: nil, legsPerMatch: 1)
        ]),
        Round(matches: [
            Match(participant1: antriksh, participant2: harshit, legsPerMatch: 1),
            Match(participant1: mckenzie, participant2: saurav, legsPerMatch: 1),
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
        mckenzie,
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
    
    static let keerti = Participant(
        id: IdUtils.newUuid,
        playerName: "Keerthi",
        teamName: "Paris SG"
    )
    
    static let saurav = Participant(
        id: IdUtils.newUuid,
        playerName: "Saurav",
        teamName: "FC Barcelona"
    )
    
    static let matteo = Participant(
        id: IdUtils.newUuid,
        playerName: "Matteo",
        teamName: "Juventus"
    )
    
    static let aditya = Participant(
        id: IdUtils.newUuid,
        playerName: "Aditya",
        teamName: "Liverpool"
    )
    
    static let harshit = Participant(
        id: IdUtils.newUuid,
        playerName: "Harshit",
        teamName: "Manchester City"
    )
    
    static let mckenzie = Participant(
        id: IdUtils.newUuid,
        playerName: "McKenzie",
        teamName: "Liverpool"
    )
    
    static let antriksh = Participant(
        id: IdUtils.newUuid,
        playerName: "Nirvan",
        teamName: "Paris SG"
    )
    
    static let pranshu = Participant(
        id: IdUtils.newUuid,
        playerName: "Pranshu",
        teamName: "Paris SG"
    )
    
    static let mahendra = Participant(
        id: IdUtils.newUuid,
        playerName: "Mahendra",
        teamName: "Real Madrid"
    )
    
    static let mookie = Participant(
        id: IdUtils.newUuid,
        playerName: "Mookie",
        teamName: "Manchester City"
    )
    
    static let dylan = Participant(
        id: IdUtils.newUuid,
        playerName: "Dylan",
        teamName: "Chelsea"
    )
    
    static let rohan = Participant(
        id: IdUtils.newUuid,
        playerName: "Rohan",
        teamName: "Real Madrid"
    )
    static let tarun = Participant(
        id: IdUtils.newUuid,
        playerName: "Tarun",
        teamName: "Paris SG"
    )
    
    static let neeraj = Participant(
        id: IdUtils.newUuid,
        playerName: "Neeraj",
        teamName: "Manchester City"
    )
    
    static let siddhant = Participant(
        id: IdUtils.newUuid,
        playerName: "Siddhant",
        teamName: "FC Bayern Munchen"
    )
    
    static let ovi = Participant(
        id: IdUtils.newUuid,
        playerName: "Ovi",
        teamName: "FC Barcelona"
    )
}
