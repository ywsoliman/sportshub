//
//  FavoritesVM.swift
//  SportsHub
//
//  Created by Anas Salah on 11/05/2024.
//

import Foundation
import CoreData

class FavoritesViewModel {
    private var favorites: [League] = []
    private let managedContext: NSManagedObjectContext
    
    var dataUpdated: (() -> Void)?
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    func fetchDataFromCoreData() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LeagueEntitie")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            favorites = results.compactMap { leagueManagedObject in
                guard
                    let leagueKey = leagueManagedObject.value(forKey: "leagueKey") as? Int,
                    let leagueName = leagueManagedObject.value(forKey: "leagueName") as? String
                else {
                    return nil
                }
                let leagueLogo = leagueManagedObject.value(forKey: "leagueLogo") as? String
                return League(leagueKey: leagueKey, leagueName: leagueName, leagueLogo: leagueLogo)
            }
            dataUpdated?()
        } catch {
            print("Failed to fetch data from Core Data: \(error)")
        }
    }

    func numberOfFavorites() -> Int {
        return favorites.count
    }
    
    func favoriteAtIndex(_ index: Int) -> League? {
        guard index >= 0 && index < favorites.count else {
            return nil
        }
        return favorites[index]
    }
    
    func deleteFavorite(atIndex index: Int) {
        guard index >= 0 && index < favorites.count else {
            return
        }
        
        let leagueToDelete = favorites[index]
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LeagueEntitie")
        fetchRequest.predicate = NSPredicate(format: "leagueKey = %d", leagueToDelete.leagueKey)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if let leagueManagedObject = results.first {
                managedContext.delete(leagueManagedObject)
                favorites.remove(at: index)
                try managedContext.save()
                dataUpdated?()
            } else {
                print("League not found in Core Data.")
            }
        } catch {
            print("Failed to delete favorite: \(error)")
        }
    }
}
