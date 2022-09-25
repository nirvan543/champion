//
//  MatchLeg.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct MatchLeg: Identifiable, Hashable, Equatable, Codable {
    let id: String
    let homeParticipant: Participant
    let awayParticipant: Participant
    var goals: [Goal]
    var legState: GameState
    
    init(homeParticipant: Participant, awayParticipant: Participant) {
        self.init(id: IdUtils.newUuid,
                  homeParticipant: homeParticipant,
                  awayParticipant: awayParticipant,
                  goals: [],
                  legState: .notStarted)
    }
    
    init(id: String,
         homeParticipant: Participant,
         awayParticipant: Participant,
         goals: [Goal],
         legState: GameState) {
        
        self.id = id
        self.homeParticipant = homeParticipant
        self.awayParticipant = awayParticipant
        self.goals = goals
        self.legState = legState
    }
    
    var homeScore: Int {
        goals.filter({ $0.scorer == homeParticipant }).count
    }
    
    var awayScore: Int {
        goals.filter({ $0.scorer == awayParticipant }).count
    }
    
    var winner: Participant? {
        guard legState == .completed else {
            return nil
        }
        
        if homeScore > awayScore {
            return homeParticipant
        } else if homeScore < awayScore {
            return awayParticipant
        } else {
            return nil
        }
    }
    
    var endedInATie: Bool {
        legState == .completed && (homeScore == awayScore)
    }
    
    var endedWithAWinner: Bool {
        legState == .completed && (homeScore > awayScore || awayScore > homeScore)
    }
    
    func score(for participant: Participant) -> Int {
        if participant == homeParticipant {
            return homeScore
        } else {
            return awayScore
        }
    }
    
    mutating func startLeg() {
        legState = .inProgress
    }
    
    mutating func completeLeg() {
        legState = .completed
    }
    
    mutating func reactivateLeg() {
        legState = .inProgress
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: MatchLeg, rhs: MatchLeg) -> Bool {
        lhs.id == rhs.id
    }
}
