//
//  SportCollectionViewCell.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import UIKit

class SportCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "sportCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = 16
        self.contentView.layer.masksToBounds = true
    }
    
    func configure(with sport: Sport) {
        imageView.image = UIImage(named: sport.image)
        imageView.addOverlay()
        name.text = sport.name
    }
    
}
