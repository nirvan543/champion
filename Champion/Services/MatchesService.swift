//
//  MatchesService.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/12/22.
//

import Foundation

struct MatchesService {
    static let shared = MatchesService()
    
    // Courtesy: https://stackoverflow.com/questions/6648512/scheduling-algorithm-for-a-round-robin-tournament
    func createMatches(participants: [Participant], legsPerMatch: Int, matchesPerOpponent: Int) -> [Round] {
        var players: [Participant?] = participants
        
        if players.count % 2 == 1 {
            players.append(nil)
        }
        
        players.shuffle()
        
        let playerCount = players.count
        let numberOfRounds = playerCount - 1
        let half = playerCount / 2
        
        var rounds = [Round]()
        var playerIndices = players.enumerated().map { index, _ in return index }
        playerIndices = playerIndices.suffix(playerIndices.count - 1)
        
        for _ in 0 ..< matchesPerOpponent { // Added to add multiple matches per opponent
            for _ in 0 ..< numberOfRounds {
                var round = Round()
                
                let newPlayerIndices: [Int] = [0] + playerIndices
                let firstHalf: [Int] = Array(newPlayerIndices.prefix(half))
                let secondHalf: [Int] = Array(newPlayerIndices.suffix(half).reversed())
                
                for i in 0 ..< firstHalf.count {
                    let player1Index = firstHalf[i]
                    let player2Index = secondHalf[i]
                    
                    let player1 = players[player1Index]
                    let player2 = players[player2Index]
                    
                    var match: Match
                    if let player1 = player1 {
                        match = Match(participant1: player1,
                                      participant2: player2,
                                      legsPerMatch: legsPerMatch)
                    } else if let player2 = player2 {
                        match = Match(participant1: player2,
                                      participant2: player1,
                                      legsPerMatch: legsPerMatch)
                    } else {
                        fatalError("Expected at least one player to be non-nil")
                    }
                    
                    round.matches.append(match)
                }
                
                let firstIndex = playerIndices.removeFirst()
                playerIndices.append(firstIndex)
                rounds.append(round)
            }
        }
        
        return rounds
    }
}
