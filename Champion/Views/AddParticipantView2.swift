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
    
    @State private var clubTypeOption: ClubTypeOption? = nil
    @State private var countryLeague: FootballLeague? = nil
    @State private var club: FootballClub? = nil
    
    var participants: Binding<[Participant]>
    let fifaVersion: FifaVersion
    
    private let catalogService = ClubCatalogService.shared
    
    init(participants: Binding<[Participant]>, fifaVersion: FifaVersion) {
        self.participants = participants
        self.fifaVersion = fifaVersion
        
        let clubTypeOptions = catalogService.selectionOptions(for: fifaVersion)
        let clubTypeOption = clubTypeOptions.first
        let league = clubTypeOption?.leagues?.first
        let club = league?.clubs.first ?? clubTypeOption?.clubs?.first
        
        _clubTypeOption = State(initialValue: clubTypeOption)
        _countryLeague = State(initialValue: league)
        _club = State(initialValue: club)
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Participant Name", text: $participantName)
                    .focused($inputIsActive)
            }
            
            Section {
                Picker("Country/Team Type", selection: $clubTypeOption) {
                    ForEach(options) { option in
                        Text(option.name).tag(option as ClubTypeOption?)
                    }
                }
            }
            
            if let leagues = clubTypeOption?.leagues {
                Section {
                    Picker("League", selection: $countryLeague) {
                        ForEach(leagues) { league in
                            Text(league.name).tag(league as FootballLeague?)
                        }
                    }
                }
            }
            
            Section {
                Picker("Club", selection: $club) {
                    ForEach(clubOptions) { club in
                        Text(club.name).tag(club as FootballClub?)
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
    }
    
    private var saveButton: some View {
        Button {
            guard !participantName.isEmpty,
                  let clubTypeOption = clubTypeOption,
                  let club = club else {
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
    
    private var fifaVersions: [FifaVersion] {
        catalogService.fifaVersions
    }
    
    private var clubOptions: [FootballClub] {
        if let clubs = clubTypeOption?.clubs {
            return clubs
        } else if let league = countryLeague {
            return league.clubs
        } else {
            fatalError("Expected a list of football clubs from either the ClubTypeOption or the League. ClubTypeOption: \(clubTypeOption.debugDescription) | FootballLeague: \(countryLeague.debugDescription)")
        }
    }
    
    private var options: [ClubTypeOption] {
        return catalogService.selectionOptions(for: fifaVersion)
    }
}

struct AddParticipantView2_Previews: PreviewProvider {
    @State private static var participants = MockData.participants
    @State private static var fifaVersion = ClubCatalogService.shared.defaultSelections.fifaVersion
    
    static var previews: some View {
        AddParticipantView2(participants: $participants, fifaVersion: fifaVersion)
    }
}
