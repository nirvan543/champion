//
//  GroupedTournament.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/24/22.
//

import Foundation

struct GroupedTournament: Tournament {
    let id: String
    var name: String
    var date: Date
    var participants: [Participant]
    var state: TournamentState
    var groups: [TournamentGroup]
    var legsPerMatch: Int
    
    init(name: String, date: Date, participants: [Participant], state: TournamentState, groups: [TournamentGroup], legsPerMatch: Int) {
        self.id = IdUtils.newUuid
        self.name = name
        self.date = date
        self.participants = participants
        self.state = state
        self.groups = groups
        self.legsPerMatch = legsPerMatch
    }
    
    var format: TournamentFormat {
        .grouped
    }
    
    var matchesAreCreated: Bool {
        !groups.isEmpty && groups.allSatisfy({ !$0.rounds.isEmpty })
    }
    
    var roundsAreComplete: Bool {
        groups.allSatisfy { group in
            group.rounds.allSatisfy({ $0.isComplete })
        }
    }
    
    var tournamentStats: [ParticipantStats] {
        var standings = [ParticipantStats]()
        
        for index in 0 ..< groups.count {
            standings.append(contentsOf: standingStats(for: index))
        }
        
        return standings.sorted(by: { ($0.points, $0.goalsDifference) > ($1.points, $1.goalsDifference) })
    }
    
    func standingStats(for groupIndex: Int) -> [ParticipantStats] {
        let group = groups[groupIndex]
        var groupStats = [ParticipantStats]()
        
        group.participants.forEach { participant in
            let participantMatches = group.rounds.flatMap({ $0.matches }).filter({ $0.contains(participant: participant) })
            let matchesWon = participantMatches.filter({ $0.matchState == .completed && !$0.isByeGame && $0.winner == participant }).count
            let matchesTied = participantMatches.filter({ $0.matchState == .completed && !$0.isByeGame && $0.endedInATie }).count
            let matchesLost = participantMatches.filter({ $0.matchState == .completed && !$0.isByeGame && !$0.endedInATie && $0.winner != participant }).count
            
            let goals = participantMatches.flatMap { match in
                match.legs.flatMap({ $0.goals })
            }
            
            let participantStats = ParticipantStats(participant: participant,
                                                    matchesWon: matchesWon,
                                                    matchesTied: matchesTied,
                                                    matchesLost: matchesLost,
                                                    goals: goals)
            groupStats.append(participantStats)
        }
        
        // TODO: Add `matchesPlayed` as a sort criteria. But `matchesPlayed` would be compared with a `<` instead of `>`.
        return groupStats.sorted(by: { ($0.points, $0.goalsDifference) > ($1.points, $1.goalsDifference) })
    }
    
    mutating func clearMatches() {
        groups.removeAll()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: GroupedTournament, rhs: GroupedTournament) -> Bool {
        lhs.id == rhs.id
    }
}

struct TournamentGroup: Identifiable, Codable, Equatable, Hashable {
    let id: String
    var participants: [Participant]
    var rounds: [Round]
    
    init() {
        self.init(participants: [])
    }
    
    init(participants: [Participant]) {
        self.init(participants: participants, rounds: [])
    }
    
    init(participants: [Participant], rounds: [Round]) {
        self.init(id: IdUtils.newUuid, participants: participants, rounds: rounds)
    }
    
    private init(id: String, participants: [Participant], rounds: [Round]) {
        self.id = id
        self.participants = participants
        self.rounds = rounds
    }
    
    mutating func generateMatches(legsPerMatch: Int) {
        rounds = MatchesService.shared.createMatches(
            participants: participants,
            legsPerMatch: legsPerMatch,
            matchesPerOpponent: 1 // TODO: Make this dynamic
        )
    }
    
    mutating func clearMatches() {
        rounds.removeAll()
    }
}
