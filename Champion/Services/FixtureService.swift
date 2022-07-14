//
//  FixtureService.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/12/22.
//

import Foundation

struct FixtureService {
    static let shared = FixtureService()
    
    func createFixtures(for participants: [Participant], matchesPerOpponent: Int, legsPerMatch: Int) -> [Round] {
        var rounds = [Round]()
        for _ in 0 ..< participants.count - 1 {
            rounds.append(Round())
        }
        
        var participantMatches = [String: [Match]]()
        for participant in participants {
            participantMatches[participant.id] = []
        }
        
        for i in 0 ..< participants.count {
            for j in 0 ..< participants.count {
                if i == j {
                    continue
                }
                
                let participant1 = participants[i]
                let participant2 = participants[j]
                
                let match = Match(participant1: participant1, participant2: participant2, legsPerMatch: legsPerMatch)
                participantMatches[participant1.id]!.append(match)
            }
        }
        
        let participantIds = participants.compactMap({ $0.id })
        var index = 0
        
        while !rounds.allSatisfy({ $0.isFull(when: participants.count) }) {
            if index >= participantIds.count {
                index = 0
            }
            
            let participantId = participantIds[index]
            
            guard !participantMatches[participantId]!.isEmpty else {
                index += 1
                continue
            }
            
            let match = participantMatches[participantId]!.removeFirst()
            
            let participant1 = match.participant1
            let participant2 = match.participant2
            
            participantMatches[participant2.id]!.removeAll(where: { $0.participant1 == participant2 && $0.participant2 == participant1 })
            
            add(match: match, rounds: &rounds)
            
            index += 1
        }
        
        return rounds
    }
    
    private func add(match: Match, rounds: inout [Round]) {
        for i in 0 ..< rounds.count {
            if !rounds[i].containsConflictingMatch(potentialMatch: match) {
                rounds[i].fixtures.append(match)
                break
            }
        }
    }
    
    /*
     * General Ideas:
     *  - Create and add matches to a Set by doing a double-for loop over the participants
     *  - Convert the Set back into an Array
     *  - Shuffle the Array for added randomization
     *  - Go double for-loop over the Array to create Round objects
     *      - Add only matches where a participant doesn't already exist within the round
     *      - Add up to 5 matches per round (times the number of matches per opponent)
     *          - Also add as many legs as needed
     *  - Shuffle each Round's matches
     */
    func createFixturesOld(for participants: [Participant], matchesPerOpponent: Int, legsPerMatch: Int) -> [Round] {
        var matchesSet: Set<Match> = Set([])
        
        for i in 0 ..< participants.count {
            for j in i + 1 ..< participants.count {
                let participant1 = participants[i]
                let participant2 = participants[j]
                
                for matchCount in 0 ..< matchesPerOpponent {
                    if matchCount % 2 == 0 {
                        let match = Match(participant1: participant1, participant2: participant2, legsPerMatch: legsPerMatch)
                        matchesSet.insert(match)
                    } else {
                        let match = Match(participant1: participant2, participant2: participant1, legsPerMatch: legsPerMatch)
                        matchesSet.insert(match)
                    }
                }
            }
        }
        
        let shuffledMatches = Array(matchesSet)//.shuffled()
//        let data = try! JSONEncoder().encode(shuffledMatches)
//        let stringJson = String(data: data, encoding: .utf8)!
//        print("YOOOOOO")
//        print(stringJson)
//        print("YOOOOOO")
        
        var rounds = [Round]()
        var addedMatches = Set<Match>()
        
        var index = 0
        var currentRound = Round()
        let maxMatchesPerRound = participants.count / 2
        
        while addedMatches.count != shuffledMatches.count {
            if (index >= shuffledMatches.count) {
                index = 0
            }
            
            let match = shuffledMatches[index]
            
            guard !addedMatches.contains(match), !currentRound.containsConflictingMatch(potentialMatch: match) else {
                index += 1
                continue
            }
            
            currentRound.fixtures.append(match)
            addedMatches.insert(match)
            
            if currentRound.fixtures.count == maxMatchesPerRound {
                currentRound.fixtures.shuffle()
                rounds.append(currentRound)
                currentRound = Round()
            }
            
            index += 1
        }
        
        rounds.shuffle()
        
        return rounds
    }
}
