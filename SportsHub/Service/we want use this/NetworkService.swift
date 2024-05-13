//
//  File.swift
//  SportsHub
//
//  Created by Anas Salah on 13/05/2024.
//

import Foundation
import Alamofire

struct NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func fetch<T: Codable>(dataType: T.Type, league: String, met: String, parameters: [String: Any] = [:], onCompletion: @escaping (T) -> Void, onFailure: @escaping (String) -> Void) {
        var allParameters = parameters
        allParameters["APIkey"] = Constants.API_KEY
        allParameters["met"] = met

        let urlWithEndpoint = Constants.BASE_URL + league + "/"
        
        AF.request(urlWithEndpoint, parameters: allParameters).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                onCompletion(data)
            case .failure(let error):
                onFailure("Fetching error: \(error.errorDescription ?? "N/A")")
            }
        }
    }

}
