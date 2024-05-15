//
//  Event.swift
//  SportsHub
//
//  Created by Anas Salah on 12/05/2024.
//

// MARK: https://apiv2.allsportsapi.com/football/?met=Fixtures&APIkey=463e81a5fab411a1723707c80e9aaec0c16bdfbf90536258ea9448bf4a838721&from=2021-05-18&to=2021-05-18
import Foundation

struct UpComingEventResult: Codable {
    let success: Int
    let result: [UpComingEvents]
}

// MARK: - Result
struct UpComingEvents: Codable {
    let eventKey: Int
    let eventDate, eventTime, eventHomeTeam: String
    let eventAwayTeam: String
    let eventFinalResult: String
    let leagueName: String
    let leagueRound: String
    let homeTeamLogo, awayTeamLogo: String
    let leagueLogo: String

    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case eventAwayTeam = "event_away_team"
        case eventFinalResult = "event_final_result"
        case leagueName = "league_name"
        case leagueRound = "league_round"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case leagueLogo = "league_logo"
    }
}
