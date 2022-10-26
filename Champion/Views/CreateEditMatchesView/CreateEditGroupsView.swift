//
//  CreateEditGroupedTournamentMatchesView.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/24/22.
//

import SwiftUI

struct CreateEditGroupsView: View {
    @State private var groups = [TournamentGroup]()
    @State private var participants: [Participant]
    
    @State private var navigateToCreateMatchesView = false
    @State private var formError: ChampionError? = nil
    @State private var presentFormErrorAlert = false
    
    let tournamentInfo: TournamentInfo?
    
    init(tournamentInfo: TournamentInfo) {
        self.tournamentInfo = tournamentInfo
        _participants = State(initialValue: tournamentInfo.participants)
    }
    
    var body: some View {
        PageView {
            if !participants.isEmpty {
                PageSection("Participants") {
                    ForEach(participants) { participant in
                        participantRow(for: participant)
                    }
                }
            }
            ForEach(Array(groups.enumerated()), id: \.element) { index, group in
                PageSection("Group \(index + 1)") {
                    ForEach(group.participants) { participant in
                        groupParticipantRow(participant: participant, groupIndex: index)
                    }
                }
            }
            
            addGroupButton
            
            PageSection {
                Button {
                    if groups.contains(where: { $0.participants.isEmpty }) {
                        formError = ChampionError(errorMessage: "There are groups with no participants")
                        presentFormErrorAlert = true
                    } else {
                        navigateToCreateMatchesView = true
                    }
                } label: {
                    Text("Create Matches")
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!participants.isEmpty)
            }
            
            if let tournamentInfo {
                NavigationLink(isActive: $navigateToCreateMatchesView) {
                    CreateEditGroupedMatchesView(tournamentInfo: tournamentInfo, groups: groups)
                } label: {
                    EmptyView()
                }
            }
        }
        .navigationTitle("Create Groups")
        .navigationBarTitleDisplayMode(.inline)
        .alert("There are some errors", isPresented: $presentFormErrorAlert) {
            Button("Dismiss", role: .cancel, action: {})
        } message: {
            if let formError = formError {
                Text(formError.errorMessage)
            } else {
                Text("There are some form errors")
            }
        }
    }
    
    private func participantRow(for participant: Participant) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(participant.playerName)
                    .font(.title3)
                Text(participant.clubSelection.clubName)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if !groups.isEmpty {
                Menu("Group") {
                    ForEach(Array(groups.enumerated()), id: \.element.id) { index, group in
                        Button("Group \(index + 1)") {
                            groups[index].participants.append(participant)
                            participants.removeAll(where: { $0 == participant })
                        }
                    }
                }
            }
        }
        .padding()
        .background()
    }
    
    private func groupParticipantRow(participant: Participant, groupIndex: Int?) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(participant.playerName)
                    .font(.title3)
                Text(participant.clubSelection.clubName)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if let groupIndex = groupIndex {
                deleteParticipantButton(participant: participant, from: groupIndex)
            }
        }
        .padding()
        .background()
    }
    
    private func deleteParticipantButton(participant: Participant, from groupIndex: Int) -> some View {
        Button {
            groups[groupIndex].participants.removeAll(where: { $0 == participant })
            participants.append(participant)
        } label: {
            Image(systemName: "xmark")
                .foregroundColor(.red)
        }
    }
    
    private var addGroupButton: some View {
        HStack {
            Spacer()
            Button {
                groups.append(TournamentGroup())
            } label: {
                Text("+ Add Group")
            }
            Spacer()
        }
    }
}

struct CreateEditGroupsView_Previews: PreviewProvider {
    private static let tournamentInfo = TournamentInfo(tournamentName: "FIFA Pro World Cup IV",
                                                       tournamentDate: Date(),
                                                       fifaVersionName: "FIFA 23",
                                                       tournamentFormat: .grouped,
                                                       participants: MockData.participants)
    
    static var previews: some View {
        NavigationView {
            CreateEditGroupsView(tournamentInfo: tournamentInfo)
        }
    }
}
