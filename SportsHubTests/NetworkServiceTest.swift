//
//  NetworkService.swift
//  SportsHubTests
//
//  Created by Anas Salah on 15/05/2024.
//

import XCTest
@testable import SportsHub

final class NetworkServiceTest: XCTestCase {

    var networkObj: NetworkServiceMock!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkObj = NetworkServiceMock(shouldReturnError: false)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkObj = nil
        
    }
    
    // MARK: ... testing the NetwrokService Using MockDAta

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
}
