//
//  Model.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/8/22.
//

import Foundation
import SwiftUI

struct Tournament: Identifiable, Hashable, Equatable {
    let id: String
    let name: String
    let date: Date
    let type: TournamentFormat
    let participants: [Participant]
    let roundRobinStage: RoundRobinStage
    let knockoutStage: KnockoutStage
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Tournament, rhs: Tournament) -> Bool {
        lhs.id == rhs.id
    }
}

struct Participant: Identifiable, Hashable, Equatable, Codable {
    let id: String
    let playerName: String
    let teamName: String
    let imageName: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Participant, rhs: Participant) -> Bool {
        lhs.id == rhs.id
    }
}

struct RoundRobinStage {
    let matchesPerOpponent: Int
    let legsPerMatch: Int
    var rounds: [Round]
    
    init(matchesPerOpponent: Int, legsPerMatch: Int, rounds: [Round] = []) {
        self.matchesPerOpponent = matchesPerOpponent
        self.legsPerMatch = legsPerMatch
        self.rounds = rounds
    }
}

struct KnockoutStage {
    let playoffSpots: Int
    let legsPerMatch: Int
    let finalLegsPerMatch: Int
    let rounds: [Round]
}

struct Round: Identifiable, Hashable, Equatable {
    let id: String
    var fixtures: [Match]
    
    init(fixtures: [Match] = []) {
        id = IdUtils.newUuid
        self.fixtures = fixtures
    }
    
    func isFull(when participantCount: Int) -> Bool {
        fixtures.count == (participantCount / 2)
    }
    
    func containsConflictingMatch(potentialMatch: Match) -> Bool {
        fixtures.contains { match in
            match.containsParticipants(participant1: potentialMatch.participant1,
                                       participant2: potentialMatch.participant2)
        }
    }
    
    func containsMatch(with participant: Participant) -> Bool {
        fixtures.contains { match in
            participant == match.participant1 || participant == match.participant2
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Round, rhs: Round) -> Bool {
        lhs.id == rhs.id
    }
}

struct Match: Identifiable, Hashable, Equatable {
    let id: String
    let participant1: Participant
    let participant2: Participant
    var legs: [MatchLeg]
    let displayName: String
    
    init(participant1: Participant, participant2: Participant, legsPerMatch: Int) {
        id = IdUtils.newUuid
        self.participant1 = participant1
        self.participant2 = participant2
        legs = []
        displayName = "\(participant1.playerName) v \(participant2.playerName)"
        
        for i in 0 ..< legsPerMatch {
            if i % 2 == 0 {
                let matchLeg = MatchLeg(homeParticipant: participant1, awayParticipant: participant2)
                legs.append(matchLeg)
            } else {
                let matchLeg = MatchLeg(homeParticipant: participant2, awayParticipant: participant1)
                legs.append(matchLeg)
            }
        }
    }
    
    init(id: String, participant1: Participant, participant2: Participant, legs: [MatchLeg]) {
        self.id = id
        self.participant1 = participant1
        self.participant2 = participant2
        self.legs = legs
        displayName = "\(participant1.playerName) v \(participant2.playerName)"
    }
    
    func containsParticipants(participant1: Participant, participant2: Participant) -> Bool {
        (participant1 == self.participant1 || participant1 == self.participant2) ||
        (participant2 == self.participant1 || participant2 == self.participant2)
    }
    
    var winner: Participant {
        let participant1AggregateScore = legs.reduce(0) { partialResult, leg in
            partialResult + leg.score(for: participant1)
        }
        
        let participant2AggregateScore = legs.reduce(0) { partialResult, leg in
            partialResult + leg.score(for: participant2)
        }
        
        if (participant1AggregateScore > participant2AggregateScore) {
            return participant1
        } else {
            return participant2
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Match, rhs: Match) -> Bool {
        lhs.id == rhs.id
    }
}

struct MatchLeg: Identifiable, Hashable, Equatable, Codable {
    let id: String
    let homeParticipant: Participant
    let awayParticipant: Participant
    let homeScore: Int
    let awayScore: Int
    
    init(homeParticipant: Participant, awayParticipant: Participant) {
        id = IdUtils.newUuid
        self.homeParticipant = homeParticipant
        self.awayParticipant = awayParticipant
        homeScore = 0
        awayScore = 0
    }
    
    var winner: Participant {
        if homeScore > awayScore {
            return homeParticipant
        } else {
            return awayParticipant
        }
    }
    
    func score(for participant: Participant) -> Int {
        if participant == homeParticipant {
            return homeScore
        } else {
            return awayScore
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: MatchLeg, rhs: MatchLeg) -> Bool {
        lhs.id == rhs.id
    }
}

enum TournamentFormat: String {
    case roundRobin = "Round Robin"
    case knockout = "Knockout"
    case roundRobinAndKnockout = "Round Robin + Knockout"
}
