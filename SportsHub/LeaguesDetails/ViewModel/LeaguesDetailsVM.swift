//
//  LeaguesDetailsVM.swift
//  SportsHub
//
//  Created by Anas Salah on 13/05/2024.
//

import Foundation
import Alamofire

class LeaguesDetailsVM {
    var upComingEvent: [UpComingEvents] = []
    var latestEvent: [LatestEvent] = []
    var teams: [TeamSections] = []
    
    let networkService = NetworkService.shared

    // MARK: first work for get API for Up coming events
    func fetchUpComingEvents(leagueId: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        let parameters: [String: Any] = [
            "leagueId": leagueId,
            "from": "2024-05-18",
            "to": "2024-05-25"
        ]
        networkService.fetch(dataType: UpComingEventResult.self, league: "football", met: "Fixtures", parameters: parameters, onCompletion: { upComingEventResponse in
            let upComingEvent = upComingEventResponse.result
            self.upComingEvent = upComingEvent
            onSuccess()
        }, onFailure: { error in
            onFailure(error)
        })
    }

    // MARK: second work for get API for Latest results
    func fetchLatestEvent(leagueId: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        let parameters: [String: Any] = [
            "leagueId": leagueId,
            "from": "2024-05-1",
            "to": "2024-05-12"
        ]
        networkService.fetch(dataType: LatestEventResponse.self, league: "football", met: "Fixtures", parameters: parameters, onCompletion: { latestEventResponse in
            let latestEvent = latestEventResponse.result
            self.latestEvent = latestEvent
            onSuccess()
        }, onFailure: { error in
            onFailure(error)
        })
    }

    // MARK: third work for get API for Teams
    func fetchTeams(leagueId: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        let parameters: [String: Any] = ["leagueId": leagueId]
        networkService.fetch(dataType: TeamsResponse.self, league: "football", met: "Teams", parameters: parameters, onCompletion: { teamsResponse in
            let teams = teamsResponse.result
            self.teams = teams //
            onSuccess()
        }, onFailure: { error in
            onFailure(error)
        })
    }
}

/*
 func fetchTeamss(leagueId: Int, onSuccess: @escaping ([TeamSections]) -> Void, onFailure: @escaping (String) -> Void) {
     let endpoint = "https://apiv2.allsportsapi.com/football/"
     let parameters: [String: Any] = ["met": "Teams", "leagueId": leagueId, "APIkey": Constants.API_KEY]
     
     AF.request(endpoint, parameters: parameters).responseDecodable(of: TeamsResponse.self) { response in
         switch response.result {
         case .success(let teamsResponse):
             onSuccess(teamsResponse.result)
         case .failure(let error):
             onFailure("Fetching error: \(error.localizedDescription)")
         }
     }
 }
 */
