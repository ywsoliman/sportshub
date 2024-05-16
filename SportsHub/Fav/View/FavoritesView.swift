//
//  FavoritesVM.swift
//  SportsHub
//
//  Created by Anas Salah on 11/05/2024.
//

import UIKit
import CoreData


class FavoritesView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!

    let favoritesViewModel = FavoritesViewModel()
    var leagues: [LeagueEntitie] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        leagues = favoritesViewModel.fetchAllLeagues()
        tableView.reloadData()
        print("View will appear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LeagueTableViewCell.nib(), forCellReuseIdentifier: LeagueTableViewCell.identifier)
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
            let league = leagues[indexPath.row]
            cell.name.text = league.leagueName
            if let leagueImage = league.leagueLogo {
                cell.leagueImage.image = UIImage(data: leagueImage)
            } else {
                cell.leagueImage.image = UIImage(named: "SportsLogo")
            }
        } else {
            let team = favoritesViewModel.favoriteTeams[indexPath.row]
            cell.name.text = team.teamName
            if let logo = team.teamLogo {
                cell.leagueImage.kf.setImage(with: URL(string: logo))
            } else {
                cell.leagueImage.image = UIImage(named: "no-image-placeholder")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Favorite Leagues"
        default:
            return "Favorite Teams"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destVC = storyboard.instantiateViewController(withIdentifier: "TeamDetailsViewController") as! TeamDetailsViewController
            
            let selectedTeam = favoritesViewModel.favoriteTeams[indexPath.row]
            favoritesViewModel.selectedTeam = selectedTeam
            destVC.favoriteViewModel = favoritesViewModel
            present(destVC, animated: true)
            
        }
        
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
                    let leagueKey = self.leagues[indexPath.row].leagueKey!
                    self.favoritesViewModel.deleteLeague(leagueKey: leagueKey)
                    self.leagues.remove(at: indexPath.row)
                } else {
                    let teamKey = self.favoritesViewModel.favoriteTeams[indexPath.row].teamKey
                    self.favoritesViewModel.deleteTeam(withKey: teamKey)
                }
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
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
