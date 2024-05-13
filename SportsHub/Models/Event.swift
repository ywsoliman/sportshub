//
//  Event.swift
//  SportsHub
//
//  Created by Anas Salah on 12/05/2024.
//

// MARK: https://apiv2.allsportsapi.com/football/?met=Fixtures&APIkey=463e81a5fab411a1723707c80e9aaec0c16bdfbf90536258ea9448bf4a838721&from=2021-05-18&to=2021-05-18
import Foundation

struct Event: Codable {
    let success: Int
    let result: [Result]
}

// MARK: - Result
struct Result: Codable {
    let eventKey: Int
    let eventDate, eventTime, eventHomeTeam: String
    let eventAwayTeam: String
    let eventHalftimeResult, eventFinalResult, eventFtResult, eventPenaltyResult: String
    let eventStatus, countryName, leagueName: String
    let leagueRound, leagueSeason, eventStadium: String
    let eventReferee: String
    let homeTeamLogo, awayTeamLogo: String
    let eventCountryKey: Int
    let leagueLogo, countryLogo: String
    let eventHomeFormation, eventAwayFormation: String
    let fkStageKey: Int
    let stageName: String

    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case eventAwayTeam = "event_away_team"
        case eventHalftimeResult = "event_halftime_result"
        case eventFinalResult = "event_final_result"
        case eventFtResult = "event_ft_result"
        case eventPenaltyResult = "event_penalty_result"
        case eventStatus = "event_status"
        case countryName = "country_name"
        case leagueName = "league_name"
        case leagueRound = "league_round"
        case leagueSeason = "league_season"
        case eventStadium = "event_stadium"
        case eventReferee = "event_referee"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case eventCountryKey = "event_country_key"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
        case eventHomeFormation = "event_home_formation"
        case eventAwayFormation = "event_away_formation"
        case fkStageKey = "fk_stage_key"
        case stageName = "stage_name"
    }
}
