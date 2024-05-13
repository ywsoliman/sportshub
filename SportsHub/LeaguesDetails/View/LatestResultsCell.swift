//
//  LatestResultsCell.swift
//  SportsHub
//
//  Created by Anas Salah on 12/05/2024.
//

import UIKit
import Kingfisher

class LatestResultsCell: UICollectionViewCell {
    
    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var finalResultLbl: UILabel!
    @IBOutlet weak var homeTeamName: UILabel!
    
    func setUp(_ item: LatestEvent) {
        awayTeamName.text = item.awayTeamName
        finalResultLbl.text = item.finalResultLbl
        homeTeamName.text = item.homeTeamName
        
        homeTeamLogo.layer.cornerRadius = homeTeamLogo.frame.height / 2
        awayTeamLogo.layer.cornerRadius = awayTeamLogo.frame.height / 2

        if let imageUrl = URL(string: item.homeTeamLogo) {
            homeTeamLogo.kf.setImage(with: imageUrl)
        }
        
        if let imageUrl = URL(string: item.awayTeamLogo) {
            awayTeamLogo.kf.setImage(with: imageUrl)
        }
    }
}
