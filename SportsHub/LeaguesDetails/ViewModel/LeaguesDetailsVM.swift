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
    private let coreDataHelper = CoreDataHelper.shared

    // MARK: first work for get API for Up coming events
    func fetchUpComingEvents(leagueId: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        let parameters: [String: Any] = [
            "leagueId": leagueId,
            "from": "2024-05-18", // MARK: cahange date not static
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
            "from": "2024-05-1", // MARK: change it not to
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
    
    // MARK: CoreData ..
    func saveLeague(leagueKey: UUID, leagueLogo: Data?, leagueName: String) {
        coreDataHelper.saveLeague(leagueKey: leagueKey, leagueLogo: leagueLogo, leagueName: leagueName)
    }
    
    func deleteLeague(leagueKey: UUID) {
        coreDataHelper.deleteLeague(leagueKey: leagueKey)
    }
    
    func fetchAllLeagues() -> [LeagueEntitie] {
        return coreDataHelper.fetchAllLeagues()
    }
}
