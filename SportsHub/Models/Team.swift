//
//  Team.swift
//  SportsHub
//
//  Created by Anas Salah on 11/05/2024.
//

import Foundation

struct TeamResponse: Codable {
    let success: Int
    let result: [Team]
    
}

struct Team: Codable {
    let teamKey: Int
    let teamName: String
    let teamLogo: String?
    let players: [Player]?
    let coaches: [Coach]?
    var sport: String?
    
    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case players, coaches, sport
    }
    
}
        
struct Player: Codable {
    let playerKey: Int
    let playerName: String
    let playerImage: String?
    let playerAge: String?
    let playerGoals: String?
    let playerMatchPlayed: String?
    let playerNumber: String?
    let playerInjured: String?
    let playerType: String?
    
    enum CodingKeys: String, CodingKey {
        case playerKey = "player_key"
        case playerName = "player_name"
        case playerImage = "player_image"
        case playerAge = "player_age"
        case playerGoals = "player_goals"
        case playerMatchPlayed = "player_match_played"
        case playerNumber = "player_number"
        case playerInjured = "player_injured"
        case playerType = "player_type"
    }
}
        
struct Coach: Codable {
    let coachName: String
    
    enum CodingKeys: String, CodingKey {
        case coachName = "coach_name"
    }
}

