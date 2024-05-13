//
//  IndicatorManager.swift
//  SportsHub
//
//  Created by Anas Salah on 13/05/2024.
//

import UIKit

class IndicatorManager {
    
    static let shared = IndicatorManager()
    
    private var networkIndicator: UIActivityIndicatorView
    
    private init() {
        networkIndicator = UIActivityIndicatorView(style: .large)
        networkIndicator.hidesWhenStopped = true
    }
    
    func setIndicator(on view: UIView) {
        DispatchQueue.main.async {
            self.networkIndicator.center = view.center
            view.addSubview(self.networkIndicator)
            self.networkIndicator.startAnimating()
        }
    }
    
    func stopIndicator() {
        DispatchQueue.main.async {
            self.networkIndicator.stopAnimating()
            self.networkIndicator.removeFromSuperview()
        }
    }
}
