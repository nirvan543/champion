//
//  AddParticipantView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/10/22.
//

import SwiftUI

struct AddParticipantView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var imageSelection = "fifa_logo"
    @State private var playerName = ""
    @State private var teamName = ""
    
    @FocusState private var inputIsActive: Bool
    
    private let imageOptions = MockTournamentRepository.shared.retrieveImageOptions()
    private let matchCellShape = Rectangle()
    
    @Binding var particiapnts: [Participant]
    
    var body: some View {
        VStack {
            imageSection
            TextField("Player name", text: $playerName)
                .textFieldStyle(.roundedBorder)
                .focused($inputIsActive)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            inputIsActive = false
                        }
                    }
                }
            TextField("Team name", text: $teamName)
                .textFieldStyle(.roundedBorder)
                .focused($inputIsActive)
            Spacer()
            Button {
                guard !playerName.isEmpty, !teamName.isEmpty else {
                    return
                }
                
                particiapnts.append(Participant(id: IdUtils.newUuid,
                                                playerName: playerName,
                                                teamName: teamName,
                                                image: Image(imageSelection)))
                
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
            }
            .background(DesignValues.themeColor)
            .padding(.bottom)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(DesignValues.pageColor.ignoresSafeArea())
        .navigationTitle("Add Participant")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                }

            }
        }
    }
    
    @ViewBuilder
    private var imageSection: some View {
        VStack {
            Image(imageSelection)
                .resizable()
                .frame(width: 250, height: 250)
                .aspectRatio(contentMode: .fill)
            
            Picker("Change Image", selection: $imageSelection) {
                ForEach(imageOptions, id: \.self) { imageOption in
                    Text(imageOption)
                }
            }
        }
    }
}

struct AddParticipantView_Previews: PreviewProvider {
    @State private static var participants = TestData.participants
    
    static var previews: some View {
        NavigationView {
            AddParticipantView(particiapnts: $participants)
        }
    }
}
