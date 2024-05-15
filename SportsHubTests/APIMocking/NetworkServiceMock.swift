//
//  NetworkServiceMock.swift
//  SportsHubTests
//
//  Created by Anas Salah on 15/05/2024.
//

import Foundation
import Alamofire

@testable import SportsHub

struct NetworkServiceMock {
    
    var shouldReturnError: Bool
    
    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
    let fakeLatestEventResponseJSON: [String: Any] = [
        "success": 1,
        "result": [
            "homeTeamLogo": "TestLogo1",
            "awayTeamLogo": "TestLogo2",
            "awayTeamName": "TestName",
            "finalResultLbl": "TestRes",
            "homeTeamName": "TestTeamName"
        ]
    ]

    
    let fakeTeamsResponseJSON: [String: Any] =
    [
        "success": 1,
        "result": [
            "teamKey": 207,
            "teamName": "String teamName",
            "teamLogo": "String teamLogo"
        ]
    ]
    
    let fakeUpComingEventResultJSON: [String: Any] = [
        "success": 1,
        "result": [
            [
                "event_home_team": "Test_event_home_team",
                "league_round": "Test",
                "event_final_result": "Test",
                "home_team_logo": "Test",
                "event_date": "Test",
                "league_name": "Test",
                "event_key": 207,
                "event_away_team": "Test",
                "event_time": "Test",
                "league_logo": "Test",
                "away_team_logo": "Test"
            ]
        ]
    ]

    
}


extension NetworkServiceMock {
    
    func fetchUpComingRes(sport: String, onCompletion: @escaping ([UpComingEvents]) -> Void, onFailure: @escaping (String) -> Void) {
        
        var result: UpComingEventResult?
        
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeUpComingEventResultJSON)
            print("JSON Data:", String(data: data, encoding: .utf8) ?? "Invalid JSON data")
            result = try JSONDecoder().decode(UpComingEventResult.self, from: data)
        } catch {
            print("Decoding Error:", error)
        }
        
        enum ErrorType: String {
            case responseError
        }
        
        if shouldReturnError {
            print("Returning error.")
            onFailure(ErrorType.responseError.rawValue)
        } else {
            print("Returning result.")
            onCompletion(result!.result)
        }
    }

    
    func fetchLatestEventResponse(sport: String, onCompletion: @escaping ([LatestEvent]) -> Void, onFailure: @escaping (String) -> Void) {
        
        var result: LatestEventResponse?
        
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeLatestEventResponseJSON)
            result = try JSONDecoder().decode(LatestEventResponse.self, from: data)
        } catch {
            print(error)
        }
        
        enum ErrorType: String {
            case responseError
        }
        
        if shouldReturnError {
            onFailure(ErrorType.responseError.rawValue)
        } else {
            if let result = result {
                onCompletion(result.result)
            } else {
                onFailure("Error: Result is nil")
            }
        }
    }
    
    func fetchTeam(sport: String, onCompletion: @escaping ([Team]) -> Void, onFailure: @escaping (String) -> Void) {
        var result: TeamResponse?
        
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeTeamsResponseJSON)
            result = try JSONDecoder().decode(TeamResponse.self, from: data)
        } catch {
            print(error)
        }
        
        enum ErrorType: String {
            case responseError
        }
        
        if shouldReturnError {
            onFailure(ErrorType.responseError.rawValue)
        } else {
            if let result = result {
                onCompletion(result.result)
            } else {
                onFailure("Error: Result is nil")
            }
        }
    }


}
