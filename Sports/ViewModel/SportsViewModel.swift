//
//  SportsViewModel.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import Foundation

struct SportsViewModel {
    
    private(set) var sports: [Sport]! {
        didSet {
            self.bindSportsViewModelToController()
        }
    }
    var bindSportsViewModelToController: (() -> ()) = {}
    
    init() {
        sports = mainSports
    }
    
}
