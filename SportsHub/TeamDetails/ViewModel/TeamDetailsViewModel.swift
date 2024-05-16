//
//  TeamDetailsViewModel.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import Foundation

class TeamDetailsViewModel {
    
    var service: APIServiceProtocol!
    var bindTeamDetailsViewModelToController: (() -> ()) = {}
    var team: Team? {
        didSet {
            self.bindTeamDetailsViewModelToController()
        }
    }

    var selectedPlayer: Player?
    
    init(service: APIServiceProtocol) {
        self.service = service
    }
    
    func fetch(key: Int, sport: String) {
        
        service.fetchTeam(sport: sport, team: key) { team in
            self.team = team
        } onFailure: { error in
            print("Error in fetching teams: \(error)")
        }

        
    }
    
    
}
