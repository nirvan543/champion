//
//  MockData.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/15/22.
//

import Foundation

struct MockData {
    // MARK: Tournaments
    static let atlantaCup3 = Tournament(id: IdUtils.newUuid,
                                        name: "FIFA 22 Atlanta Cup III",
                                        participants: participants,
                                        rounds: rounds,
                                        date: DateUtils.date(year: 2022, month: .july, day: 16)!,
                                        state: .created,
                                        type: .roundRobin,
                                        fifaVersionName: "FIFA 22",
                                        manager: RoundRobinTournamentManager(tournamentFormatConfig: RoundRobinTournamentFormatConfig()))
    
    static let tournaments = [
        atlantaCup3
    ]
    
    
    // MARK: Participants
    static let neeraj = Participant(id: IdUtils.newUuid,
                                    playerName: "Neeraj",
                                    clubSelection: ClubSelection(clubName: "Manchester City", leagueName: "EPL", clubAssociation: "England"),
                                    imageName: "man_city_logo")
    
    static let saurav = Participant(id: IdUtils.newUuid,
                                    playerName: "Saurav",
                                    clubSelection: ClubSelection(clubName: "FC Barcelona", leagueName: "LaLiga", clubAssociation: "Spain"),
                                    imageName: "fc_barcelona_logo")
    
    static let mookie = Participant(id: IdUtils.newUuid,
                                    playerName: "Mookie",
                                    clubSelection: ClubSelection(clubName: "Liverpool F.C.", leagueName: "EPL", clubAssociation: "England"),
                                    imageName: "liverpool_logo")
    
    static let antriksh = Participant(id: IdUtils.newUuid,
                                      playerName: "Antriksh",
                                      clubSelection: ClubSelection(clubName: "Paris Saint-Germain", leagueName: "Ligue 1", clubAssociation: "France"),
                                      imageName: "psg_logo")
    
    static let ovi = Participant(id: IdUtils.newUuid,
                                 playerName: "Ovi",
                                 clubSelection: ClubSelection(clubName: "FC Barcelona", leagueName: "LaLiga", clubAssociation: "Spain"),
                                 imageName: "fc_barcelona_logo")
    
    
    static let mahendra = Participant(id: IdUtils.newUuid,
                                      playerName: "Mahendra",
                                      clubSelection: ClubSelection(clubName: "Real Madrid", leagueName: "LaLiga", clubAssociation: "Spain"),
                                      imageName: "real_madrid_logo")
    
    static let pranshu = Participant(id: IdUtils.newUuid,
                                     playerName: "Pranshu",
                                     clubSelection: ClubSelection(clubName: "Ateltico Madrid", leagueName: "LaLiga", clubAssociation: "Spain"),
                                     imageName: "atletico_madrid_logo")
    
    static let siddhant = Participant(id: IdUtils.newUuid,
                                      playerName: "Siddhant",
                                      clubSelection: ClubSelection(clubName: "FC Bayern Munchen", leagueName: "Bundesliga", clubAssociation: "Germany"),
                                      imageName: "fc_bayern_munchen_logo")
    
    static let keerti = Participant(id: IdUtils.newUuid,
                                    playerName: "Keerthi",
                                    clubSelection: ClubSelection(clubName: "Paris Saint-Germain", leagueName: "Ligue 1", clubAssociation: "France"),
                                    imageName: "psg_logo")
    
    static let aditya = Participant(id: IdUtils.newUuid,
                                    playerName: "Aditya",
                                    clubSelection: ClubSelection(clubName: "Liverpool F.C.", leagueName: "EPL", clubAssociation: "England"),
                                    imageName: "liverpool_logo")
    
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
    
    
    // MARK: Rounds
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
}
