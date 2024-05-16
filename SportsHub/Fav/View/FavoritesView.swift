//
//  FavoritesVM.swift
//  SportsHub
//
//  Created by Anas Salah on 11/05/2024.
//

import UIKit
import CoreData
import Reachability

class FavoritesView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let favoritesViewModel = FavoritesViewModel()
    var leagues: [LeagueEntitie] = []
    var reachability: Reachability!
    var isConnectedToInternet: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LeagueTableViewCell.nib(), forCellReuseIdentifier: LeagueTableViewCell.identifier)
        
        reachability = try? Reachability()
        
        if reachability.connection != .unavailable {
            isConnectedToInternet = true
        } else {
            isConnectedToInternet = false
            noInternetAlert()
        }
        
        reachability.whenReachable = { [weak self] _ in
            DispatchQueue.main.async {
                self?.isConnectedToInternet = true
            }
        }
        
        reachability.whenUnreachable = { [weak self] _ in
            DispatchQueue.main.async {
                self?.isConnectedToInternet = false
                self?.noInternetAlert()
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        leagues = favoritesViewModel.fetchAllLeagues()
        tableView.reloadData()
        print("View will appear")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return leagues.count
        default:
            return favoritesViewModel.favoriteTeams.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LeagueTableViewCell.identifier, for: indexPath) as! LeagueTableViewCell
        
        if indexPath.section == 0 {
            setLeagueCell(indexPath, cell)
        } else {
            setTeamCell(indexPath, cell)
        }
        
        return cell
    }
    
    func setLeagueCell(_ indexPath: IndexPath, _ cell: LeagueTableViewCell) {
        let league = leagues[indexPath.row]
        cell.name.text = league.leagueName
        if let leagueImage = league.leagueLogo {
            cell.leagueImage.image = UIImage(data: leagueImage)
        } else {
            cell.leagueImage.image = UIImage(named: "SportsLogo")
        }
    }
    
    func setTeamCell(_ indexPath: IndexPath, _ cell: LeagueTableViewCell) {
        let team = favoritesViewModel.favoriteTeams[indexPath.row]
        cell.name.text = team.teamName
        if let logo = team.teamLogo {
            cell.leagueImage.kf.setImage(with: URL(string: logo))
        } else {
            cell.leagueImage.image = UIImage(named: "no-image-placeholder")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return leagues.count > 0 ? "Favorite Leagues" : nil
        default:
            return favoritesViewModel.favoriteTeams.count > 0 ? "Favorite Teams" : nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isConnectedToInternet {
            
            if indexPath.section == 1 {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyboard.instantiateViewController(withIdentifier: "TeamDetailsViewController") as! TeamDetailsViewController
                
                let selectedTeam = favoritesViewModel.favoriteTeams[indexPath.row]
                favoritesViewModel.selectedTeam = selectedTeam
                destVC.favoriteViewModel = favoritesViewModel
                present(destVC, animated: true)
                
            }
            
        } else {
            noInternetAlert()
        }
        
    }
    
    func noInternetAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Please connect to the internet to view details", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            dellCellAlert(indexPath, tableView)
        }
    }
    
    func dellCellAlert(_ indexPath: IndexPath, _ tableView: UITableView) {
        let alert = UIAlertController(title: "Delete Confirmation", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            
            DispatchQueue.global().async {
                if indexPath.section == 0 {
                    self.deleteSelectedLeague(index: indexPath.row)
                } else {
                    self.deleteSelectedTeam(index: indexPath.row)
                }
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteSelectedLeague(index: Int) {
        let leagueKey = leagues[index].leagueKey!
        self.favoritesViewModel.deleteLeague(leagueKey: leagueKey)
        self.leagues.remove(at: index)
    }
    
    func deleteSelectedTeam(index: Int) {
        let teamKey = self.favoritesViewModel.favoriteTeams[index].teamKey
        self.favoritesViewModel.deleteTeam(withKey: teamKey)
    }
    
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
