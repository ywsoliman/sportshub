//
//  TeamsCell.swift
//  SportsHub
//
//  Created by Anas Salah on 12/05/2024.
//

import UIKit
import Kingfisher

class TeamsCell: UICollectionViewCell {
    
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    
    func setUp(_ item: TeamSections) {
        teamName.text = item.teamName
        teamLogo.layer.cornerRadius = teamLogo.frame.height / 2
        if let imageUrl = URL(string: item.teamLogo) {
            teamLogo.kf.setImage(with: imageUrl)
        }
    }
}
