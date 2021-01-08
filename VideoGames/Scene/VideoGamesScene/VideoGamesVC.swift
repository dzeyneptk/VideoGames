//
//  ViewController.swift
//  VideoGames
//
//  Created by zeynep tokcan on 6.01.2021.
//

import UIKit
import NVActivityIndicatorView
import Kingfisher

protocol GameSelectDelegate {
    func onGameSelected(gameId: Int)
}

class VideoGamesVC: UIViewController {
    
    // MARK: - Private Variables
    private var resultsResponse: [ResultsResponseModel]?
    private var detailResultsResponse: GameDetailResponseModel?
    private var slides : [Slide] = []
    private var slide1 : Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
    private var slide2 : Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
    private var slide3 : Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
    private var cityNameIdDictionary = [String: Int]()
    var delegate: GameSelectDelegate?
    var chosenGameId = 0
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var headerGamesScroll: UIScrollView!
    @IBOutlet weak var headerGamesPageControl: UIPageControl!
    @IBOutlet weak var gamesCollectionView: UICollectionView!
    
    // MARK: -  Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideoGamesNetwork()
        headerGamesScroll.delegate = self
        slides = createSlides()
        headerGamesPageControl.numberOfPages = slides.count
        headerGamesPageControl.currentPage = 0
        view.bringSubviewToFront(headerGamesPageControl)
        setupSlideScrollView(slides: slides)
    }
    
    // MARK: Private Functions
    private func configureCollectionViewGames() {
        let layout = UICollectionViewFlowLayout()
        gamesCollectionView.collectionViewLayout = layout
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .vertical
        gamesCollectionView.register(VideoGamesCollectionViewCell.nib(), forCellWithReuseIdentifier: AppConstant.collectionViewCellVideoGames)
        gamesCollectionView.delegate = self
        gamesCollectionView.dataSource = self
    }
    
    private func configureVideoGamesNetwork() {
        LoadingIndicator.shared.show()
        VideoGamesNetwork.shared.getGames { [weak self] (response) in
            guard let self = self else {return}
            self.resultsResponse = response.results
            if let results = self.resultsResponse {
                for index in results.indices  {
                    self.cityNameIdDictionary[results[index].name ?? ""] = results[index].id
                }
            }
            self.configureCollectionViewGames()
            self.configurePagerPosters()
            LoadingIndicator.shared.hide()
        } failure: { (error) in
            self.alert(message: error.message)
            LoadingIndicator.shared.hide()
        }
    }
    
    private func configureGameDetailNetwork(gameId: String) {
        LoadingIndicator.shared.show()
        VideoGamesNetwork.shared.getGameDetails(gameId) { (response) in
            self.detailResultsResponse = response
            LoadingIndicator.shared.hide()
            self.openDetailVC()
        } failure: { (error) in
            self.alert(message: error.message)
            LoadingIndicator.shared.hide()
        }

    }
    
    private func openDetailVC() {
        guard let detailVC = UIStoryboard(name: "VideoGameDetail", bundle: nil).instantiateViewController(withIdentifier: "Gamedetail") as? VideoGameDetailVC else {return}
        let detailNav = UINavigationController(rootViewController: detailVC)
        detailNav.modalPresentationStyle = .fullScreen
        detailVC.detailGameResponse = detailResultsResponse
        self.present(detailNav, animated: true, completion: nil)
    }
    
    private func configurePagerPosters() {
        slide1.posterImageView.kf.setImage(with: URL(string: resultsResponse?[0].background_image ?? ""))
        slide2.posterImageView.kf.setImage(with: URL(string: resultsResponse?[1].background_image ?? ""))
        slide3.posterImageView.kf.setImage(with: URL(string: resultsResponse?[2].background_image ?? ""))
    }
    
    private func createSlides() -> [Slide] {
        return [slide1, slide2, slide3]
    }
    
    private func setupSlideScrollView(slides : [Slide]) {
        headerGamesScroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        headerGamesScroll.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height / 6)
        headerGamesScroll.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            headerGamesScroll.addSubview(slides[i])
        }
    }
}

// MARK: - UICollectionViewDelegate
extension VideoGamesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let cell = collectionView.cellForItem(at: indexPath) as? VideoGamesCollectionViewCell else {return}
        guard let gameName = cell.gameTitleLabel.text else {return}
        chosenGameId = cityNameIdDictionary[gameName] ?? 0
        configureGameDetailNetwork(gameId: String(chosenGameId))
    }
}
// MARK: - UICollectionViewDataSource
extension VideoGamesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstant.collectionViewCellVideoGames, for: indexPath) as! VideoGamesCollectionViewCell
        cell.configure(response: resultsResponse?[indexPath.row + 3])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsResponse != nil ? resultsResponse!.count : 0
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension VideoGamesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = self.gamesCollectionView.frame.width
        let height = self.gamesCollectionView.frame.height / 2
        return CGSize(width: width, height: height)
        
    }
}

// MARK: UIScrollViewDelegate
extension VideoGamesVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        headerGamesPageControl.currentPage = Int(pageIndex)
    }
}
