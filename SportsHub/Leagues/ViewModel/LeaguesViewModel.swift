//
//  LeaguesViewModel.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import Foundation

class LeaguesViewModel {
    
    private var service: APIServiceProtocol!
    private(set) var leagues: [League] = [] {
        didSet {
            self.bindLeaguesViewModelToController()
        }
    }
    var bindLeaguesViewModelToController: (() -> ()) = {}
    var selectedLeague: String!
    var selectedSport: String!
    
    init(service: APIServiceProtocol) {
        self.service = service
    }
    
    func fetchLeagues(ofSport: String) {
        service.fetchLeagues(sport: ofSport) { leagues in
            self.leagues = leagues
        } onFailure: { error in
            print(error)
        }
    }
    
}
