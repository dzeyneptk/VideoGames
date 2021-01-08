//
//  FavoritesCollectionViewCell.swift
//  VideoGames
//
//  Created by zeynep tokcan on 8.01.2021.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    static func nib() -> UINib {
        return UINib(nibName: AppConstant.collectionViewCellFavorites, bundle: nil )
    }
}
