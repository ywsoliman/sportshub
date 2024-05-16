//
//  APIServiceMock.swift
//  SportsHubTests
//
//  Created by Youssef Waleed on 15/05/2024.
//

import Foundation
@testable import SportsHub

struct APIServiceMock {
    
    var shouldReturnError: Bool = false
    
    private let fakeLeagueJSON: [String: Any] =
    [
        "success": 1,
        "result": [
            [
                "league_key": 4,
                "league_name": "UEFA Europa League",
                "country_key": 1,
                "country_name": "eurocups",
                "league_logo": "https://apiv2.allsportsapi.com/logo/logo_leagues/",
                "country_logo": nil
            ]
        ]
    ]
    
    private let fakeTeamJSON: [String: Any] =
    [
        "success": 1,
        "result": [
            [
                "team_key": 80,
                "team_name": "Manchester City",
                "team_logo": "https://apiv2.allsportsapi.com/logo/80_manchester-city.jpg",
                "players": [
                    [
                        "player_key": 1226924072,
                        "player_image": "https://apiv2.allsportsapi.com/logo/players/8433_s-ortega.jpg",
                        "player_name": "S. Ortega",
                        "player_number": "18",
                        "player_country": nil,
                        "player_type": "Goalkeepers",
                        "player_age": "31",
                        "player_match_played": "7",
                        "player_goals": "0",
                    ]
                ]
            ]
        ]
    ]
    
    func fetchLeagues(sport: String, onCompletion: @escaping ([League]) -> Void, onFailure: @escaping (String) -> Void) {
        
        var result: LeagueResponse?
        
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeLeagueJSON)
            result = try JSONDecoder().decode(LeagueResponse.self, from: data)
        } catch {
            print(error)
        }
        
        enum ErrorType: String {
            case responseError
        }
        
        if shouldReturnError {
            onFailure(ErrorType.responseError.rawValue)
        } else {
            onCompletion(result!.result)
        }
        
    }
    
    func fetch(sport: String, team: String, onCompletion: @escaping (Team) -> Void, onFailure: @escaping (String) -> Void) {
        
        var result: TeamResponse?
        
        do {
            let data = try JSONSerialization.data(withJSONObject: fakeLeagueJSON)
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
            onCompletion(result!.result[0])
        }
        
    }
    
}
