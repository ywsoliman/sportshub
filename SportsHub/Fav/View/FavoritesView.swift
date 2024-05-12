//
//  FavoritesVM.swift
//  SportsHub
//
//  Created by Anas Salah on 11/05/2024.
//

import UIKit
import CoreData


class FavoritesView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var viewModel: FavoritesViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchDataFromCoreData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { // 1
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext // 2
        
        viewModel = FavoritesViewModel(managedContext: managedContext)
        
        viewModel.fetchDataFromCoreData()
        
        viewModel.dataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { viewModel.numberOfFavorites() }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else {
            fatalError("Unable to dequeue CustomTableViewCell")
        }
        
        guard let favorite = viewModel.favoriteAtIndex(indexPath.section) else {
            fatalError("Unable to get favorite at index \(indexPath.section)")
        }
        
        cell.leagueName.text = favorite.leagueName
        
        if let logoString = favorite.leagueLogo,
           let imageUrl = URL(string: logoString),
           let imageData = try? Data(contentsOf: imageUrl),
           let leagueImage = UIImage(data: imageData) {
            cell.leagueImage.image = leagueImage
        } else {
            cell.leagueImage.image = UIImage(named: "SportsLogo")
        }

        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteFavorite(atIndex: indexPath.section)
            
            tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
    }

}

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var leagueImage: UIImageView!
}


/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/
