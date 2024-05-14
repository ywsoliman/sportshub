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
    
    init(service: APIServiceProtocol) {
        self.service = service
    }
    
    func fetchLeagues(league: String) {
        service.fetchLeagues { leagues in
            self.leagues = leagues
        } onFailure: { error in
            print(error)
        }
    }
    
}
