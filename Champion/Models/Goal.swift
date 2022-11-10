//
//  Goal.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/25/22.
//

import Foundation

struct Goal: Identifiable, Hashable, Equatable, Codable {
    let id: String
    let scorer: Participant
    let against: Participant
    let minute: Int?
    
    init(scorer: Participant, against: Participant, minute: Int? = nil) {
        self.init(id: IdUtils.newUuid, scorer: scorer, against: against, minute: minute)
    }
    
    init(id: String, scorer: Participant, against: Participant, minute: Int?) {
        self.id = id
        self.scorer = scorer
        self.against = against
        self.minute = minute
    }
}
