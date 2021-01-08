//
//  FavoritesCollectionViewCell.swift
//  VideoGames
//
//  Created by zeynep tokcan on 8.01.2021.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var gameReleasedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Functions
    func configure(favorite: Favorite?) {
        posterImageView.kf.setImage(with: URL(string: favorite?.poster ?? ""))
        gameTitleLabel.text = favorite?.title
        gameRatingLabel.text = String(favorite?.rating ?? 0)
        gameReleasedLabel.text = favorite?.date
    }
    
    static func nib() -> UINib {
        return UINib(nibName: AppConstant.collectionViewCellFavorites, bundle: nil )
    }

}
