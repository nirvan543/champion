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
    var formatConfig: TournamentFormatConfig
    
    init(id: String,
         name: String,
         participants: [Participant],
         rounds: [Round],
         date: Date,
         state: TournamentState,
         format: TournamentFormat,
         fifaVersionName: String,
         formatConfig: TournamentFormatConfig) {
        
        self.id = id
        self.name = name
        self.participants = participants
        self.rounds = rounds
        self.date = date
        self.state = state
        self.format = format
        self.fifaVersionName = fifaVersionName
        self.formatConfig = formatConfig
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
            formatConfig = try container.decode(RoundRobinTournamentFormatConfig.self, forKey: .formatConfig)
        } catch {
            fatalError("Could not convert `formatConfig` into a concrete type. Error: \(error)")
        }
    }
    
    var roundsAreComplete: Bool {
        rounds.allSatisfy({ $0.isComplete })
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
        
        if let formatConfig = formatConfig as? RoundRobinTournamentFormatConfig {
            try container.encode(formatConfig, forKey: .formatConfig)
        } else {
            fatalError("Could not convert `formatConfig` into a concrete type. `formatConfig`: \(formatConfig.self)")
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
        case formatConfig
    }
}
