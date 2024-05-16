//
//  LeaguesViewModel.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import Foundation

class LeaguesViewModel {
    
    private var service: NetworkService!
    private(set) var leagues: [League] = [] {
        didSet {
            self.bindLeaguesViewModelToController()
        }
    }
    var bindLeaguesViewModelToController: (() -> ()) = {}
    var selectedLeague: String!
    var selectedSport: String!
    
    init(service: NetworkService) {
        self.service = service
    }
    
    func fetchLeagues(ofSport: String) {
                
        service.fetch(dataType: LeagueResponse.self, sport: ofSport, met: "Leagues") { response in
            self.leagues = response.result
        } onFailure: { error in
            print(error)
        }

    }
    
}
