//
//  TournamentState.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

enum TournamentState: Codable {
    case created
    case roundRobin
    case knockout
    case completed
}
