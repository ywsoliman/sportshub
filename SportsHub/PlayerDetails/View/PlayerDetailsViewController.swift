//
//  PlayerDetailsViewController.swift
//  SportsHub
//
//  Created by Youssef Waleed on 12/05/2024.
//

import UIKit

class PlayerDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let sections = ["Number", "Name", "Age", "Type", "Matches Played", "Goals"]
    private var properities: [String] = []
    private var headerView: PlayerHeaderUIView!
    
    var teamDetailsViewModel: TeamDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        guard let player = teamDetailsViewModel.selectedPlayer else { return }
        
        headerView = PlayerHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
        tableView.tableHeaderView = headerView

        properities = [player.playerNumber, player.playerName, player.playerAge, player.playerType, player.playerMatchPlayed, player.playerGoals]}

}

extension PlayerDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerDetailsCell", for: indexPath)
        
        guard let player = teamDetailsViewModel.selectedPlayer else { return UITableViewCell() }
                
        cell.textLabel?.text = properities[indexPath.section]
        headerView.playerImage.kf.setImage(
            with: URL(string: player.playerImage),
            placeholder: UIImage(named: "no-player-placeholder")
        )
        
        return cell
        
    }
    
}
