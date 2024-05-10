//
//  DarkOverlay.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import Foundation
import UIKit

extension UIView {
    func addOverlay(color: UIColor = .black, alpha : CGFloat = 0.6) {
        let overlay = UIView()
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.frame = bounds
        overlay.backgroundColor = color
        overlay.alpha = alpha
        addSubview(overlay)
    }
}
