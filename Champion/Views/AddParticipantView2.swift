//
//  AddParticipantView2.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/14/22.
//

import SwiftUI

struct AddParticipantView2: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @FocusState private var inputIsActive: Bool
    
    @State private var participantName: String = ""
    
    @State private var clubTypeOptionName: String? = nil
    @State private var countryLeagueName: String? = nil
    @State private var clubName: String? = nil
    
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
            }
            
            Section {
                Picker("Country/Team Type", selection: $clubTypeOptionName) {
                    Text("Select...").tag(String?.none)
                    ForEach(options) { option in
                        Text(option.name).tag(option.name as String?)
                    }
                }
            }
            
            if let leagues = clubTypeOption?.leagues {
                Section {
                    Picker("League", selection: $countryLeagueName) {
                        Text("Select...").tag(String?.none)
                        ForEach(leagues) { league in
                            Text(league.name).tag(league.name as String?)
                        }
                    }
                }
            }
            
            Section {
                Picker("Club", selection: $clubName) {
                    Text("Select...").tag(String?.none)
                    ForEach(clubOptions) { club in
                        Text(club.name).tag(club.name as String?)
                    }
                }
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
            guard formIsValid,
                  let clubTypeOption = clubTypeOption,
                  let club = club else {
                presentFormErrorAlert = true
                return
            }
            
            let clubSelection = ClubSelection(clubName: club.name,
                                              leagueName: countryLeague?.name,
                                              clubAssociation: clubTypeOption.name)
            
            participants.wrappedValue.append(Participant(id: IdUtils.newUuid,
                                                         playerName: participantName,
                                                         clubSelection: clubSelection,
                                                         imageName: "fifa_logo"))
            
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
    }
    
    private var formIsValid: Bool {
        if participantName.isEmpty {
            formError = ChampionError(errorMessage: "Participant Name is required.")
            return false
        }
        
        guard let clubTypeOption = clubTypeOption else {
            formError = ChampionError(errorMessage: "Country/Team Type is required.")
            return false
        }
        
        if clubTypeOption.leagues != nil, countryLeagueName == nil {
            formError = ChampionError(errorMessage: "League Name is required")
            return false
        }
        
        if clubName == nil {
            formError = ChampionError(errorMessage: "Club Name is required")
            return false
        }
        
        return true
    }
    
    private var fifaVersions: [FifaVersion] {
        catalogService.fifaVersions
    }
    
    private var clubOptions: [FootballClub] {
        if let clubs = clubTypeOption?.clubs {
            return clubs
        } else if let league = countryLeague {
            return league.clubs
        } else {
            return []
        }
    }
    
    private var options: [ClubTypeOption] {
        return catalogService.selectionOptions(for: fifaVersion)
    }
    
    private var clubTypeOption: ClubTypeOption? {
        guard let clubTypeOptionName = clubTypeOptionName else {
            return nil
        }
        
        guard let option = options.first(where: { $0.name == clubTypeOptionName }) else {
            fatalError("Could not find ClubTypeOption with name \(clubTypeOptionName)")
        }
        
        return option
    }
    
    private var countryLeague: FootballLeague? {
        guard let countryLeagueName = countryLeagueName,
              let clubTypeOption = clubTypeOption else {
            return nil
        }
        
        guard let footballLeague = clubTypeOption.leagues?.first(where: { $0.name == countryLeagueName }) else {
            fatalError("Could not find FootballLeague with name \(countryLeagueName) in \(clubTypeOption.name)")
        }
        
        return footballLeague
    }
    
    private var club: FootballClub? {
        guard let clubName = clubName,
              let clubTypeOption = clubTypeOption else {
            return nil
        }
        
        if let footballClub = clubTypeOption.clubs?.first(where: { $0.name == clubName }) {
            return footballClub
        } else if let footballClub = countryLeague?.clubs.first(where: { $0.name == clubName }) {
            return footballClub
        } else {
            fatalError("Could not find FootballClub with name \(clubName) in \(clubTypeOption.name)")
        }
    }
}

struct AddParticipantView2_Previews: PreviewProvider {
    @State private static var participants = MockData.participants
    @State private static var fifaVersion = ClubCatalogService.shared.defaultSelections.fifaVersion
    
    static var previews: some View {
        AddParticipantView2(participants: $participants, fifaVersion: fifaVersion)
    }
}
