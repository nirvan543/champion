//
//  GameState.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

enum GameState: Codable {
    case notStarted
    case inProgress
    case completed
    case unplayable
}
