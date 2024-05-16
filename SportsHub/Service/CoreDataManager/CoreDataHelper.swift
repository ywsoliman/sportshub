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
        
    lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "SportsHub")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
        
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
        
    func saveLeague(leagueKey: UUID, leagueLogo: Data?, leagueName: String) {
        let newLeague = LeagueEntitie(context: context)
        newLeague.leagueKey = leagueKey
        newLeague.leagueLogo = leagueLogo
        newLeague.leagueName = leagueName
        saveContext()
    }
    
    func fetchAllLeagues() -> [LeagueEntitie] {
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
