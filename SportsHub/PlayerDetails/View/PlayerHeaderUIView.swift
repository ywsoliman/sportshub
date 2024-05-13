//
//  PlayerHeaderUIView.swift
//  SportsHub
//
//  Created by Youssef Waleed on 12/05/2024.
//

import UIKit

class PlayerHeaderUIView: UIView {
    
    
    let playerImage: UIImageView = {
       
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "no-player-placeholder")
        return imageView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playerImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerImage.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
