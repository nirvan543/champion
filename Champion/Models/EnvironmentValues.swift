//
//  EnvironmentValues.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import Foundation

class EnvironmentValues: ObservableObject {
    private static let tournamentsFilePath = "tournaments"
    
    @Published var tournaments: [any Tournament] {
        didSet {
            do {
                try Self.save(tournaments: tournaments)
            } catch {
                fatalError("Could not save tournaments. Error: \(error)")
            }
        }
    }
    @Published var selectedTournamentId: String?
    @Published var navigateToCreateTournamentView: Bool
    
    convenience init() {
        self.init(tournaments: [],
                  selectedTournamentId: nil,
                  navigateToCreateTournamentView: false)
    }
    
    convenience init(tournaments: [any Tournament]) {
        self.init(tournaments: tournaments,
                  selectedTournamentId: nil,
                  navigateToCreateTournamentView: false)
    }
    
    private init(tournaments: [any Tournament], selectedTournamentId: String?, navigateToCreateTournamentView: Bool) {
        self.tournaments = tournaments
        self.selectedTournamentId = selectedTournamentId
        self.navigateToCreateTournamentView = navigateToCreateTournamentView
    }
    
    var selectedTournament: (any Tournament)? {
        guard let selectedTournamentId = selectedTournamentId else {
            return nil
        }
        
        guard let tournament = tournaments.first(where: { $0.id == selectedTournamentId }) else {
            fatalError("Could not find tournament with id \(selectedTournamentId)")
        }
        
        return tournament
    }
    
    func addTournament(tournament: any Tournament) {
        tournaments.append(tournament)
        tournaments.sort(by: { $0.date < $1.date })
    }
    
    static func loadTournaments() throws -> [any Tournament] {
        let fileUrl = try fileURL()
        
        guard let file = try? FileHandle(forReadingFrom: fileUrl) else {
            return []
        }
        
        let tournamentStorage = try JSONDecoder().decode(TournamentStorage.self, from: file.availableData)
        return tournamentStorage.tournaments
    }
    
    static func save(tournaments: [any Tournament]) throws {
        let tournamentStorage = TournamentStorage(tournaments: tournaments)
        let data = try JSONEncoder().encode(tournamentStorage)
        let outfile = try fileURL()
        try data.write(to: outfile)
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
            .appendingPathComponent(tournamentsFilePath)
    }
    
    struct TournamentStorage: Codable {
        private var roundRobinTournaments: [RoundRobinTournament]
        
        init(tournaments: [any Tournament]) {
            roundRobinTournaments = [RoundRobinTournament]()
            bucketTournaments(tournaments: tournaments)
        }
        
        mutating func bucketTournaments(tournaments: [any Tournament]) {
            for tournament in tournaments {
                switch tournament.format {
                case .roundRobin:
                    roundRobinTournaments.append(tournament as! RoundRobinTournament)
                }
            }
        }
        
        var tournaments: [any Tournament] {
            roundRobinTournaments.sorted(by: { $0.date < $1.date })
        }
    }
}
