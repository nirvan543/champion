//
//  Tournament.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct Tournament: Identifiable, Hashable, Equatable, Codable {
    let id: String
    var name: String
    var participants: [Participant]
    var rounds: [Round]
    var date: Date
    var state: TournamentState
    var format: TournamentFormat
    var fifaVersionName: String
    var manager: TournamentManager
    
    init(id: String,
         name: String,
         participants: [Participant],
         rounds: [Round],
         date: Date,
         state: TournamentState,
         type: TournamentFormat,
         fifaVersionName: String,
         manager: TournamentManager) {
        
        self.id = id
        self.name = name
        self.participants = participants
        self.rounds = rounds
        self.date = date
        self.state = state
        self.format = type
        self.fifaVersionName = fifaVersionName
        self.manager = manager
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        participants = try container.decode([Participant].self, forKey: .participants)
        rounds = try container.decode([Round].self, forKey: .rounds)
        date = try container.decode(Date.self, forKey: .date)
        state = try container.decode(TournamentState.self, forKey: .state)
        format = try container.decode(TournamentFormat.self, forKey: .format)
        fifaVersionName = try container.decode(String.self, forKey: .fifaVersionName)
        
        do {
            manager = try container.decode(RoundRobinTournamentManager.self, forKey: .tournamentFormatManager)
        } catch {
            fatalError("Could not convert `tournamentFormatManager` into a concrete type. Error: \(error)")
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Tournament, rhs: Tournament) -> Bool {
        lhs.id == rhs.id
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(participants, forKey: .participants)
        try container.encode(rounds, forKey: .rounds)
        try container.encode(date, forKey: .date)
        try container.encode(state, forKey: .state)
        try container.encode(format, forKey: .format)
        try container.encode(fifaVersionName, forKey: .fifaVersionName)
        
        if let tournamentFormatManager = manager as? RoundRobinTournamentManager {
            try container.encode(tournamentFormatManager, forKey: .tournamentFormatManager)
        } else {
            fatalError("Could not convert `tournamentFormatManager` into a concrete type. `tournamentFormatManager`: \(manager.self)")
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case participants
        case rounds
        case date
        case state
        case format
        case fifaVersionName
        case tournamentFormatManager
    }
}
