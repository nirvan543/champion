//
//  Match.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct Match: Identifiable, Hashable, Equatable, Codable {
    let id: String
    let participant1: Participant
    let participant2: Participant?
    var legs: [MatchLeg]
    
    init(participant1: Participant, participant2: Participant?, legsPerMatch: Int) {
        id = IdUtils.newUuid
        self.participant1 = participant1
        self.participant2 = participant2
        legs = []
        
        guard let participant2 = participant2 else {
            return
        }
        
        for i in 0 ..< legsPerMatch {
            if i % 2 == 0 {
                let matchLeg = MatchLeg(homeParticipant: participant1, awayParticipant: participant2)
                legs.append(matchLeg)
            } else {
                let matchLeg = MatchLeg(homeParticipant: participant2, awayParticipant: participant1)
                legs.append(matchLeg)
            }
        }
    }
    
    init(id: String, participant1: Participant, participant2: Participant, legs: [MatchLeg]) {
        self.id = id
        self.participant1 = participant1
        self.participant2 = participant2
        self.legs = legs
    }
    
    var participant1Score: Int {
        aggregateScore(for: participant1)
    }
    
    var participant2Score: Int? {
        guard let participant2 = participant2 else {
            return nil
        }
        
        return aggregateScore(for: participant2)
    }
    
    private func aggregateScore(for participant: Participant) -> Int {
        legs.reduce(0) { partialResult, leg in
            partialResult + leg.score(for: participant)
        }
    }
    
    var winner: Participant? {
        guard matchState == .completed, let participant2 = participant2 else {
            return nil
        }
        
        let participant1AggregateScore = aggregateScore(for: participant1)
        let participant2AggregateScore = aggregateScore(for: participant2)
        
        if (participant1AggregateScore > participant2AggregateScore) {
            return participant1
        } else if participant1AggregateScore < participant2AggregateScore {
            return participant2
        } else {
            return nil
        }
    }
    
    var endedInATie: Bool {
        guard matchState == .completed, let participant2 = participant2 else {
            return false
        }
        
        let participant1Score = aggregateScore(for: participant1)
        let participant2Score = aggregateScore(for: participant2)
        
        return participant1Score == participant2Score
    }
    
    var isByeGame: Bool {
        participant2 == nil
    }
    
    var matchState: GameState {
        if isByeGame {
            return .completed
        }
        
        if legs.allSatisfy({ $0.legState == .notStarted }) {
            return .notStarted
        }
        
        if legs.allSatisfy({ $0.legState == .completed }) {
            return .completed
        }
        
        return .inProgress
    }
    
    func contains(participant: Participant) -> Bool {
        participant == participant1 || participant == participant2
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Match, rhs: Match) -> Bool {
        lhs.id == rhs.id
    }
}
