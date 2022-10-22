//
//  EnvironmentValues.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import Foundation

class EnvironmentValues: ObservableObject {
    private static let tournamentsFilePath = "tournaments"
    
    @Published var tournaments: [RoundRobinTournament] {
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
    
    convenience init(tournaments: [RoundRobinTournament]) {
        self.init(tournaments: tournaments,
                  selectedTournamentId: nil,
                  navigateToCreateTournamentView: false)
    }
    
    private init(tournaments: [RoundRobinTournament], selectedTournamentId: String?, navigateToCreateTournamentView: Bool) {
        self.tournaments = tournaments
        self.selectedTournamentId = selectedTournamentId
        self.navigateToCreateTournamentView = navigateToCreateTournamentView
    }
    
    var selectedTournament: RoundRobinTournament? {
        guard let selectedTournamentId = selectedTournamentId else {
            return nil
        }
        
        guard let tournament = tournaments.first(where: { $0.id == selectedTournamentId }) else {
            fatalError("Could not find tournament with id \(selectedTournamentId)")
        }
        
        return tournament
    }
    
    func addTournament(tournament: RoundRobinTournament) {
        tournaments.append(tournament)
        tournaments.sort(by: { $0.date < $1.date })
    }
    
    static func loadTournaments() throws -> [RoundRobinTournament] {
        let fileUrl = try fileURL()
        
        guard let file = try? FileHandle(forReadingFrom: fileUrl) else {
            return []
        }
        
        let tournaments = try JSONDecoder().decode([RoundRobinTournament].self, from: file.availableData)
        return tournaments.sorted(by: { $0.date < $1.date })
    }
    
    static func save(tournaments: [RoundRobinTournament]) throws {
        let data = try JSONEncoder().encode(tournaments)
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
}
