//
//  EnvironmentValues.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import Foundation

class EnvironmentValues: ObservableObject {
    @Published var tournaments: [Tournament]
    
    init(tournaments: [Tournament]) {
        self.tournaments = tournaments
    }
}
