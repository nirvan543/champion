//
//  Model.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/8/22.
//

import Foundation
import SwiftUI

struct Tournament {
    let id: String
    let name: String
    let date: Date
    let sport: String
    let type: TournamentType
    let gameConfig: GameConfig
    let participants: [Participant]
    let roundRobinStage: RoundRobinStage
    let knockoutStage: KnockoutStage
}

struct Participant {
    let id: String
    let playerName: String
    let teamName: String
    let image: Image
}

struct Match {
    let id: String
    let participant1: Participant
    let participant2: Participant
    let participant1Score: Int
    let participant2Score: Int
}

struct Round {
    let id: String
    let matches: [Match]
}

struct RoundRobinStage {
    let rounds: [Round]
}

struct KnockoutStage {
    let rounds: [Round]
}

enum TournamentType {
    case roundRobinAndKnockout
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
