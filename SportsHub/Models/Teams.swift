//
//  Teams.swift
//  SportsHub
//
//  Created by Anas Salah on 12/05/2024.
//

// https://apiv2.allsportsapi.com/football/?&met=Teams&leagueId=207&APIkey=d2538bc4458303020afacfc7511cb9f5808e36e454a61508dcb8a7ade6984775

import Foundation

struct TeamsResponse: Codable {
    let success: Int
    let result: [TeamSections]
}

struct TeamSections: Codable {
    let teamKey: Int
    let teamName: String
    let teamLogo: String
        
    private enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
    }
}



//https://apiv2.allsportsapi.com/football/?&met=Teams&leagueId=207&APIkey=
