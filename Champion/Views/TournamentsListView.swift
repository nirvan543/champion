//
//  TournamentsListView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct TournamentsListView: View {
    @EnvironmentObject private var environmentValues: EnvironmentValues
    @State private var selectedTournamentId: String? = nil
    
    var body: some View {
        List {
            ForEach(environmentValues.tournaments.sorted(by: { $0.date < $1.date })) { tournament in
                NavigationLink(tag: tournament.id, selection: $selectedTournamentId) {
                    TournamentDetailView(tournament: tournament)
                } label: {
                    VStack(alignment: .leading) {
                        Text(tournament.name)
                            .font(.title3)
                        Text(DateUtils.displayString(for: tournament.date, dateStyle: .medium))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 12)
                }
            }
        }
        .navigationTitle("Tournaments")
        .toolbar {
            NavigationLink {
                Text("New Tournament View")
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

struct TournamentsListView_Previews: PreviewProvider {
    @StateObject private static var environmentValues = EnvironmentValues(tournaments: MockTournamentRepository.shared.retreiveTournaments())
    
    static var previews: some View {
        NavigationView {
            TournamentsListView()
                .environmentObject(environmentValues)
        }
    }
}
