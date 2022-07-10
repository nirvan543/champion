//
//  Model.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/8/22.
//

import Foundation
import SwiftUI

struct Tournament: Identifiable {
    let id: String
    let name: String
    let date: Date
    let type: TournamentFormat
    let gameConfig: GameConfig
    let participants: [Participant]
    let roundRobinStage: RoundRobinStage
    let knockoutStage: KnockoutStage
}

struct Participant: Identifiable, Hashable {
    let id: String
    let playerName: String
    let teamName: String
    let image: Image
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Participant, rhs: Participant) -> Bool {
        lhs.id == rhs.id
    }
}

struct Match: Identifiable, Hashable {
    let id: String
    let participant1: Participant
    let participant2: Participant
    let participant1Score: Int
    let participant2Score: Int
}

struct Round: Identifiable, Hashable {
    let id: String
    let fixtures: [Match]
}

struct RoundRobinStage {
    let rounds: [Round]
}

struct KnockoutStage {
    let rounds: [Round]
}

enum TournamentFormat: String {
    case roundRobin = "Round Robin"
    case knockout = "Knockout"
    case roundRobinAndKnockout = "Round Robin + Knockout"
}

struct GameConfig {
    let leagueStageConfig: LeagueStageGameConfig
    let knockoutStageConfig: KnockoutStageGameConfig
}

struct LeagueStageGameConfig {
    let matchesPerOpponent: Int
    let legsPerMatch: Int
}

struct KnockoutStageGameConfig {
    let playoffSpotCount: Int
    let legsPerMatch: Int
}
