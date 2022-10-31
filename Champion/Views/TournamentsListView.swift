//
//  TournamentsListView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import SwiftUI

struct TournamentsListView: View {
    @EnvironmentObject private var environmentValues: EnvironmentValues
    @State private var tournamentIndexToDelete: IndexSet? = nil
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        List {
            ForEach($environmentValues.tournaments, id: \.id) { tournament in
                NavigationLink(tag: tournament.wrappedValue.id, selection: $environmentValues.selectedTournamentId) {
                    TournamentDetailView(tournament: tournament)
                } label: {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(tournament.wrappedValue.name)
                            .font(.title3)
                        Text(DateUtils.displayString(for: tournament.wrappedValue.date, dateStyle: .medium))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 12)
                }
            }
            .onDelete { offsets in
                tournamentIndexToDelete = offsets
                showDeleteConfirmation = true
            }
        }
        .navigationTitle("Tournaments")
        .toolbar {
            NavigationLink(isActive: $environmentValues.navigateToCreateTournamentView) {
                AddEditTournamentView()
            } label: {
                Button {
                    environmentValues.navigateToCreateTournamentView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .alert(deleteAlertTitle, isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                guard let tournamentIndexToDelete else {
                    fatalError("Expected tournamentIndexToDelete to be non-nil")
                }
                
                environmentValues.tournaments.remove(atOffsets: tournamentIndexToDelete)
                self.tournamentIndexToDelete = nil
            }
            Button("Cancel", role: .cancel) {
                tournamentIndexToDelete = nil
            }
        }
    }
               
    private var deleteAlertTitle: String {
        guard let index = tournamentIndexToDelete?.first else {
            return ""
        }

        return String("Delete \"\(environmentValues.tournaments[index].name)\"?")
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
