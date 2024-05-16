//
//  PlayerTableViewCell.swift
//  SportsHub
//
//  Created by Youssef Waleed on 13/05/2024.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    
    static let identifier = "playerCell"
    
    static func nib() -> UINib {
        UINib(nibName: "PlayerTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(player: Player) {
        numberLabel.text = player.playerNumber
        nameLabel.text = player.playerName
        playerImageView.kf.setImage(
            with: URL(string: player.playerImage ?? ""),
            placeholder: UIImage(named: "no-player-placeholder")
        )
        playerImageView.layer.cornerRadius = playerImageView.frame.size.width / 2
    }
    
}
