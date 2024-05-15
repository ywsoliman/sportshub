//
//  LeaguesTableViewController.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import UIKit

class LeaguesTableViewController: UITableViewController {

    private var leaguesViewModel: LeaguesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let networkIndicator = NetworkIndicator(view: view)
        
        tableView.register(LeagueTableViewCell.nib(), forCellReuseIdentifier: LeagueTableViewCell.identifier)
        
        leaguesViewModel = LeaguesViewModel(service: APIService.shared)
        leaguesViewModel.bindLeaguesViewModelToController = { [weak self] in
            networkIndicator.stopIndicator()
            self?.tableView.reloadData()
        }
        if let selectedSport = SelectedSport.sport {
            networkIndicator.setIndicator()
            leaguesViewModel.fetchLeagues(league: selectedSport)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return leaguesViewModel.leagues.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeagueTableViewCell.identifier, for: indexPath) as! LeagueTableViewCell

        let league = leaguesViewModel.leagues[indexPath.section]
        cell.configure(with: league)
        cell.layer.cornerRadius = 8
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destVC = storyboard.instantiateViewController(withIdentifier: "leagueDetailsVC") as? LeaguesDetailsVC {
            destVC.modalPresentationStyle = .fullScreen
            leaguesViewModel.selectedLeague = String(leaguesViewModel.leagues[indexPath.section].leagueKey)
            destVC.leaguesViewModel = leaguesViewModel
            present(destVC, animated: true)
        }
        
    }

}
