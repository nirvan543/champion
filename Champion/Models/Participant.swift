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
    let clubSelection: ClubSelection
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Participant, rhs: Participant) -> Bool {
        lhs.id == rhs.id
    }
}
