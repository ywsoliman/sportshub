//
//  League.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import Foundation

struct LeagueResponse: Codable {
    let result: [League]
}

struct League: Codable {
    let leagueKey: Int
    let leagueName: String
    let leagueLogo: String?

    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case leagueLogo = "league_logo"
    }
}
