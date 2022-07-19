//
//  ScoreCellView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/16/22.
//

import SwiftUI

struct ScoreCellView: View {
    private let matchCellShape = Rectangle()
    
    let participant1Score: Int
    let participant2Score: Int
    
    var body: some View {
        HStack {
            Text("\(participant1Score)")
                .font(.title3)
                .padding(.leading)
            Spacer()
            Text("|")
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
            Text("\(participant2Score)")
                .font(.title3)
                .frame(alignment: .trailing)
                .padding(.trailing)
        }
        .padding()
        .background()
        .overlay(matchCellShape.strokeBorder(.quaternary, lineWidth: 1))
    }
}

struct ScoreCellView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreCellView(participant1Score: 3, participant2Score: 2)
    }
}
