//
//  LatestEvents.swift
//  SportsHub
//
//  Created by Anas Salah on 12/05/2024.
//

// https://apiv2.allsportsapi.com/football/?met=Livescore&APIkey=463e81a5fab411a1723707c80e9aaec0c16bdfbf90536258ea9448bf4a838721

//https://apiv2.allsportsapi.com/football/?met=Fixtures&APIkey=463e81a5fab411a1723707c80e9aaec0c16bdfbf90536258ea9448bf4a838721&from=2024-05-1&to=2024-05-13&leagueId=207

struct LatestEventResponse: Codable {
    let success: Int
    let result: [LatestEvent]
}
struct LatestEvent: Codable {
    let homeTeamLogo: String
    let awayTeamLogo: String
    let awayTeamName: String
    let finalResultLbl: String
    let homeTeamName: String
    
    private enum CodingKeys: String, CodingKey {
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case awayTeamName = "event_away_team"
        case finalResultLbl = "event_final_result"
        case homeTeamName = "event_home_team"
    }
}
