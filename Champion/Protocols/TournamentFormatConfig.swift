//
//  TournamentFormatConfig.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

protocol TournamentFormatConfig: Codable {
    func validate() -> ChampionError?
}
