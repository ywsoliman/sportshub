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
    
    // MARK: - CRUD operations
    
    func insert(team: Team) {
        
        let entity = NSEntityDescription.entity(forEntityName: "TeamTable", in: context)
        
        let newTeam = NSManagedObject(entity: entity!, insertInto: context)
        
        newTeam.setValuesForKeys([
            TeamAttributes.teamKey: team.teamKey,
            TeamAttributes.teamName: team.teamName,
            TeamAttributes.teamLogo: team.teamLogo ?? ""
        ])
        
        saveContext()
        
    }
    
    func deleteTeam(withKey: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TeamTable")
        fetchRequest.predicate = NSPredicate(format: "key == %ld", withKey)
        do {
            let teams = try context.fetch(fetchRequest)
            for team in teams {
                context.delete(team)
            }
            saveContext()
        } catch {
            print("Error deleting league: \(error.localizedDescription)")
        }
    }
    
    func doesTeamExist(withKey: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TeamTable")
        fetchRequest.predicate = NSPredicate(format: "key == %ld", withKey)
        do {
            let teams = try context.fetch(fetchRequest)
            return teams.count > 0
        } catch {
            print("Error deleting league: \(error.localizedDescription)")
        }
        return false
    }

    func saveLeague(leagueKey: UUID, leagueLogo: Data?, leagueName: String) {
        let newLeague = LeagueEntitie(context: context)
        newLeague.leagueKey = leagueKey
        newLeague.leagueLogo = leagueLogo
        newLeague.leagueName = leagueName
        saveContext()
    }
    
    func fetchTeams() -> [Team] {
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "TeamTable")
        
        var teams = [Team]()
        
        do {
            let fetchedTeams = try context.fetch(fetchRequest)
            for managedTeam in fetchedTeams {
                let teamKey = managedTeam.value(forKey: TeamAttributes.teamKey) as! Int
                let teamName = managedTeam.value(forKey: TeamAttributes.teamName) as! String
                let teamLogo = managedTeam.value(forKey: TeamAttributes.teamLogo) as? String
                
                let team = Team(teamKey: teamKey, teamName: teamName, teamLogo: teamLogo, players: [], coaches: [])
                
                teams.append(team)
            }
            
        } catch {
            print("Error fetching teams: \(error)")
        }
        
        return teams
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
