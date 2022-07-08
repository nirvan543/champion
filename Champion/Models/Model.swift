//
//  Model.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/8/22.
//

import Foundation
import SwiftUI

struct Tournament {
    let name: String
    let sport: String
    let type: TournamentType
    let gameConfig: GameConfig
    let participants: [Participant]
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

struct Participant {
    let teamName: String
    let image: Image
    let playerName: String
}
