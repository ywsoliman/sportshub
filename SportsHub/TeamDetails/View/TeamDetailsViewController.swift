//
//  TeamDetailsViewController.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import UIKit

class TeamDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private var teamDetailsViewModel: TeamDetailsViewModel!
    private let networkIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var coachLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        let networkIndicator = NetworkIndicator(view: view)

        teamDetailsViewModel = TeamDetailsViewModel(service: APIService.shared)
        teamDetailsViewModel.fetch(key: "80")
        networkIndicator.setIndicator()
        
        teamDetailsViewModel.bindTeamDetailsViewModelToController = { [weak self] in
            self?.updateTeamUI()
            networkIndicator.stopIndicator()
            self?.tableView.reloadData()
        }
        
    }
    
    func updateTeamUI() {
        let team = teamDetailsViewModel.team
        coachLabel.text = "Coach: \(team?.coaches?[0].coachName ?? "N/A")"
        loadTeamLogo(url: team?.teamLogo)
        title = team?.teamName
    }
    
    func loadTeamLogo(url: String?) {
        if let url {
            teamImageView.kf.setImage(with: URL(string: url))
        } else {
            teamImageView.image = UIImage(named: "no-image-placeholder")
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PlayerTableViewCell.nib(), forCellReuseIdentifier: PlayerTableViewCell.identifier)
    }
    
    @IBAction func favBarBtn(_ sender: UIBarButtonItem) {
        
        if sender.image == UIImage(systemName: "star") {
            sender.image = UIImage(systemName: "star.fill")
        } else {
            sender.image = UIImage(systemName: "star")
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

}

extension TeamDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return teamDetailsViewModel.team?.players?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.identifier, for: indexPath) as! PlayerTableViewCell
        
        guard let player = teamDetailsViewModel.team?.players?[indexPath.section] else { return UITableViewCell() }
        
        cell.configure(player: player)
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cell.selectionStyle = .none
        
        return cell
        
    }
    
}
