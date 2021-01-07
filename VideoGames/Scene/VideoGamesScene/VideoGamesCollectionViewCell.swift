//
//  VideoGamesCollectionViewCell.swift
//  VideoGames
//
//  Created by zeynep tokcan on 7.01.2021.
//

import UIKit
import Kingfisher

class VideoGamesCollectionViewCell: UICollectionViewCell {

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
    func configure(response: ResultsResponseModel?) {
        posterImageView.kf.setImage(with: URL(string: response?.background_image ?? ""))
        gameTitleLabel.text = response?.name
        gameRatingLabel.text = String(response?.rating ?? 0.0)
        gameReleasedLabel.text = response?.released
    }
    
    static func nib() -> UINib {
        return UINib(nibName: AppConstant.collectionViewCellVideoGames, bundle: nil )
    }
}
