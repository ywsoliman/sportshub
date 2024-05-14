//
//  SportsHubTests.swift
//  SportsHubTests
//
//  Created by Youssef Waleed on 10/05/2024.
//

import XCTest
@testable import SportsHub

final class APIServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchingLeagues() {
        let expectation = expectation(description: "Waiting for leagues API..")
        
        APIService.shared.fetchLeagues(sport: "football") { leagues in
            XCTAssertTrue(leagues.count > 0)
            expectation.fulfill()
        } onFailure: { error in
            XCTFail()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
    func testFetchingTeams() {
        let expectation = expectation(description: "Watning for team API..")
        
        APIService.shared.fetch(sport: "football", team: "80") { team in
            XCTAssertEqual(String(team.teamKey), "80")
            expectation.fulfill()
        } onFailure: { error in
            XCTFail()
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

}
