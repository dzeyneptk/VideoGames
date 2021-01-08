//
//  VideoGameDetailVC.swift
//  VideoGames
//
//  Created by zeynep tokcan on 7.01.2021.
//

import UIKit
import Kingfisher

class VideoGameDetailVC: UIViewController {
    
    // MARK: - Variables
    var detailGameResponse: GameDetailResponseModel?
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
    }
    
    // MARK: Private Functions
    private func configureUI() {
        gameTitle.text = detailGameResponse?.name
        relaseDateLabel.text = detailGameResponse?.released
        ratingLabel.text = String(detailGameResponse?.metacritic ?? 0)
        gamePosterImageView.kf.setImage(with: URL(string: detailGameResponse?.background_image ?? ""))
        descriptionTextView.text = detailGameResponse?.description
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.favoriteClicked))
        self.favoriteImageView.addGestureRecognizer(gesture)
    }
    
    
    
    @objc private func favoriteClicked() {
        isFavorite = !isFavorite
        if isFavorite {
            favoriteImageView.image = UIImage(named: "heart")
        } else {
            favoriteImageView.image = UIImage(named: "favorite")
        }
    }
}
