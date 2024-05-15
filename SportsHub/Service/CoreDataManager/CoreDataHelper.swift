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
    
    lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "SportsHub")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
    
    // MARK: - Core Data Saving support
    
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
        
        setTeamPlayers(team, newTeam)
        setTeamCoaches(team, newTeam)
        
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
    
    func setTeamPlayers(_ team: Team, _ newTeam: NSManagedObject) {
        if let players = team.players {
            for player in players {
                let playerEntity = NSEntityDescription.entity(forEntityName: "PlayerTable", in: context)!
                let newPlayer = NSManagedObject(entity: playerEntity, insertInto: context)
                newPlayer.setValuesForKeys([
                    PlayerAttributes.playerKey: player.playerKey,
                    PlayerAttributes.playerName: player.playerName,
                    PlayerAttributes.playerImage: player.playerImage,
                    PlayerAttributes.playerAge: player.playerAge,
                    PlayerAttributes.playerGoals: player.playerGoals,
                    PlayerAttributes.playerMatchPlayed: player.playerMatchPlayed,
                    PlayerAttributes.playerNumber: player.playerNumber,
                    PlayerAttributes.playerType: player.playerType,
                ])
                newTeam.mutableSetValue(forKey: "players").add(newPlayer)
            }
        }
    }
    
    func setTeamCoaches(_ team: Team, _ newTeam: NSManagedObject) {
        if let coaches = team.coaches {
            for coach in coaches {
                let coachEntity = NSEntityDescription.entity(forEntityName: "CoachTable", in: context)!
                let newCoach = NSManagedObject(entity: coachEntity, insertInto: context)
                newCoach.setValue(coach.coachName, forKey: "name")
                newTeam.mutableSetValue(forKey: "coaches").add(newCoach)
            }
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
                
                let playerSet = managedTeam.value(forKey: TeamAttributes.teamPlayers) as? NSSet
                let players = playerSet?.compactMap { playerManagedObject -> Player? in
                    guard let player = playerManagedObject as? NSManagedObject else { return nil }
                    let playerKey = player.value(forKey: PlayerAttributes.playerKey) as? Int ?? 0
                    let playerName = player.value(forKey: PlayerAttributes.playerName) as? String ?? ""
                    let playerNumber = player.value(forKey: PlayerAttributes.playerNumber) as? String ?? ""
                    let playerAge = player.value(forKey: PlayerAttributes.playerAge) as? String ?? ""
                    let playerType = player.value(forKey: PlayerAttributes.playerType) as? String ?? ""
                    let playerImage = player.value(forKey: PlayerAttributes.playerImage) as? String ?? ""
                    let playerGoals = player.value(forKey: PlayerAttributes.playerGoals) as? String ?? ""
                    let playerMatchPlayed = player.value(forKey: PlayerAttributes.playerMatchPlayed) as? String ?? ""
                    let playerInjured = player.value(forKey: PlayerAttributes.playerInjured) as? String ?? ""
                    return Player(playerKey: playerKey, playerName: playerName, playerImage: playerImage, playerAge: playerAge, playerGoals: playerGoals, playerMatchPlayed: playerMatchPlayed, playerNumber: playerNumber, playerInjured: playerInjured, playerType: playerType)
                }
                
                let coachSet = managedTeam.value(forKey: "coaches") as? NSSet
                let coaches = coachSet?.compactMap { coachManagedObject -> Coach? in
                    guard let coach = coachManagedObject as? NSManagedObject else { return nil }
                    let coachName = coach.value(forKey: "name") as? String ?? ""
                    return Coach(coachName: coachName)
                }
                
                let team = Team(teamKey: teamKey, teamName: teamName, teamLogo: teamLogo, players: players, coaches: coaches)
                
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
