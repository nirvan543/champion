//
//  Tournament.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct RoundRobinTournament: Tournament, Identifiable, Hashable, Equatable, Codable {
    let id: String
    var name: String
    var date: Date
    var fifaVersionName: String
    var participants: [Participant]
    var state: TournamentState
    var rounds: [Round]
    
    init(name: String,
         date: Date,
         fifaVersionName: String,
         participants: [Participant],
         state: TournamentState,
         rounds: [Round]) {
        
        self.id = IdUtils.newUuid
        self.name = name
        self.date = date
        self.fifaVersionName = fifaVersionName
        self.participants = participants
        self.state = state
        self.rounds = rounds
    }
    
    var format: TournamentFormat {
        .roundRobin
    }
    
    var roundsAreComplete: Bool {
        rounds.allSatisfy({ $0.isComplete })
    }
    
    var standingStats: [ParticipantStats] {
        var matchStats = [ParticipantStats]()
        
        participants.forEach { participant in
            let participantMatches = rounds.flatMap({ $0.matches }).filter({ $0.contains(participant: participant) })
            let matchesWon = participantMatches.filter({ $0.matchState == .completed && !$0.isByeGame && $0.winner == participant }).count
            let matchesTied = participantMatches.filter({ $0.matchState == .completed && !$0.isByeGame && $0.endedInATie }).count
            let matchesLost = participantMatches.filter({ $0.matchState == .completed && !$0.isByeGame && !$0.endedInATie && $0.winner != participant }).count
            
            let goals = participantMatches.flatMap { match in
                match.legs.flatMap({ $0.goals })
            }
            
            let goalsFor = goals.filter({ $0.scorer == participant }).count
            let goalsAgainst = goals.filter({ $0.against == participant }).count
            
            let participantStats = ParticipantStats(participant: participant,
                                                    matchesWon: matchesWon,
                                                    matchesTied: matchesTied,
                                                    matchesLost: matchesLost,
                                                    goalsFor: goalsFor,
                                                    goalsAgainst: goalsAgainst)
            matchStats.append(participantStats)
        }
        
        // TODO: Add `matchesPlayed` as a sort criteria. But `matchesPlayed` would be compared with a `<` instead of `>`.
        return matchStats.sorted(by: { ($0.points, $0.goalsDifference) > ($1.points, $1.goalsDifference) })
    }
    
    var matchesAreCreated: Bool {
        !rounds.isEmpty
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: RoundRobinTournament, rhs: RoundRobinTournament) -> Bool {
        lhs.id == rhs.id
    }
}
