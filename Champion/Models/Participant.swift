//
//  Participant.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct Participant: Identifiable, Hashable, Equatable, Codable {
    let id: String
    let playerName: String
    let teamName: String
    
    init(id: String, playerName: String, teamName: String) {
        self.id = id
        self.playerName = playerName
        self.teamName = teamName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.playerName = try container.decode(String.self, forKey: .playerName)
        
        if let clubSelection = try container.decodeIfPresent(ClubSelection.self, forKey: .clubSelection) {
            teamName = clubSelection.clubName
        } else {
            self.teamName = try container.decode(String.self, forKey: .teamName)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(playerName, forKey: .playerName)
        try container.encode(teamName, forKey: .teamName)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Participant, rhs: Participant) -> Bool {
        lhs.id == rhs.id
    }
    
    enum CodingKeys: CodingKey {
        case id
        case playerName
        case clubSelection
        case teamName
    }
}
