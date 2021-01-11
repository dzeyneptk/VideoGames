//
//  VideoGameDetailVC.swift
//  VideoGames
//
//  Created by zeynep tokcan on 7.01.2021.
//

import UIKit
import Kingfisher
import CoreData

class VideoGameDetailVC: UIViewController {
    
    // MARK: - Variables
    var detailGamesViewModel: GameDetailsViewModel?
    private var isFavorite = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var relaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var gamePosterImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    // MARK: -  Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        createCloseBarButtonItem()
        getFavorites()
    }
    
    // MARK: Private Functions
    private func configureUI() {
        gameTitle.text = detailGamesViewModel?.name
        relaseDateLabel.text = detailGamesViewModel?.released
        ratingLabel.text = String(detailGamesViewModel?.metacritic ?? 0)
        gamePosterImageView.kf.setImage(with: URL(string: detailGamesViewModel?.background_image ?? ""))
        descriptionTextView.text = detailGamesViewModel?.description
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.favoriteClicked))
        self.favoriteImageView.addGestureRecognizer(gesture)
    }
    
    private func getFavorites() {
        var predicate: NSPredicate = NSPredicate()
        if let gameTitle = gameTitle.text {
            predicate = NSPredicate(format: "gameTitle contains[c] '\(gameTitle)'")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            fetchRequest.predicate = predicate
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let isFavorited = result.value(forKey: "isFavorited") as? Bool {
                            if isFavorited {
                                favoriteImageView.image = UIImage(named: "heart")
                                self.isFavorite = true
                            }
                        }
                    }
                }
            } catch {
                print("error!")
            }
        }
        
    }
    
    private func deleteFavorite(gameTitle: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "gameTitle contains[c] '\(gameTitle)'")
        let context = appDelegate.persistentContainer.viewContext
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
            try context.save()
        } catch _ {
            print("error!")
        }
    }
    
    @objc private func favoriteClicked() {
        isFavorite = !isFavorite
        if isFavorite {
            favoriteImageView.image = UIImage(named: "heart")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context)
            favorite.setValue(detailGamesViewModel?.released, forKey: "relasedDate")
            favorite.setValue(detailGamesViewModel?.metacritic, forKey: "rating")
            favorite.setValue(detailGamesViewModel?.name, forKey: "gameTitle")
            favorite.setValue(detailGamesViewModel?.background_image, forKey: "gamePoster")
            favorite.setValue(true, forKey: "isFavorited")
            
        } else {
            favoriteImageView.image = UIImage(named: "favorite")
            deleteFavorite(gameTitle: detailGamesViewModel?.name ?? "")
        }
    }
}
