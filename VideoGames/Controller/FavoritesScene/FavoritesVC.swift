//
//  FavoritesVC.swift
//  VideoGames
//
//  Created by zeynep tokcan on 8.01.2021.
//

import UIKit
import CoreData

class FavoritesVC: UIViewController {
    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    private var favoritesArray = [FavoriteModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewFavorites()
        getFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    // MARK: Private Functions
    private func configureCollectionViewFavorites() {
        let layout = UICollectionViewFlowLayout()
        favoritesCollectionView.collectionViewLayout = layout
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .vertical
        favoritesCollectionView.register(FavoritesCollectionViewCell.nib(), forCellWithReuseIdentifier: AppConstant.collectionViewCellFavorites)
        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self
    }
    
    private func getFavorites() {
        favoritesArray.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            var mtitle = ""
            var mposter = ""
            var mrating = 0
            var mdate = ""
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let title = result.value(forKey: "gameTitle") as? String {
                        mtitle = title
                    }
                    if let poster = result.value(forKey: "gamePoster") as? String {
                        mposter = poster
                    }
                    if let rating = result.value(forKey: "rating") as? Int {
                        mrating = rating
                    }
                    if let date = result.value(forKey: "relasedDate") as? String {
                        mdate = date
                    }
                    self.favoritesArray.append(FavoriteModel(title: mtitle, poster: mposter, rating: mrating, date: mdate))
                    self.favoritesCollectionView.reloadData()
                }
            }
        } catch {
            print("error!")
        }
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesVC: UICollectionViewDelegate {
}
// MARK: - UICollectionViewDataSource
extension FavoritesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstant.collectionViewCellFavorites, for: indexPath) as! FavoritesCollectionViewCell
        cell.configure(favorite: favoritesArray[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesArray.count
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = self.favoritesCollectionView.frame.width
        return CGSize(width: width, height: 120)
    }
}
