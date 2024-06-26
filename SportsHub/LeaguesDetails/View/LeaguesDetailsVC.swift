//
//  LeaguesDetailsVC.swift
//  SportsHub
//
//  Created by Anas Salah on 12/05/2024.
//

import UIKit
import Kingfisher

class LeaguesDetailsVC: UIViewController {
    
    @IBOutlet weak var favBtnOL: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var isFavorited = false // this flag for change btnFav image
    private var isComingFromFavorite: Bool!
    private let leaguesDetailsVM = LeaguesDetailsVM()
    var leaguesViewModel: LeaguesViewModel!
    var favoriteViewModel: FavoritesViewModel!
    
    var leagueId: String!
    var sport: String!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isCurrentLeagueSaved()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IndicatorManager.shared.setIndicator(on: self.view)
        
        if favoriteViewModel != nil {
            leagueId = String(favoriteViewModel.selectedLeague.leagueKey?.toInt() ?? 0)
            sport = favoriteViewModel.selectedLeague.sport ?? "football"
            favBtnOL.isHidden = true
        } else if leaguesViewModel != nil {
            leagueId = leaguesViewModel.selectedLeague
            sport = leaguesViewModel.selectedSport
            favBtnOL.isHidden = false
        }
        
        fetchUpComingEvents()
        fetchLatestEvent()
        fetchTeams()
        
        let layOut = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.layoutForSection(at: sectionIndex)
        }
        
        collectionView.collectionViewLayout = layOut
    }
    
    func drawUpComingEvents() -> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(219))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        
        // MARK: HEADER
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(32))
        
        let headerSupplemntrry = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        headerSupplemntrry.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        
        headerSupplemntrry.pinToVisibleBounds = true
        
        section.boundarySupplementaryItems = [headerSupplemntrry]
        
        
        
        return section
    }
    
    func drawLatestResults() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(101))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 0, bottom: 8, trailing: 0)
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            let containerHeight = environment.container.contentSize.height
            let centerOffsetY = offset.y + environment.container.contentInsets.top + environment.container.contentInsets.bottom + environment.container.contentSize.height / 2.0
            
            items.forEach { item in
                let distanceFromCenter = abs(item.frame.midY - centerOffsetY)
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / containerHeight), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        
        // MARK: HEADER
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(32))
        
        let headerSupplemntrry = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        headerSupplemntrry.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
        
        headerSupplemntrry.pinToVisibleBounds = true
        
        section.boundarySupplementaryItems = [headerSupplemntrry]
        
        
        
        return section
    }
    
    func drawTeams() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.44), heightDimension: .absolute(101))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 16)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 0, bottom: 16, trailing: 0)
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = item.frame.midX - offset.x
                let maxRotationAngle: CGFloat = .pi / 24
                let rotationAngle = maxRotationAngle * (distanceFromCenter / environment.container.contentSize.width)
                item.transform = CGAffineTransform(rotationAngle: rotationAngle)
            }
        }
        
        // MARK: HEADER
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(32))
        
        let headerSupplemntrry = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        headerSupplemntrry.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        
        headerSupplemntrry.pinToVisibleBounds = true
        
        section.boundarySupplementaryItems = [headerSupplemntrry]
        
        return section
    }
    
    func layoutForSection(at index: Int) -> NSCollectionLayoutSection {
        switch index {
        case 0:
            return drawUpComingEvents()
        case 1:
            return drawLatestResults()
        default:
            return drawTeams()
        }
    }
    
    // MARK: Helper methods :-
    func updateButtonImage(_ flag: Bool) {
        var imageName = "heart"
        if flag {
            imageName = "heart.fill"
        } else {
            imageName = "heart"
        }
        let image = UIImage(systemName: imageName)
        favBtnOL.setImage(image, for: .normal)
    }
    
    // MARK: change leagu ID not to be static
    func fetchUpComingEvents(){
        
        leaguesDetailsVM.fetchUpComingEvents(leagueId: leagueId, sport: sport, onSuccess: {
            self.collectionView.reloadData()
            IndicatorManager.shared.stopIndicator()
        }, onFailure: { error in
            print("Error fetching upcoming events:", error)
            IndicatorManager.shared.stopIndicator()
        })
    }
    
    func fetchLatestEvent() {
        
        leaguesDetailsVM.fetchLatestEvent(leagueId: leagueId, sport: sport, onSuccess: {
            self.collectionView.reloadData()
            IndicatorManager.shared.stopIndicator()
        }, onFailure: { error in
            print("Error fetching latest event:", error)
            IndicatorManager.shared.stopIndicator()
        })
    }
    
    func fetchTeams () {
        
        leaguesDetailsVM.fetchTeams(leagueId: leagueId, sport: sport, onSuccess: {
            self.collectionView.reloadData()
            IndicatorManager.shared.stopIndicator()
        }, onFailure: { error in
            print("Error fetching teams:", error)
            IndicatorManager.shared.stopIndicator()
        }) // MARK: this id i will get from fav or leagues
    }
    
    func saveDataIfNotExist() -> Bool{
        let leagueKey = (Int(leaguesViewModel.selectedLeague ?? "207") ?? 207).toUUID()
        let existingLeagues = leaguesDetailsVM.fetchAllLeagues()
        var isSaving = false
        
        if let existingLeague = existingLeagues.first(where: { $0.leagueKey == leagueKey }) {
            if let existingLeagueKey = existingLeague.leagueKey {
                leaguesDetailsVM.deleteLeague(leagueKey: existingLeagueKey)
                isSaving = false
            } else {
                print("Error: Existing league key is nil")
            }
        } else {
            isSaving = true
            if let logoURLString = leaguesDetailsVM.upComingEvent.first?.leagueLogo,
               let logoURL = URL(string: logoURLString) {
                let leagueName = leaguesDetailsVM.upComingEvent.first?.leagueName
                
                KingfisherManager.shared.retrieveImage(with: logoURL) { result in
                    switch result {
                    case .success(let imageResult):
                        if let imageData = imageResult.image.kf.pngRepresentation() {
                            self.leaguesDetailsVM.saveLeague(leagueKey: leagueKey, leagueLogo: imageData, leagueName: leagueName ?? "Anas", sport: self.leaguesViewModel.selectedSport)
                        } else {
                            print("Failed to convert image to data")
                        }
                    case .failure(let error):
                        print("Error loading image:", error.localizedDescription)
                    }
                }
            } else {
                print("No logo URL provided or invalid URL")
            }
        }
        return isSaving
    }
    
    func isCurrentLeagueSaved() {
        let existingLeagues = leaguesDetailsVM.fetchAllLeagues()
        let leagueKey = (Int(leagueId ?? "207") ?? 207).toUUID()
        
        if existingLeagues.first(where: { $0.leagueKey == leagueKey }) != nil {
            let image = UIImage(systemName: "heart.fill")
            favBtnOL.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "heart")
            favBtnOL.setImage(image, for: .normal)
        }
    }
    
    @IBAction func addFavBtn(_ sender: Any) { // if it alleady in will delete it
        isFavorited.toggle()
        
        let isSaving = saveDataIfNotExist() // else delete
        
        updateButtonImage(isSaving)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension LeaguesDetailsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return leaguesDetailsVM.upComingEvent.count > 0 ? leaguesDetailsVM.upComingEvent.count : 1
        case 1:
            return leaguesDetailsVM.latestEvent.count
        default:
            return leaguesDetailsVM.teams.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellID: String
        
        switch indexPath.section {
        case 0:
            cellID = "UpcomingEventsCell"
        case 1:
            cellID = "LatestResultsCell"
        default:
            cellID = "TeamsCell"
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        if leaguesDetailsVM.upComingEvent.count > 0 {
            if let upComingEventsCell = cell as? UpcomingEventsCell {
                let upComingEventRes = leaguesDetailsVM.upComingEvent[indexPath.item]
                upComingEventsCell.setUp(upComingEventRes)
            }
        } else {
            if let upComingEventsCell = cell as? UpcomingEventsCell {
                upComingEventsCell.setUpMocData()
            }
        }
        
        if let latestResCell = cell as? LatestResultsCell {
            let latestRes = leaguesDetailsVM.latestEvent[indexPath.item]
            latestResCell.setUp(latestRes)
        }
        
        if let teamsCell = cell as? TeamsCell {
            let team = leaguesDetailsVM.teams[indexPath.item]
            teamsCell.setUp(team)
        }
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowColor = UIColor.black.cgColor
        
        //cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
        switch(indexPath.section) {
        case 0:
            header.headerSection.text = "Upcoming Event"
        case 1:
            header.headerSection.text = "Latest Result"
        default:
            header.headerSection.text = "Teams"
            
        }
        return header
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destVC = segue.destination as? TeamDetailsViewController else { return }
        
        if let cell = sender as? TeamsCell,
           let indexPath = collectionView.indexPath(for: cell) {
            
            leaguesDetailsVM.selectedTeamKey = leaguesDetailsVM.teams[indexPath.row].teamKey
            leaguesDetailsVM.selectedSport = leaguesViewModel.selectedSport
            destVC.leagueDetailsViewModel = leaguesDetailsVM
            
        }
        
    }
    
}

class HeaderView: UICollectionReusableView {
    @IBOutlet weak var headerSection: UILabel!
}
