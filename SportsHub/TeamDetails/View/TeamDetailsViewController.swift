//
//  TeamDetailsViewController.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import UIKit

class TeamDetailsViewController: UIViewController {
    
    private var networkIndicator: NetworkIndicator!
    private var teamDetailsViewModel: TeamDetailsViewModel!
    var leagueDetailsViewModel: LeaguesDetailsVM?
    var favoriteViewModel: FavoritesViewModel?
    
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var coachLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        updateSaveButton()
        
        networkIndicator = NetworkIndicator(view: view)
        teamDetailsViewModel = TeamDetailsViewModel(service: APIService.shared)
        networkIndicator.setIndicator()
        
        teamDetailsViewModel.bindTeamDetailsViewModelToController = { [weak self] in
            self?.networkIndicator.stopIndicator()
            self?.updateTeamUI()
            self?.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let leagueModel = leagueDetailsViewModel {
            favBtn.isHidden = false
            teamDetailsViewModel.fetch(key: leagueModel.selectedTeamKey)
        } else if let favoriteModel = favoriteViewModel {
            favBtn.isHidden = true
            teamDetailsViewModel.fetch(key: favoriteModel.selectedTeam.teamKey)
        }
    }
    
    func updateSaveButton() {
        if let leagueModel = leagueDetailsViewModel {
            let key = leagueModel.selectedTeamKey
            if CoreDataHelper.shared.doesTeamExist(withKey: key ?? 0) {
                favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
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
    
    
    @IBAction func favBtn(_ sender: UIButton) {
        if sender.imageView?.image == UIImage(systemName: "heart") {
            insertTeamToFavorites(sender)
        } else {
            deleteTeamFromFavorites(sender)
        }
    }
    
    func insertTeamToFavorites(_ sender: UIButton) {
        DispatchQueue.global().async {
            CoreDataHelper.shared.insert(team: self.teamDetailsViewModel.team!)
            DispatchQueue.main.async {
                sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
    }
    
    func deleteTeamFromFavorites(_ sender: UIButton) {
        DispatchQueue.global().async {
            CoreDataHelper.shared.deleteTeam(withKey: self.teamDetailsViewModel.team!.teamKey)
            DispatchQueue.main.async {
                sender.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            performSegue(withIdentifier: "showPlayerSegue", sender: cell)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destVC = segue.destination as? PlayerDetailsViewController else { return }
        
        if let cell = sender as? PlayerTableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            
            teamDetailsViewModel.selectedPlayer = teamDetailsViewModel.team?.players?[indexPath.section]
            destVC.teamDetailsViewModel = teamDetailsViewModel
            
        }
        
    }
    
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
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        return cell
        
    }
    
}
