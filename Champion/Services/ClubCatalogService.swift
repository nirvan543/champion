//
//  ClubCatalogService.swift
//  Champion
//
//  Created by Nirvan Nagar on 9/11/22.
//

import Foundation

class ClubCatalogService {
    static let shared = ClubCatalogService()
    
    private let catalogFile = "fifa_versions"
    private let catalogFileExtension = "json"
    
    private var cachedFifaVersions: [FifaVersion]? = nil
    
    var fifaVersions: [FifaVersion] {
        if let cachedFifaVersions = cachedFifaVersions {
            return cachedFifaVersions
        }
        
        guard let url = Bundle.main.url(forResource: catalogFile, withExtension: catalogFileExtension),
              let data = try? Data(contentsOf: url) else {
            fatalError("Could not read the \(catalogFile).\(catalogFileExtension)")
        }
        
        do {
            let catalog = try JSONDecoder().decode([FifaVersion].self, from: data)
                .sorted(by: { $0.name > $1.name })
            cachedFifaVersions = catalog
            return catalog
        } catch {
            fatalError("Could not decode the contents of \(catalogFile).\(catalogFileExtension) as \([FifaVersion].self). Error: \(error)")
        }
    }
    
    func selectionOptions(for fifaVersion: FifaVersion) -> [ClubTypeOption] {
        let countryOptions = fifaVersion.clubCatalog.countries.compactMap { country in
            ClubTypeOption(name: country.name, leagues: country.leagues, clubs: nil)
        }
        
        let nationalOptions = fifaVersion.clubCatalog.national.compactMap { league in
            ClubTypeOption(name: league.name, leagues: nil, clubs: league.clubs)
        }
        
        let organizationOptions = fifaVersion.clubCatalog.organizations.compactMap { organization in
            ClubTypeOption(name: organization.name, leagues: organization.leagues, clubs: nil)
        }
        
        let otherOptions = fifaVersion.clubCatalog.other.compactMap { league in
            ClubTypeOption(name: league.name, leagues: nil, clubs: league.clubs)
        }
        
        var options = countryOptions + nationalOptions + organizationOptions + otherOptions
        options = options.sorted(by: { $0.name < $1.name })
        
        return options
    }
    
    var defaultFifaVersion: FifaVersion {
        guard let latestVersion = fifaVersions.first else {
            fatalError("The FIFA version catalog is empty.")
        }
        
        return latestVersion
    }
}

struct ClubTypeOption: Identifiable, Hashable {
    var id: String {
        name
    }
    
    let name: String
    let leagues: [FootballLeague]?
    let clubs: [FootballClub]?
}

struct FifaVersion: Decodable, Identifiable, Hashable, Equatable {
    var id: String {
        name
    }
    
    let name: String
    let clubCatalog: FifaClubCatalog
}

struct FifaClubCatalog: Decodable, Hashable, Equatable {
    let countries: [Country]
    let national: [FootballLeague]
    let organizations: [FootballOrganization]
    let other: [FootballLeague]
}

struct Country: Decodable, Identifiable, Hashable, Equatable {
    var id: String {
        name
    }
    
    let name: String
    let leagues: [FootballLeague]
}

struct FootballLeague: Decodable, Identifiable, Hashable, Equatable {
    var id: String {
        name
    }
    
    let name: String
    let clubs: [FootballClub]
}

struct FootballClub: Decodable, Identifiable, Hashable, Equatable {
    var id: String {
        name
    }
    
    let name: String
}

struct FootballOrganization: Decodable, Hashable, Equatable {
    let name: String
    let leagues: [FootballLeague]
}
