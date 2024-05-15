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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return leagues.count
        default:
            return favoritesViewModel.fetchTeams().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        
        let team = favoritesViewModel.fetchTeams()[indexPath.row]
        
        cell.leagueName.text = team.teamName
        if let logo = team.teamLogo {
            cell.leagueImage.kf.setImage(with: URL(string: logo))
        } else {
            cell.leagueImage.image = UIImage(named: "no-image-placeholder")
        }
        
//        let league = leagues[indexPath.row]
//        cell.leagueName.text = league.leagueName
//        // Set league image if available
//        if let leagueImage = league.leagueLogo {
//            cell.leagueImage.image = UIImage(data: leagueImage)
//        } else {
//            cell.leagueImage.image = UIImage(named: "SportsLogo")
//        }
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowColor = UIColor.black.cgColor
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Delete League", message: "Are you sure you want to delete this league?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                
                if indexPath.section == 0 {
                    self.favoritesViewModel.deleteLeague(leagueKey: self.leagues[indexPath.row].leagueKey!)
                    self.leagues.remove(at: indexPath.row)
                } else {
                    self.favoritesViewModel.deleteTeam(withKey: self.favoritesViewModel.fetchTeams()[indexPath.row].teamKey)
                    print(self.favoritesViewModel.fetchTeams())
                }
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
}

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var leagueImage: UIImageView!
}


/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/
