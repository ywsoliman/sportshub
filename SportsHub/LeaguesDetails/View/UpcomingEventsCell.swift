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
    
    func setUp(_ item: UpComingEvents) {
        leagueName.text = item.leagueName
        dateLbl.text = item.eventDate
        roundLbl.text = item.leagueRound
        homeTeamName.text = item.eventHomeTeam
        awayTeamName.text = item.eventAwayTeam
        
        homeTeamLogo.layer.cornerRadius = homeTeamLogo.frame.height / 2
        awayTeamLogo.layer.cornerRadius = awayTeamLogo.frame.height / 2

        if let imageUrl = URL(string: item.leagueLogo ?? "") {
            leagueImage.kf.setImage(with: imageUrl)
        }
        
        if let imageUrl = URL(string: item.awayTeamLogo ?? "") {
            awayTeamLogo.kf.setImage(with: imageUrl)
        }
        
        if let imageUrl = URL(string: item.homeTeamLogo ?? "") {
            homeTeamLogo.kf.setImage(with: imageUrl)
        }
    }
    
    func setUpMocData() {
        leagueName.text = "Sorry cant find it for now"
        dateLbl.text = ""
        roundLbl.text = ""
        homeTeamName.text = ""
        awayTeamName.text = ""
        vsLbl.text = ""
        let leagueLogoImage = UIImage(named: "SportsLogo")
        leagueImage.image = leagueLogoImage

        let awayTeamLogoImage = UIImage(named: "")
        awayTeamLogo.image = awayTeamLogoImage

        let homeTeamLogoImage = UIImage(named: "")
        homeTeamLogo.image = homeTeamLogoImage
    }
}
