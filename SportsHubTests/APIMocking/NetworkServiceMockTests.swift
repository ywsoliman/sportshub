//
//  NetworkServiceMockTests.swift
//  SportsHubTests
//
//  Created by Youssef Waleed on 16/05/2024.
//

import XCTest
@testable import SportsHub

final class NetworkServiceMockTests: XCTestCase {
    
    var networkObj: NetworkServiceMock!

    override func setUpWithError() throws {
        networkObj = NetworkServiceMock()
    }

    override func tearDownWithError() throws {
        networkObj = nil
    }
    
    func testFetchLeaguesFailure() {
        networkObj.shouldReturnError = true
        networkObj.fetchLeagues(sport: "football") { leagues in
            XCTAssertTrue(leagues.count > 0)
        } onFailure: { error in
            XCTFail()
        }
    }
    
    func testFetchLeaguesSuccess() {
        networkObj.shouldReturnError = false
        networkObj.fetchLeagues(sport: "football") { leagues in
            XCTAssertTrue(leagues.count > 0)
        } onFailure: { error in
            XCTFail()
        }
    }
    
    func testFetchTeamsFailure() {
        networkObj.shouldReturnError = true
        networkObj.fetch(sport: "football", team: "80") { team in
            XCTAssertEqual(team.teamKey, 80)
        } onFailure: { error in
            XCTFail()
        }

    }
    
    func testFetchTeamsSuccess() {
        networkObj.shouldReturnError = false
        networkObj.fetchLeagues(sport: "football") { leagues in
            XCTAssertTrue(leagues.count > 0)
        } onFailure: { error in
            XCTFail()
        }
    }
    
    func testfetchUpComingRes() {
        networkObj.fetchUpComingRes(sport: "football") { events in
            XCTAssertTrue(events.count > 0)
        } onFailure: { error in
            print(error)
            XCTFail()
        }
    }
    
    func testLatestEventResponse() {
        networkObj.fetchLatestEventResponse(sport: "football", onCompletion: { data in
            XCTAssertTrue(data.count > 0)
        }, onFailure: { error in
            print(error)
            XCTFail()
        })
    }
    
    func testTeamsResponse() {
        networkObj.fetchTeam(sport: "football") { events in
            XCTAssertTrue(events.count > 0)
        } onFailure: { error in
            print(error)
            XCTFail()
        }
    }

}
