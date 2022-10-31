//
//  ParticipantsListView.swift
//  Champion
//
//  Created by Nirvan Nagar on 10/30/22.
//

import SwiftUI

struct ParticipantsListView: View {
    let participants: [Participant]
    let deleteAction: ((_: Participant) -> Void)?
    let addParticipantAction: (() -> Void)?
    
    init(participants: [Participant],
         deleteAction: ((_: Participant) -> Void)? = nil,
         addParticipantAction: (() -> Void)? = nil) {
        
        self.participants = participants
        self.deleteAction = deleteAction
        self.addParticipantAction = addParticipantAction
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(participants) { participant in
                ParticipantRow(participant: participant, deleteAction: deleteAction)
            }
            
            if let addParticipantAction {
                addParticipantButton(addParticipantAction: addParticipantAction)
            }
        }
    }
    
    private func addParticipantButton(addParticipantAction: @escaping () -> Void) -> some View {
        Button(action: addParticipantAction) {
            Text("+ Add Participant")
                .font(.headline)
                .foregroundColor(Design.themeColor)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity)
        }
    }
}

struct ParticipantsListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PageView {
                PageSection {
                    ParticipantsListView(participants: MockData.participants,
                                         deleteAction: { _ in },
                                         addParticipantAction: { })
                }
            }
            PageView {
                PageSection {
                    ParticipantsListView(participants: MockData.participants,
                                         deleteAction: nil,
                                         addParticipantAction: nil)
                }
            }
        }
    }
}
