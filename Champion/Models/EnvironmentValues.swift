//
//  EnvironmentValues.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/9/22.
//

import Foundation

class EnvironmentValues: ObservableObject {
    private static let tournamentsFilePath = "tournaments2"
    
    @Published var tournaments: [Tournament] {
        didSet {
            do {
                try Self.save(tournaments: tournaments)
            } catch {
                fatalError("Could not save tournaments. Error: \(error)")
            }
        }
    }
    @Published var selectedTournamentId: String?
    
    convenience init() {
        self.init(tournaments: [], selectedTournamentId: nil)
    }
    
    convenience init(tournaments: [Tournament]) {
        self.init(tournaments: tournaments, selectedTournamentId: nil)
    }
    
    private init(tournaments: [Tournament], selectedTournamentId: String?) {
        self.tournaments = tournaments
        self.selectedTournamentId = selectedTournamentId
    }
    
    var selectedTournament: Tournament? {
        guard let selectedTournamentId = selectedTournamentId else {
            return nil
        }
        
        guard let tournament = tournaments.first(where: { $0.id == selectedTournamentId }) else {
            fatalError("Could not find tournament with id \(selectedTournamentId)")
        }
        
        return tournament
    }
    
    func addTournament(tournament: Tournament) {
        tournaments.append(tournament)
        tournaments.sort(by: { $0.date < $1.date })
    }
    
    static func loadTournaments() throws -> [Tournament] {
        let fileUrl = try fileURL()
        
        guard let file = try? FileHandle(forReadingFrom: fileUrl) else {
            return []
        }
        
        let tournaments = try JSONDecoder().decode([Tournament].self, from: file.availableData)
        return tournaments.sorted(by: { $0.date < $1.date })
    }
    
    static func save(tournaments: [Tournament]) throws {
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
