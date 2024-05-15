//
//  APIServiceMockTests.swift
//  SportsHubTests
//
//  Created by Youssef Waleed on 15/05/2024.
//

import XCTest
@testable import SportsHub

final class APIServiceMockTests: XCTestCase {
    
    private var apiMock: APIServiceMock!

    override func setUpWithError() throws {
        apiMock = APIServiceMock()
    }

    override func tearDownWithError() throws {
        apiMock = nil
    }
    
    func testFetchLeaguesFailure() {
        apiMock.shouldReturnError = true
        apiMock.fetchLeagues(sport: "football") { leagues in
            XCTAssertTrue(leagues.count > 0)
        } onFailure: { error in
            XCTFail()
        }
    }
    
    func testFetchLeaguesSuccess() {
        apiMock.shouldReturnError = false
        apiMock.fetchLeagues(sport: "football") { leagues in
            XCTAssertTrue(leagues.count > 0)
        } onFailure: { error in
            XCTFail()
        }
    }
    
    func testFetchTeamsFailure() {
        apiMock.shouldReturnError = true
        apiMock.fetch(sport: "football", team: "80") { team in
            XCTAssertEqual(team.teamKey, 80)
        } onFailure: { error in
            XCTFail()
        }

    }
    
    func testFetchTeamsSuccess() {
        apiMock.shouldReturnError = false
        apiMock.fetchLeagues(sport: "football") { leagues in
            XCTAssertTrue(leagues.count > 0)
        } onFailure: { error in
            XCTFail()
        }
    }
    
    

}
