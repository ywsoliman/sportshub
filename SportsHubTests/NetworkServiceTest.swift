//
//  NetworkService.swift
//  SportsHubTests
//
//  Created by Anas Salah on 15/05/2024.
//

import XCTest
@testable import SportsHub

final class NetworkServiceTest: XCTestCase {
    
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
        
    }
    
    func testFetchingLeagues() {
        
        let expectation = expectation(description: "Waiting for leagues API..")
        
        NetworkService.shared.fetch(dataType: LeagueResponse.self, sport: "football", met: "Leagues") { response in
            XCTAssertTrue(response.result.count > 0)
            expectation.fulfill()
        } onFailure: { error in
            XCTFail()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30)
        
    }
    
    func testFetchingTeams() {
        
        let expectation = expectation(description: "Waiting for leagues API..")
        
        NetworkService.shared.fetch(dataType: TeamResponse.self, sport: "football", met: "Teams", parameters: ["teamId" : 80]) { response in
            XCTAssertEqual(response.result[0].teamKey, 80)
            expectation.fulfill()
        } onFailure: { error in
            XCTFail()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30)
        
    }
    
    
    // MARK: ... testing the NetwrokService
    
    func testFetchDataFromAPI() {
        let myExpectation = expectation(description: "w8 For Res from API ....")
        
        let parameters: [String: Any] = [
            "leagueId": "207",
        ]
        
        NetworkService.shared.fetch(dataType: TeamsResponse.self, sport: "football", met: "Teams", parameters: parameters) { data in
            
            if data.result.isEmpty {
                XCTFail()
            } else {
                XCTAssertGreaterThan(data.result.count, 0)
            }
            
            myExpectation.fulfill()
        } onFailure: { error in
            print("Error: \(error)")
            XCTFail()
            myExpectation.fulfill()
        }
        waitForExpectations(timeout: 30)
    }
    
    func testFetchDataFromAPIOnFail() {
        let myExpectation = expectation(description: "w8 For Res from API ....")
        
        let parameters: [String: Any] = [
            "leagueId": "154815AASDDF544515",
        ]
        
        NetworkService.shared.fetch(dataType: TeamsResponse.self, sport: "football", met: "Teams", parameters: parameters) { data in
            
        } onFailure: { error in
            print("Error: \(error)")
            myExpectation.fulfill()
            // HERE TESET IT WILL FAIL
        }
        waitForExpectations(timeout: 30)
    }
}
