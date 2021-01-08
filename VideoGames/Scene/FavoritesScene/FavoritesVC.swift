//
//  FavoritesVC.swift
//  VideoGames
//
//  Created by zeynep tokcan on 8.01.2021.
//

import UIKit

class FavoritesVC: UIViewController {

    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewFavorites()
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
}

// MARK: - UICollectionViewDelegate
extension FavoritesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let cell = collectionView.cellForItem(at: indexPath) as? FavoritesCollectionViewCell else {return}
//        guard let gameName = cell.gameTitleLabel.text else {return}
//        chosenGameId = cityNameIdDictionary[gameName] ?? 0
    }
}
// MARK: - UICollectionViewDataSource
extension FavoritesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstant.collectionViewCellFavorites, for: indexPath) as! FavoritesCollectionViewCell
//        cell.configure(response: resultsResponse?[indexPath.row + 3])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = self.favoritesCollectionView.frame.width
        let height = self.favoritesCollectionView.frame.height / 2
        return CGSize(width: width, height: height)
        
    }
}
