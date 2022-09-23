//
//  Model.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/8/22.
//

import Foundation
import SwiftUI

struct Tournament: Identifiable, Hashable, Equatable, Codable {
    let id: String
    var name: String
    var participants: [Participant]
    var rounds: [Round]
    var date: Date
    var state: TournamentState
    var type: TournamentFormat
    var fifaVersionName: String
    var tournamentFormatManager: TournamentFormatManager
    
    init(id: String,
         name: String,
         participants: [Participant],
         rounds: [Round],
         date: Date,
         state: TournamentState,
         type: TournamentFormat,
         fifaVersionName: String,
         tournamentFormatManager: TournamentFormatManager) {
        
        self.id = id
        self.name = name
        self.participants = participants
        self.rounds = rounds
        self.date = date
        self.state = state
        self.type = type
        self.fifaVersionName = fifaVersionName
        self.tournamentFormatManager = tournamentFormatManager
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        participants = try container.decode([Participant].self, forKey: .participants)
        rounds = try container.decode([Round].self, forKey: .rounds)
        date = try container.decode(Date.self, forKey: .date)
        state = try container.decode(TournamentState.self, forKey: .state)
        type = try container.decode(TournamentFormat.self, forKey: .type)
        fifaVersionName = try container.decode(String.self, forKey: .fifaVersionName)
        
        do {
            tournamentFormatManager = try container.decode(RoundRobinFormatManager.self, forKey: .tournamentFormatManager)
        } catch {
            fatalError("Could not convert `tournamentFormatManager` into a concrete type. Error: \(error)")
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Tournament, rhs: Tournament) -> Bool {
        lhs.id == rhs.id
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(participants, forKey: .participants)
        try container.encode(rounds, forKey: .rounds)
        try container.encode(date, forKey: .date)
        try container.encode(state, forKey: .state)
        try container.encode(type, forKey: .type)
        try container.encode(fifaVersionName, forKey: .fifaVersionName)
        
        if let tournamentFormatManager = tournamentFormatManager as? RoundRobinFormatManager {
            try container.encode(tournamentFormatManager, forKey: .tournamentFormatManager)
        } else {
            fatalError("Could not convert `tournamentFormatManager` into a concrete type. `tournamentFormatManager`: \(tournamentFormatManager.self)")
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case participants
        case rounds
        case date
        case state
        case type
        case fifaVersionName
        case tournamentFormatManager
    }
}

struct Participant: Identifiable, Hashable, Equatable, Codable {
    let id: String
    let playerName: String
    let clubSelection: ClubSelection
    let imageName: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Participant, rhs: Participant) -> Bool {
        lhs.id == rhs.id
    }
}

struct ClubSelection: Identifiable, Hashable, Equatable, Codable {
    var id: String {
        "\(clubAssociation)_\(leagueName ?? "")_\(clubName)"
    }
    
    let clubName: String
    let leagueName: String?
    let clubAssociation: String
    
    static func ==(lhs: ClubSelection, rhs: ClubSelection) -> Bool {
        lhs.clubName == rhs.clubName &&
        lhs.leagueName == rhs.leagueName &&
        lhs.clubAssociation == rhs.clubAssociation
    }
}

struct Round: Identifiable, Hashable, Equatable, Codable {
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

struct Match: Identifiable, Hashable, Equatable, Codable {
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
    
    func contains(participant: Participant) -> Bool {
        participant == participant1 || participant == participant2
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

enum TournamentFormat: String, Codable {
    case roundRobin = "Round Robin"
}

enum TournamentState: Codable {
    case created
    case roundRobin
    case knockout
    case completed
}

enum GameState: Codable {
    case notStarted
    case inProgress
    case completed
    case unplayable
}

protocol TournamentFormatConfig: Codable {
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

protocol TournamentFormatManager: Codable {
    var tournamentFormatConfig: TournamentFormatConfig { get set }
    
    func generateMatches(participants: [Participant]) -> [Round]
    
    func matchStats(participants: [Participant], rounds: [Round]) -> [ParticipantStats]
}

struct TournamentResults {
    let stats: [ParticipantStats]
    
    var firstPlace: ParticipantStats {
        guard let first = stats.first else {
            fatalError("Expected there to a first place winner in `stats` array: \(stats)")
        }
        
        return first
    }
    
    var secondPlace: ParticipantStats {
        guard let second = stats.prefix(through: 1).last else {
            fatalError("Expected there to a second place winner in `stats` array: \(stats)")
        }
        
        return second
    }
    
    var thirdPlace: ParticipantStats? {
        if stats.count >= 3, let third = stats.prefix(through: 2).last {
            return third
        } else {
            return nil
        }
    }
}

struct RoundRobinFormatManager: TournamentFormatManager {
    var tournamentFormatConfig: TournamentFormatConfig
    
    init(tournamentFormatConfig: TournamentFormatConfig) {
        self.tournamentFormatConfig = tournamentFormatConfig
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.tournamentFormatConfig = try container.decode(RoundRobinTournamentFormatConfig.self, forKey: .tournamentFormatConfig)
        } catch {
            fatalError("Could not convert `tournamentFormatConfig` into a concrete type. Error: \(error)")
        }
    }
    
    func generateMatches(participants: [Participant]) -> [Round] {
        guard let tournamentFormatConfig = tournamentFormatConfig as? RoundRobinTournamentFormatConfig else {
            fatalError("Expected 'tournamentFormatConfig' to be of type 'RoundRobinTournamentFormatConfig'. Instead, is of type: \(tournamentFormatConfig.self)")
        }
        
        return MatchesService.shared.createMatches(participants: participants,
                                                   matchesPerOpponent: tournamentFormatConfig.matchesPerOpponent,
                                                   legsPerMatch: tournamentFormatConfig.legsPerMatch)
    }
    
    func matchStats(participants: [Participant], rounds: [Round]) -> [ParticipantStats] {
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
        
        return matchStats
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let tournamentFormatConfig = tournamentFormatConfig as? RoundRobinTournamentFormatConfig {
            try container.encode(tournamentFormatConfig, forKey: .tournamentFormatConfig)
        } else {
            fatalError("Could not convert `tournamentFormatConfig` into a concrete type. `tournamentFormatConfig`: \(tournamentFormatConfig)")
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case tournamentFormatConfig
    }
}

struct ParticipantStats: Equatable, Hashable {
    let participant: Participant
    let matchesWon: Int
    let matchesTied: Int
    let matchesLost: Int
    let goalsFor: Int
    let goalsAgainst: Int
    
    var matchesPlayed: Int {
        matchesWon + matchesTied + matchesLost
    }
    
    var goalsDifference: Int {
        goalsFor - goalsAgainst
    }
    
    var points: Int {
        (matchesWon * 3) + (matchesTied * 1) + (matchesLost * 0)
    }
}
