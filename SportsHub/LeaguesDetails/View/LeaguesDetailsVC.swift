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
    private let leaguesDetailsVM = LeaguesDetailsVM()
    var leaguesViewModel: LeaguesViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isCurrentLeagueSaved() // see favBtn img will be heart.fill or not
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                    
        IndicatorManager.shared.setIndicator(on: self.view)
        
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
    func updateButtonImage(_ flag: Bool) {
        var imageName = ""
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
        leaguesDetailsVM.fetchUpComingEvents(leagueId: leaguesViewModel.selectedLeague, onSuccess: {
            self.collectionView.reloadData()
            IndicatorManager.shared.stopIndicator()
        }, onFailure: { error in
            print("Error fetching upcoming events:", error)
            IndicatorManager.shared.stopIndicator()
        })
    }
    
    func fetchLatestEvent() {
        leaguesDetailsVM.fetchLatestEvent(leagueId: leaguesViewModel.selectedLeague, onSuccess: {
            self.collectionView.reloadData()
            IndicatorManager.shared.stopIndicator()
        }, onFailure: { error in
            print("Error fetching latest event:", error)
            IndicatorManager.shared.stopIndicator()
        })
    }
    
    func fetchTeams () {
        leaguesDetailsVM.fetchTeams(leagueId: leaguesViewModel.selectedLeague, onSuccess: {
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
                            self.leaguesDetailsVM.saveLeague(leagueKey: leagueKey, leagueLogo: imageData, leagueName: leagueName ?? "Anas")
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
        let leagueKey = (Int(leaguesViewModel.selectedLeague ?? "207") ?? 207).toUUID()

        if let existingLeague = existingLeagues.first(where: { $0.leagueKey == leagueKey }) {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var teamID: String?

        switch indexPath.section {
        case 0:
            let upComingEventRes = leaguesDetailsVM.upComingEvent[indexPath.item]
            print("Tapped Upcoming Event: \(upComingEventRes)")
        case 1:
            let latestRes = leaguesDetailsVM.latestEvent[indexPath.item]
            print("Tapped Latest Result: \(latestRes)")
        default:
            // Handle Team
            let team = leaguesDetailsVM.teams[indexPath.item]
            teamID = String(team.teamKey)
        }
        
//        if let teamID = teamID {
//            // Navigate to another screen
//            let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
//            let destinationVC = storyboard.instantiateViewController(withIdentifier: "Destenation") as! Destenation
//            
//            destinationVC.teamID = teamID
//
//            navigationController?.pushViewController(destinationVC, animated: true)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destVC = segue.destination as? TeamDetailsViewController else { return }
        
        if let cell = sender as? TeamsCell,
           let indexPath = collectionView.indexPath(for: cell) {
            
            leaguesDetailsVM.selectedTeamKey = String(leaguesDetailsVM.teams[indexPath.row].teamKey)
            destVC.leagueDetailsViewModel = leaguesDetailsVM
            
        }
        
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






/*
 
 Hello, my name is Anas. I recently completed a 9-month program in Mobile Applications Development at

  -  ITI. My journey into programming began with CS50, an introduction to computer science, and
 
  -  progressed to the Meta iOS track. Now, I'm eager to start my career as a junior iOS Developer
    
  -  and contribute to innovative projects in the field. I'm passionate about creating good user
 
  -  experiences and leveraging the latest technologies to build peutyfull applications.
 
 */
