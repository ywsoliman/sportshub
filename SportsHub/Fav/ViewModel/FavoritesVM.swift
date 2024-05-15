//
//  FavoritesVM.swift
//  SportsHub
//
//  Created by Anas Salah on 11/05/2024.
//

import Foundation
import CoreData

class FavoritesViewModel {
    
    private let coreDataHelper = CoreDataHelper.shared

    func fetchTeams() -> [Team] {
        return coreDataHelper.fetchTeams()
    }
    
    func fetchAllLeagues() -> [LeagueEntitie] {
        return coreDataHelper.fetchAllLeagues()
    }
    
    func deleteTeam(withKey: Int) {
        coreDataHelper.deleteTeam(withKey: withKey)
    }

    func deleteLeague(leagueKey: UUID) {
        coreDataHelper.deleteLeague(leagueKey: leagueKey)
    }
}
