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
    
    // MARK: - Functions
    func configure(viewModel: ResultsViewModel?) {
        posterImageView.kf.setImage(with: URL(string: viewModel?.background_image ?? ""))
        gameTitleLabel.text = viewModel?.name
        gameRatingLabel.text = String(viewModel?.rating ?? 0.0)
        gameReleasedLabel.text = viewModel?.released
    }
    
    static func nib() -> UINib {
        return UINib(nibName: AppConstant.collectionViewCellVideoGames, bundle: nil )
    }
}
