//
//  Round.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct Round: Identifiable, Hashable, Equatable, Codable {
    let id: String
    var matches: [Match]
    
    init(matches: [Match] = []) {
        id = IdUtils.newUuid
        self.matches = matches
    }
    
    var isComplete: Bool {
        matches.allSatisfy({ $0.matchState == .completed || $0.matchState == .unplayable })
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Round, rhs: Round) -> Bool {
        lhs.id == rhs.id
    }
}
