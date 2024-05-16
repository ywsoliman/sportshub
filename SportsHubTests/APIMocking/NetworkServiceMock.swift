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
    
    let fakeLatestEventResponseJSON: [String: Any] = [
        "success": 1,
        "result": [
          [
            "home_team_logo": "http://example.com/home_logo_1.png",
            "away_team_logo": "http://example.com/away_logo_1.png",
            "event_away_team": "Away Team 1",
            "event_final_result": "3 - 2",
            "event_home_team": "Home Team 1"
          ],
          [          "home_team_logo": "http://example.com/home_logo_2.png",
            "away_team_logo": "http://example.com/away_logo_2.png",
            "event_away_team": "Away Team 2",
            "event_final_result": "1 - 1",
            "event_home_team": "Home Team 2"
          ]
        ]
      ]

    let fakeTeamsResponseJSON: [String: Any] =
    [
      "success": 1,
      "result": [
        [
          "team_key": 1,
          "team_name": "Team A",
          "team_logo": "http://example.com/team_a_logo.png",
          "players": [
            [
              "player_name": "Player 1",
              "position": "Forward"
            ],
            [
              "player_name": "Player 2",
              "position": "Midfielder"
            ]
          ],
          "coaches": [
            [
              "coach_name": "Coach 1",
              "role": "Head Coach"
            ],
            [
              "coach_name": "Coach 2",
              "role": "Assistant Coach"
            ]
          ]
        ]
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
            print("JSON Data:", String(data: data, encoding: .utf8) ?? "Invalid JSON data")
            result = try JSONDecoder().decode(LatestEventResponse.self, from: data)
         
        } catch {
            print(error)
        }
        
        enum ErrorType: String {
            case responseError
        }
        
        
        if let result = result?.result{
            print("Returning result.")
            onCompletion(result)
        }else {
            print()
            print("====not ================= =====Returning result.")
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
        
      
        if let result = result?.result{
            print("Returning result.")
            onCompletion(result)
        }else {
            print()
            print("====not ================= =====Returning result.")
        }
        
        }
    }



