//
//  FavoritesVM.swift
//  SportsHub
//
//  Created by Anas Salah on 11/05/2024.
//

import Foundation
import CoreData

class FavoritesViewModel {
    private var favorites: [Leagues] = []
    private let managedContext: NSManagedObjectContext
    
    var dataUpdated: (() -> Void)?
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    func fetchDataFromCoreData() {
        let fetchRequest = NSFetchRequest<Leagues>(entityName: "Leagues")
        
        do {
            favorites = try managedContext.fetch(fetchRequest)
            dataUpdated?()
        } catch {
            print("Failed to fetch data from Core Data: \(error)")
        }
    }
    
    func numberOfFavorites() -> Int {
        return favorites.count
    }
    
    func favoriteAtIndex(_ index: Int) -> Leagues? {
        guard index >= 0 && index < favorites.count else {
            return nil
        }
        return favorites[index]
    }
    
    func deleteFavorite(atIndex index: Int) {
        guard index >= 0 && index < favorites.count else {
            return
        }
        
        managedContext.delete(favorites[index])
        favorites.remove(at: index)
        
        do {
            try managedContext.save()
            dataUpdated?()
        } catch {
            print("Failed to delete favorite: \(error)")
        }
    }
}
