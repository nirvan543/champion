//
//  ClubSelection.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct ClubSelection: Identifiable, Hashable, Equatable, Codable {
    var id: String {
        "\(clubAssociation)_\(leagueName ?? "")_\(clubName)"
    }
    
    let clubName: String
    let leagueName: String?
    let clubAssociation: String
    
    static func ==(lhs: ClubSelection, rhs: ClubSelection) -> Bool {
        lhs.clubName == rhs.clubName &&
        lhs.leagueName == rhs.leagueName &&
        lhs.clubAssociation == rhs.clubAssociation
    }
}
