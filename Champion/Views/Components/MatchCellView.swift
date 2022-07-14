//
//  MatchCellView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/12/22.
//

import SwiftUI

struct MatchCellView: View {
    private let matchCellShape = Rectangle()
    
    let player1Name: String
    let player2Name: String
    
    var body: some View {
        HStack {
            Text(player1Name)
                .font(.title3)
            Spacer()
            Text("vs")
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
            Text(player2Name)
                .font(.title3)
                .frame(alignment: .trailing)
        }
        .padding()
        .background()
        .overlay(matchCellShape.strokeBorder(.quaternary, lineWidth: 1))
    }
}

struct MatchCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MatchCellView(player1Name: "Antriksh", player2Name: "Neeraj")
            MatchCellView(player1Name: "Antriksh", player2Name: "Neeraj")
                .preferredColorScheme(.dark)
        }
    }
}
