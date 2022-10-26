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
        self.init(id: IdUtils.newUuid, participants: participants, rounds: [])
    }
    
    private init(id: String, participants: [Participant], rounds: [Round]) {
        self.id = id
        self.participants = participants
        self.rounds = rounds
    }
}
