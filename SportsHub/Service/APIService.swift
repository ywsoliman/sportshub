//
//  APIService.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import Foundation
import Alamofire

struct APIService: APIServiceProtocol {
    
    static let shared = APIService()
    
    private init() {}
    
    func fetchLeagues(sport: String, onCompletion: @escaping ([League]) -> Void, onFailure: @escaping (String) -> Void) {
        
        let parameters = ["met": "Leagues", "APIkey": Constants.API_KEY]
        let urlWithEndpoint = Constants.BASE_URL + sport + "/"
        
        print(urlWithEndpoint)
        
        AF.request(urlWithEndpoint, parameters: parameters).responseDecodable(of: LeagueResponse.self) { response in
            
            switch response.result {
                
            case .success(let leagues):
                onCompletion(leagues.result)
            case .failure(let error):
                onFailure("Fetching error: \(error.errorDescription ?? "N/A")")
                
            }
            
        }
        
    }
    // https://apiv2.allsportsapi.com/cricket/?&met=Teams&teamId=138&APIkey=!_your_account_APIkey_!
    func fetchTeam(sport: String, team: Int, onCompletion: @escaping (Team) -> Void, onFailure: @escaping (String) -> Void) {
        
        let parameters: [String: Any] = ["met": "Teams", "teamId": team, "APIkey": Constants.API_KEY]
        let urlWithEndpoint = Constants.BASE_URL + sport + "/"
        
        AF.request(urlWithEndpoint, parameters: parameters).responseDecodable(of: TeamResponse.self) { response in
            
            switch response.result {
            case .success(let teamResponse):
                onCompletion(teamResponse.result[0])
            case .failure(let error):
                onFailure(error.localizedDescription)
            }
            
        }
        
    }
    
}
