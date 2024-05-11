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
    
    func fetch(league: String, onCompletion: @escaping ([League]) -> Void, onFailure: @escaping (String) -> Void) {
        
        let parameters = ["met": "Leagues", "APIkey": Constants.API_KEY]
        let urlWithEndpoint = Constants.BASE_URL + league + "/"
        
        
        AF.request(urlWithEndpoint, parameters: parameters).responseDecodable(of: LeagueResponse.self) { response in
            
            switch response.result {
                
            case .success(let leagues):
                onCompletion(leagues.result)
            case .failure(let error):
                onFailure("Fetching error: \(error.errorDescription ?? "N/A")")
                
            }
            
        }
        
    }
    
}
