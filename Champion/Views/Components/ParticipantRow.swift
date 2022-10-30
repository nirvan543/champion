//
//  ParticipantRow.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/29/22.
//

import SwiftUI

struct ParticipantRow: View {
    let participant: Participant
    let deleteAction: (() -> Void)?
    
    init(participant: Participant, deleteAction: (() -> Void)? = nil) {
        self.participant = participant
        self.deleteAction = deleteAction
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(participant.playerName)
                    .font(.title3)
                Text(participant.clubSelection.clubName)
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
    
    private func deleteParticipantButton(participant: Participant, deleteAction: @escaping () -> Void) -> some View {
        Button(action: deleteAction) {
            Image(systemName: "xmark")
                .foregroundColor(.red)
        }
    }
}

struct ParticipantRow_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantRow(participant: MockData.antriksh) {
            
        }
        .padding(.horizontal)
    }
}
