//
//  CreateEditGroupedTournamentMatchesView.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/24/22.
//

import SwiftUI

struct CreateEditGroupedTournamentMatchesView: View {
    @State private var groups = [TournamentGroup]()
    @State private var participants: [Participant]
    
    init(participants: [Participant]) {
        _participants = State(initialValue: participants)
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
                NavigationLink {
                    
                } label: {
                    Text("Create Matches")
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!participants.isEmpty)
            }
            
        }
        .navigationTitle("Create Groups")
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

struct CreateEditGroupedTournamentMatchesView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEditGroupedTournamentMatchesView(participants: MockData.participants)
    }
}
