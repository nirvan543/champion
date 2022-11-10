//
//  Goal.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct Goal: Identifiable, Hashable, Equatable, Codable {
    let id: String
    let scorer: Participant
    let against: Participant
    let minute: Int?
}
