//
//  TeamDetailsViewModel.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import Foundation

class TeamDetailsViewModel {
    
    var service: NetworkService!
    var bindTeamDetailsViewModelToController: (() -> ()) = {}
    var team: Team? {
        didSet {
            self.bindTeamDetailsViewModelToController()
        }
    }
    
    var selectedPlayer: Player?
    
    init(service: NetworkService) {
        self.service = service
    }
    
    func fetch(key: Int, sport: String) {
        
        service.fetch(dataType: TeamResponse.self, sport: sport, met: "Teams", parameters: ["teamId": key]) { response in
            self.team = response.result[0]
        } onFailure: { error in
            print("Error in fetching teams: \(error)")
        }

    }
    
    
}
