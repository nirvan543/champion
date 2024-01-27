//
//  AddParticipantView2.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/14/22.
//

import SwiftUI

struct AddParticipantView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @FocusState private var inputIsActive: Bool
    
    @State private var participantName = ""
    @State private var teamName = ""
    
    @State private var presentFormErrorAlert = false
    @State private var formError: ChampionError? = nil
    
    var participants: Binding<[Participant]>
    let fifaVersion: FifaVersion
    
    private let catalogService = ClubCatalogService.shared
    
    init(participants: Binding<[Participant]>, fifaVersion: FifaVersion) {
        self.participants = participants
        self.fifaVersion = fifaVersion
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Participant Name", text: $participantName)
                    .focused($inputIsActive)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.words)
            }
            
            Section {
                TextField("Team Name", text: $teamName)
                    .focused($inputIsActive)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.words)
            }
            
            Section {
                saveButton
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    inputIsActive = false
                }
            }
        }
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
    
    private var saveButton: some View {
        Button {
            guard formIsValid else {
                presentFormErrorAlert = true
                return
            }
            
            participants.wrappedValue.append(
                Participant(
                    id: IdUtils.newUuid,
                    playerName: participantName,
                    teamName: teamName
                )
            )
            
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Save")
                .font(.title2)
                .foregroundColor(Color.white)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
        }
        .background(Design.themeColor)
    }
    
    private var formIsValid: Bool {
        if participantName.isEmpty {
            formError = ChampionError(errorMessage: "Participant Name is required.")
            return false
        }
        
        if teamName.isEmpty {
            formError = ChampionError(errorMessage: "Team Name is required.")
            return false
        }
        
        return true
    }
}

struct AddParticipantView_Previews: PreviewProvider {
    @State private static var participants = MockData.participants
    @State private static var fifaVersion = ClubCatalogService.shared.defaultFifaVersion
    
    static var previews: some View {
        AddParticipantView(participants: $participants, fifaVersion: fifaVersion)
    }
}
