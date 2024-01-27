//
//  ParticipantRow.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/29/22.
//

import SwiftUI

struct ParticipantRow: View {
    let participant: Participant
    let deleteAction: ((_: Participant) -> Void)?
    
    init(participant: Participant, deleteAction: ((_: Participant) -> Void)? = nil) {
        self.participant = participant
        self.deleteAction = deleteAction
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(participant.playerName)
                    .font(.title3)
                Text(participant.teamName)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let deleteAction {
                deleteParticipantButton(participant: participant, deleteAction: deleteAction)
            }
        }
        .padding()
        .background()
    }
    
    private func deleteParticipantButton(participant: Participant,
                                         deleteAction: @escaping (_: Participant) -> Void) -> some View {
        Button {
            deleteAction(participant)
        } label: {
            Image(systemName: "xmark")
                .foregroundColor(.red)
        }

    }
}

struct ParticipantRow_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantRow(participant: MockData.antriksh) { _ in
            
        }
        .padding(.horizontal)
    }
}
