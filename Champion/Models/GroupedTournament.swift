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
    var fifaVersionName: String
    var participants: [Participant]
    var state: TournamentState
    var groups: [TournamentGroup]
    var legsPerMatch: Int
    
    init(name: String, date: Date, fifaVersionName: String, participants: [Participant], state: TournamentState, groups: [TournamentGroup], legsPerMatch: Int) {
        self.id = IdUtils.newUuid
        self.name = name
        self.date = date
        self.fifaVersionName = fifaVersionName
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
        rounds = MatchesService.shared.createMatches(participants: participants,
                                                     legsPerMatch: legsPerMatch)
    }
    
    mutating func clearMatches() {
        rounds.removeAll()
    }
}
