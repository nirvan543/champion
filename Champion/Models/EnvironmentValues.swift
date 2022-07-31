//
//  EnvironmentValues.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import Foundation

class EnvironmentValues: ObservableObject {
    @Published var tournaments: [Tournament]
    @Published var selectedTournamentId: String? = nil
    
    init(tournaments: [Tournament]) {
        self.tournaments = tournaments.sorted(by: { $0.date < $1.date })
    }
}
