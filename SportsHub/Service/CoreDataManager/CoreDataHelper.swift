//
//  CoreDataHelper.swift
//  SportsHub
//
//  Created by Anas Salah on 14/05/2024.
//

import Foundation
import CoreData

class CoreDataHelper {
    static let shared = CoreDataHelper()

    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SportsHub")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD operations
    
    func saveLeague(leagueKey: UUID, leagueLogo: Data?, leagueName: String) {
        let context = persistentContainer.viewContext
        let newLeague = LeagueEntitie(context: context)
        newLeague.leagueKey = leagueKey
        newLeague.leagueLogo = leagueLogo
        newLeague.leagueName = leagueName
        saveContext()
    }
    
    func fetchAllLeagues() -> [LeagueEntitie] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LeagueEntitie> = LeagueEntitie.fetchRequest()
        do {
            let leagues = try context.fetch(fetchRequest)
            return leagues
        } catch {
            print("Error fetching leagues: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteLeague(leagueKey: UUID) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LeagueEntitie> = LeagueEntitie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "leagueKey == %@", leagueKey as CVarArg)
        do {
            let leagues = try context.fetch(fetchRequest)
            for league in leagues {
                context.delete(league)
            }
            saveContext()
        } catch {
            print("Error deleting league: \(error.localizedDescription)")
        }
    }
}
