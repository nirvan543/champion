//
//  GroupedTournamentProgressView.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/26/22.
//

import SwiftUI

struct GroupedTournamentProgressView: View {
    @Binding var tournament: GroupedTournament
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct GroupedTournamentProgressView_Previews: PreviewProvider {
    @State private static var tournament = MockData.proWorldCup4
    
    static var previews: some View {
        GroupedTournamentProgressView(tournament: $tournament)
    }
}
