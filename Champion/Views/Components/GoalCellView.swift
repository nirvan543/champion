//
//  GoalCellView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/16/22.
//

import SwiftUI

struct GoalCellView: View {
    private let matchCellShape = Rectangle()
    
    let goal: Goal
    
    var body: some View {
        HStack {
            Text("\(goalText)")
                .font(.title3)
            Spacer()
            Text("\(goal.scorer.playerName)")
                .font(.title3)
        }
        .padding()
        .background()
        .overlay(matchCellShape.strokeBorder(.quaternary, lineWidth: 1))
    }
    
    private var goalText: String {
        if let minute = goal.minute {
            return "\(minute)'"
        } else {
            return "-"
        }
    }
}

struct GoalCellView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GoalCellView(goal: Goal(id: IdUtils.newUuid,
                                    scorer: MockData.antriksh,
                                    against: MockData.neeraj,
                                    minute: 120))
            GoalCellView(goal: Goal(id: IdUtils.newUuid,
                                    scorer: MockData.neeraj,
                                    against: MockData.antriksh,
                                    minute: 81))
            GoalCellView(goal: Goal(id: IdUtils.newUuid,
                                    scorer: MockData.antriksh,
                                    against: MockData.neeraj,
                                    minute: 14))
        }
    }
}
