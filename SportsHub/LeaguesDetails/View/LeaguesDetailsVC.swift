//
//  LeaguesDetailsVC.swift
//  SportsHub
//
//  Created by Anas Salah on 12/05/2024.
//

import UIKit

class LeaguesDetailsVC: UIViewController {

    @IBOutlet weak var favBtnOL: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isFavorited = false // this flag for change btnFav image
    let leaguesDetailsVM = LeaguesDetailsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IndicatorManager.shared.setIndicator(on: self.view)
        
        fetchUpComingEvents()
        fetchLatestEvent()
        fetchTeams()
          
        // Do any additional setup after loading the view.
        let layOut = UICollectionViewCompositionalLayout{ index, enviroment in
            return self.layoutForSection(at: index)
        }
        collectionView.collectionViewLayout = layOut
    }
        
    func drawUpComingEvents() -> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(219))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 0)
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return section
    }
    
    func drawLatestResults() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(101))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8)
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

        
        return section
    }
    
    func drawTeams() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.44), heightDimension: .absolute(101))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 32, leading: 16, bottom: 16, trailing: 0)
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = item.frame.midX - offset.x
                let maxRotationAngle: CGFloat = .pi / 24
                let rotationAngle = maxRotationAngle * (distanceFromCenter / environment.container.contentSize.width)
                item.transform = CGAffineTransform(rotationAngle: rotationAngle)
            }
        }
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
    func updateButtonImage() {
        let imageName = isFavorited ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        favBtnOL.setImage(image, for: .normal)
    }
    
    func fetchUpComingEvents(){
        leaguesDetailsVM.fetchUpComingEvents(leagueId: "207", onSuccess: {
            self.collectionView.reloadData()
            IndicatorManager.shared.stopIndicator()
        }, onFailure: { error in
            print("Error fetching upcoming events:", error)
            IndicatorManager.shared.stopIndicator()
        })
    }
    
    func fetchLatestEvent() {
        leaguesDetailsVM.fetchLatestEvent(leagueId: "207", onSuccess: {
            self.collectionView.reloadData()
            IndicatorManager.shared.stopIndicator()
        }, onFailure: { error in
            print("Error fetching latest event:", error)
            IndicatorManager.shared.stopIndicator()
        })
    }
    
    func fetchTeams () {
        leaguesDetailsVM.fetchTeams(leagueId: "207", onSuccess: {
            self.collectionView.reloadData()
            IndicatorManager.shared.stopIndicator()
        }, onFailure: { error in
            print("Error fetching teams:", error)
            IndicatorManager.shared.stopIndicator()
        }) // MARK: this id i will get from fav or leagues
    }
    
    @IBAction func addFavBtn(_ sender: Any) {
        isFavorited.toggle()
        updateButtonImage()
    }
    

}

extension LeaguesDetailsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0:
            return leaguesDetailsVM.upComingEvent.count
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
        
        if let upComingEventsCell = cell as? UpcomingEventsCell {
            let upComingEventRes = leaguesDetailsVM.upComingEvent[indexPath.item]
            upComingEventsCell.setUp(upComingEventRes)
        }
        
        if let latestResCell = cell as? LatestResultsCell {
            let latestRes = leaguesDetailsVM.latestEvent[indexPath.item]
            latestResCell.setUp(latestRes)
        }
        
        if let teamsCell = cell as? TeamsCell {
            let team = leaguesDetailsVM.teams[indexPath.item] // Assuming you have an array of teams
            teamsCell.setUp(team)
        }
        

        
        //
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        
        cell.layer.shadowOpacity = 0.1
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowColor = UIColor.black.cgColor
    
        return cell
    }
}

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/


/*
 func drawUpComingEvents() -> NSCollectionLayoutSection{
     
     let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
     let item = NSCollectionLayoutItem(layoutSize: itemSize)
     
     let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(219))
     let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
     group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
     
     let section = NSCollectionLayoutSection(group: group)
     section.orthogonalScrollingBehavior = .continuous
     section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 0)

     section.visibleItemsInvalidationHandler = { (items, offset, environment) in
         items.forEach { item in
             let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
             let minScale: CGFloat = 0.8
             let maxScale: CGFloat = 1.0
             let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
             item.transform = CGAffineTransform(scaleX: scale, y: scale)
         }
     }
     
     return section
 }
 
 */
