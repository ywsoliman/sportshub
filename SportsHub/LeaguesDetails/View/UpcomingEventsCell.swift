//
//  UpcomingEventsCell.swift
//  SportsHub
//
//  Created by Anas Salah on 12/05/2024.
//

import UIKit

class UpcomingEventsCell: UICollectionViewCell {
    
    @IBOutlet weak var leagueImage: UIImageView! // back ground image
    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamLogo: UIImageView!
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var dateLbl: UILabel! // 2021-05-18
    @IBOutlet weak var roundLbl: UILabel! // round 32
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var vsLbl: UILabel! // no need for this i think but in case..
    
}
