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

    func fetchAllLeagues() -> [LeagueEntitie] {
        return coreDataHelper.fetchAllLeagues()
    }

    func deleteLeague(leagueKey: UUID) {
        coreDataHelper.deleteLeague(leagueKey: leagueKey)
    }
}
