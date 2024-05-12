//
//  NetworkIndicator.swift
//  SportsHub
//
//  Created by Youssef Waleed on 12/05/2024.
//

import Foundation
import UIKit

struct NetworkIndicator {
    
    private let view: UIView
    private let networkIndicator = UIActivityIndicatorView()
    
    init(view: UIView) {
        self.view = view
    }
    
    func setIndicator() {
        networkIndicator.style = .large
        networkIndicator.center = view.center
        networkIndicator.startAnimating()
        view.addSubview(networkIndicator)
    }
    
    func stopIndicator() {
        networkIndicator.stopAnimating()
    }
    
}
