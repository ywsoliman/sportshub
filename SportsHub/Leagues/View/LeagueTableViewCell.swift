//
//  LeagueTableViewCell.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import UIKit
import Kingfisher

class LeagueTableViewCell: UITableViewCell {

    @IBOutlet weak var leagueImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    static let identifier = "leagueCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "LeagueTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with league: League) {
        name.text = league.leagueName
        if let logo = league.leagueLogo {
            let url = URL(string: logo)
            leagueImage.kf.setImage(with: url)
        } else {
            leagueImage.image = UIImage(named: "no-image-placeholder")
        }
        leagueImage.layer.cornerRadius = leagueImage.frame.size.width / 2
        
    }

}
