//
//  Tournament.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/20/22.
//

import Foundation

protocol Tournament: Identifiable, Hashable, Equatable, Codable {
    var id: String { get }
    var name: String { get set }
    var date: Date { get set }
    var participants: [Participant] { get set }
    var state: TournamentState { get set }
    var format: TournamentFormat { get }
    
    var matchesAreCreated: Bool { get }
    var tournamentStats: [ParticipantStats] { get }
    mutating func clearMatches() -> Void
}
