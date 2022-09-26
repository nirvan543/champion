//
//  RoundRobinFormatManager.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct RoundRobinTournamentManager: TournamentManager {
    var tournamentFormatConfig: TournamentFormatConfig
    
    init(tournamentFormatConfig: TournamentFormatConfig) {
        self.tournamentFormatConfig = tournamentFormatConfig
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.tournamentFormatConfig = try container.decode(RoundRobinTournamentFormatConfig.self, forKey: .tournamentFormatConfig)
        } catch {
            fatalError("Could not convert `tournamentFormatConfig` into a concrete type. Error: \(error)")
        }
    }
    
    func generateMatches(participants: [Participant]) -> [Round] {
        guard let tournamentFormatConfig = tournamentFormatConfig as? RoundRobinTournamentFormatConfig else {
            fatalError("Expected 'tournamentFormatConfig' to be of type 'RoundRobinTournamentFormatConfig'. Instead, is of type: \(tournamentFormatConfig.self)")
        }
        
        return MatchesService.shared.createMatches(participants: participants,
                                                   matchesPerOpponent: tournamentFormatConfig.matchesPerOpponent,
                                                   legsPerMatch: tournamentFormatConfig.legsPerMatch)
    }
    
    func matchStats(participants: [Participant], rounds: [Round]) -> [ParticipantStats] {
        var matchStats = [ParticipantStats]()
        
        participants.forEach { participant in
            let participantMatches = rounds.flatMap({ $0.matches }).filter({ $0.contains(participant: participant) })
            let matchesWon = participantMatches.filter({ $0.matchState == .completed && !$0.isByeGame && $0.winner == participant }).count
            let matchesTied = participantMatches.filter({ $0.matchState == .completed && !$0.isByeGame && $0.endedInATie }).count
            let matchesLost = participantMatches.filter({ $0.matchState == .completed && !$0.isByeGame && !$0.endedInATie && $0.winner != participant }).count
            
            let goals = participantMatches.flatMap { match in
                match.legs.flatMap({ $0.goals })
            }
            
            let goalsFor = goals.filter({ $0.scorer == participant }).count
            let goalsAgainst = goals.filter({ $0.against == participant }).count
            
            let participantStats = ParticipantStats(participant: participant,
                                                    matchesWon: matchesWon,
                                                    matchesTied: matchesTied,
                                                    matchesLost: matchesLost,
                                                    goalsFor: goalsFor,
                                                    goalsAgainst: goalsAgainst)
            matchStats.append(participantStats)
        }
        
        return matchStats
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let tournamentFormatConfig = tournamentFormatConfig as? RoundRobinTournamentFormatConfig {
            try container.encode(tournamentFormatConfig, forKey: .tournamentFormatConfig)
        } else {
            fatalError("Could not convert `tournamentFormatConfig` into a concrete type. `tournamentFormatConfig`: \(tournamentFormatConfig)")
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case tournamentFormatConfig
    }
}
