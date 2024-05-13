//
//  LeaguesTableViewController.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import UIKit

class LeaguesTableViewController: UITableViewController {

    private var leaguesViewModel: LeaguesViewModel!
    var sportName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let networkIndicator = NetworkIndicator(view: view)
        
        tableView.register(LeagueTableViewCell.nib(), forCellReuseIdentifier: LeagueTableViewCell.identifier)
        
        leaguesViewModel = LeaguesViewModel(service: APIService.shared)
        leaguesViewModel.bindLeaguesViewModelToController = { [weak self] in
            networkIndicator.stopIndicator()
            self?.tableView.reloadData()
        }
        if let sportName {
            networkIndicator.setIndicator()
            leaguesViewModel.fetchLeagues(league: sportName)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
