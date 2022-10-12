//
//  ModelTests.swift
//  ChampionTests
//
//  Created by Nirvan Nagar on 10/11/22.
//

import XCTest
@testable import Champion

final class ModelTests: XCTestCase {

    func testV1ModelsDecodeCorrectly() throws {
        let data = try readJsonFile(fileName: "tournaments_v1", fileType: "json")
        
        let tournaments = try JSONDecoder().decode([Tournament].self, from: data)
        XCTAssertEqual(1, tournaments.count)
    }
    
    private func readJsonFile(fileName: String, fileType: String) throws -> Data {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: fileName, ofType: fileType) else {
            fatalError("\(fileName).\(fileType) not found")
        }
        
        let string = try String(contentsOfFile: pathString, encoding: .utf8)
        
        guard let data = string.data(using: .utf8) else {
            fatalError("Unable to convert \(fileName).\(fileType) to a Data type")
        }
        
        return data
    }
}
