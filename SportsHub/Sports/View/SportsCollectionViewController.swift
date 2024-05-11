//
//  SportsCollectionViewController.swift
//  SportsHub
//
//  Created by Youssef Waleed on 11/05/2024.
//

import UIKit

class SportsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var sportsViewModel: SportsViewModel!
    
    private let sectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let itemsSpacing: CGFloat = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sportsViewModel = SportsViewModel()
        sportsViewModel.bindSportsViewModelToController = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sportsViewModel.sports.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SportCollectionViewCell.identifier, for: indexPath) as! SportCollectionViewCell
        
        let sport = sportsViewModel.sports[indexPath.row]
        cell.configure(with: sport)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let totalSpacing = sectionInsets.left + sectionInsets.right + itemsSpacing
        let itemWidth = (collectionViewWidth - totalSpacing) / 2
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemsSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemsSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInsets
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let leagueVC = segue.destination as? LeaguesTableViewController else { return }
        
        if let cell = sender as? SportCollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
            
            let league = sportsViewModel.sports[indexPath.row].name.lowercased()            
            leagueVC.sportName = league
            
        }
        
    }
    
}
