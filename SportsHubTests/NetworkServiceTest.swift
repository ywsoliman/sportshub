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
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchDataFromAPI() {
        let myExpectation = expectation(description: "w8 For Res from API ....")
        
        let parameters: [String: Any] = [
            "leagueId": "207",
        ]
        
        NetworkService.shared.fetch(dataType: TeamsResponse.self, league: "football", met: "Teams", parameters: parameters) { data in
            
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

    
    
    
    
    
    
    
    
    
    
    
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
