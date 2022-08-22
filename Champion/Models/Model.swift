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
    let participants: [Participant]
    var rounds: [Round]
    let date: Date
    var state: TournamentState
    let type: TournamentFormat
    var tournamentFormatManager: TournamentFormatManager
    
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

struct RoundRobinStage: Hashable, Equatable {
    let matchesPerOpponent: Int
    let legsPerMatch: Int
    var rounds: [Round]
    
    init(matchesPerOpponent: Int, legsPerMatch: Int, rounds: [Round] = []) {
        self.matchesPerOpponent = matchesPerOpponent
        self.legsPerMatch = legsPerMatch
        self.rounds = rounds
    }
}

struct Round: Identifiable, Hashable, Equatable {
    let id: String
    var matches: [Match]
    
    init(matches: [Match] = []) {
        id = IdUtils.newUuid
        self.matches = matches
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
    let participant2: Participant?
    var legs: [MatchLeg]
    
    init(participant1: Participant, participant2: Participant?, legsPerMatch: Int) {
        id = IdUtils.newUuid
        self.participant1 = participant1
        self.participant2 = participant2
        legs = []
        
        guard let participant2 = participant2 else {
            return
        }
        
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
    }
    
    var winner: Participant? {
        guard matchState == .completed, let participant2 = participant2 else {
            return nil
        }
        
        let participant1AggregateScore = legs.reduce(0) { partialResult, leg in
            partialResult + leg.score(for: participant1)
        }
        
        let participant2AggregateScore = legs.reduce(0) { partialResult, leg in
            partialResult + leg.score(for: participant2)
        }
        
        if (participant1AggregateScore > participant2AggregateScore) {
            return participant1
        } else if participant1AggregateScore < participant2AggregateScore {
            return participant2
        } else {
            return nil
        }
    }
    
    var endedInATie: Bool {
        guard matchState == .completed, let participant2 = participant2 else {
            return false
        }
        
        let participant1Score = legs.reduce(0) { partialResult, leg in
            partialResult + leg.score(for: participant1)
        }
        
        let participant2Score = legs.reduce(0) { partialResult, leg in
            partialResult + leg.score(for: participant2)
        }
        
        return participant1Score == participant2Score
    }
    
    var isByeGame: Bool {
        participant2 == nil
    }
    
    var matchState: GameState {
        if isByeGame {
            return .completed
        }
        
        if legs.allSatisfy({ $0.legState == .notStarted }) {
            return .notStarted
        }
        
        if legs.allSatisfy({ $0.legState == .completed }) {
            return .completed
        }
        
        return .inProgress
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
    var goals: [Goal]
    var legState: GameState
    
    init(homeParticipant: Participant, awayParticipant: Participant) {
        self.init(id: IdUtils.newUuid,
                  homeParticipant: homeParticipant,
                  awayParticipant: awayParticipant,
                  goals: [],
                  legState: .notStarted)
    }
    
    init(id: String,
         homeParticipant: Participant,
         awayParticipant: Participant,
         goals: [Goal],
         legState: GameState) {
        
        self.id = id
        self.homeParticipant = homeParticipant
        self.awayParticipant = awayParticipant
        self.goals = goals
        self.legState = legState
    }
    
    var homeScore: Int {
        goals.filter({ $0.scorer == homeParticipant }).count
    }
    
    var awayScore: Int {
        goals.filter({ $0.scorer == awayParticipant }).count
    }
    
    var winner: Participant? {
        guard legState == .completed else {
            return nil
        }
        
        if homeScore > awayScore {
            return homeParticipant
        } else if homeScore < awayScore {
            return awayParticipant
        } else {
            return nil
        }
    }
    
    var endedInATie: Bool {
        legState == .completed && (homeScore == awayScore)
    }
    
    var endedWithAWinner: Bool {
        legState == .completed && (homeScore > awayScore || awayScore > homeScore)
    }
    
    func score(for participant: Participant) -> Int {
        if participant == homeParticipant {
            return homeScore
        } else {
            return awayScore
        }
    }
    
    mutating func startLeg() {
        legState = .inProgress
    }
    
    mutating func completeLeg() {
        legState = .completed
    }
    
    mutating func reactivateLeg() {
        legState = .inProgress
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: MatchLeg, rhs: MatchLeg) -> Bool {
        lhs.id == rhs.id
    }
}

struct Goal: Identifiable, Hashable, Equatable, Codable {
    let id: String
    let scorer: Participant
    let against: Participant
    let minute: Int
}

enum TournamentFormat: String {
    case roundRobin = "Round Robin"
}

enum TournamentState {
    case created
    case roundRobin
    case knockout
    case completed
}

enum GameState: Codable {
    case notStarted
    case inProgress
    case completed
}

protocol TournamentFormatConfig {
    func validate() -> ChampionError?
}

struct RoundRobinTournamentFormatConfig: TournamentFormatConfig {
    var matchesPerOpponent: Int
    var legsPerMatch: Int
    
    init(matchesPerOpponent: Int = 1, legsPerMatch: Int = 1) {
        self.matchesPerOpponent = matchesPerOpponent
        self.legsPerMatch = legsPerMatch
    }
    
    func validate() -> ChampionError? {
        if matchesPerOpponent < 1 {
            return ChampionError(errorMessage: "League stage 'Matches per Opponent' must be at least '1'.")
        }
        
        if legsPerMatch < 1 {
            return ChampionError(errorMessage: "League stage 'Legs per Match' must be at least '1'.")
        }
        
        return nil
    }
}

protocol TournamentFormatManager {
    var tournamentFormatConfig: TournamentFormatConfig { get set }
    
    func generateMatches(participants: [Participant]) -> [Round]
}

struct RoundRobinFormatManager: TournamentFormatManager {
    var tournamentFormatConfig: TournamentFormatConfig
    
    func generateMatches(participants: [Participant]) -> [Round] {
        guard let tournamentFormatConfig = tournamentFormatConfig as? RoundRobinTournamentFormatConfig else {
            fatalError("Expected 'tournamentFormatConfig' to be of type 'RoundRobinTournamentFormatConfig'. Instead, is of type: \(tournamentFormatConfig.self)")
        }
        
        return MatchesService.shared.createMatches(participants: participants,
                                                   matchesPerOpponent: tournamentFormatConfig.matchesPerOpponent,
                                                   legsPerMatch: tournamentFormatConfig.legsPerMatch)
    }
}
