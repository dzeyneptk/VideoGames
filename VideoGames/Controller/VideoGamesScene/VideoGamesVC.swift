//
//  ViewController.swift
//  VideoGames
//
//  Created by zeynep tokcan on 6.01.2021.
//

import UIKit
import NVActivityIndicatorView
import Kingfisher
import CoreData

protocol GameSelectDelegate {
    func onGameSelected(gameId: Int)
}

class VideoGamesVC: UIViewController {
    
    // MARK: - Private Variables
   // private var resultsResponse: [ResultsResponseModel]?
    private var detailResultsResponse: GameDetailResponseModel?
   // private var uiResponse: [ResultsResponseModel]?
    private var slides : [Slide] = []
    private var slide1 : Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
    private var slide2 : Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
    private var slide3 : Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
   // private var gameNameIdDictionary = [String: Int]()
    private var isEmpty = true
    private var favoritesArray = [FavoriteModel]()
    private var videoGamesViewModel = VideoGamesViewModel()
    var delegate: GameSelectDelegate?
    var chosenGameId = 0
    
    // MARK: - IBOutlets
    @IBOutlet weak var headerGamesScroll: UIScrollView!
    @IBOutlet weak var headerGamesPageControl: UIPageControl!
    @IBOutlet weak var gamesCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var notFoundLabel: UILabel!
    @IBOutlet weak var zeroHeightConstraintScrollView: NSLayoutConstraint!
    @IBOutlet weak var zeroHeightConstraintPageControl: NSLayoutConstraint!
    
    
    // MARK: -  Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        videoGamesViewModel.delegate = self
        videoGamesViewModel.configureVideoGamesNetwork()
        configureUI()
        configureSearchbar()
        configureCollectionViewGames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isEmpty = true
        searchBar.text = ""
        gamesCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .clear
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange])
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            let image:UIImage = UIImage(named: "loupe")!
            let imageView:UIImageView = UIImageView.init(image: image)
            textfield.leftView = nil
            textfield.rightView = imageView
            textfield.rightViewMode = UITextField.ViewMode.always
            let border = CALayer()
            let borderWidth = CGFloat(1.0)
            border.borderColor = UIColor.orange.cgColor
            border.frame = CGRect(x: 0, y: textfield.frame.size.height - borderWidth, width: textfield.frame.size.width, height: textfield.frame.size.height)
            border.borderWidth = borderWidth
            textfield.layer.addSublayer(border)
            textfield.layer.masksToBounds = true
        }
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
    
    private func configureSearchbar(){
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.isUserInteractionEnabled = true
        searchBar.sizeToFit()
        definesPresentationContext = true
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .clear
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange])
    }
    
    private func configureUI() {
        headerGamesScroll.delegate = self
        slides = createSlides()
        headerGamesPageControl.numberOfPages = slides.count
        headerGamesPageControl.currentPage = 0
        view.bringSubviewToFront(headerGamesPageControl)
        setupSlideScrollView(slides: slides)
    }
    
    //    private func configureVideoGamesNetwork() {
    //        LoadingIndicator.shared.show()
    //        VideoGamesNetwork.shared.getGames { [weak self] (response) in
    //            guard let self = self else {return}
    //            self.resultsResponse = response.results
    //            self.uiResponse = response.results
    //            if let results = self.resultsResponse {
    //                for index in results.indices  {
    //                    self.gameNameIdDictionary[results[index].name ?? ""] = results[index].id
    //                }
    //            }
    //            self.configureCollectionViewGames()
    //            self.configurePagerPosters()
    //            LoadingIndicator.shared.hide()
    //        } failure: { (error) in
    //            self.alert(message: error.message)
    //            LoadingIndicator.shared.hide()
    //        }
    //    }
    
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
        let response = videoGamesViewModel.getAllGames()
        slide1.posterImageView.kf.setImage(with: URL(string: response[0].background_image))
        slide2.posterImageView.kf.setImage(with: URL(string: response[1].background_image))
        slide3.posterImageView.kf.setImage(with: URL(string: response[2].background_image))
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.gameClicked1))
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.gameClicked2))
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector(self.gameClicked3))
        slide1.posterImageView.addGestureRecognizer(gesture1)
        slide2.posterImageView.addGestureRecognizer(gesture2)
        slide3.posterImageView.addGestureRecognizer(gesture3)
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
    
    @objc private func gameClicked1() {
        configureGameDetailNetwork(gameId: String(videoGamesViewModel.getAllGames()[0].id))
    }
    @objc private func gameClicked2() {
        configureGameDetailNetwork(gameId: String(videoGamesViewModel.getAllGames()[1].id))
    }
    @objc private func gameClicked3() {
        configureGameDetailNetwork(gameId: String(videoGamesViewModel.getAllGames()[2].id))
    }
}

// MARK: - UICollectionViewDelegate
extension VideoGamesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? VideoGamesCollectionViewCell else {return}
        guard let gameName = cell.gameTitleLabel.text else {return}
       // chosenGameId = gameNameIdDictionary[gameName] ?? 0
        configureGameDetailNetwork(gameId: String(chosenGameId))
    }
}
// MARK: - UICollectionViewDataSource
extension VideoGamesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstant.collectionViewCellVideoGames, for: indexPath) as! VideoGamesCollectionViewCell
        if headerGamesScroll.isHidden {
            cell.configure(viewModel: videoGamesViewModel.searchedGames[indexPath.row])
        } else {
            cell.configure(viewModel: videoGamesViewModel.getAllGames()[indexPath.row + 3])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerGamesScroll.isHidden ? videoGamesViewModel.countSearchedGames : videoGamesViewModel.countAllGames
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension VideoGamesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = self.gamesCollectionView.frame.width
        return CGSize(width: width, height: 120)
        
    }
}

// MARK: UIScrollViewDelegate
extension VideoGamesVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        headerGamesPageControl.currentPage = Int(pageIndex)
    }
}

// MARK: - UISearchDelegate
extension VideoGamesVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isEmpty = true
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.gamesCollectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getSearchProcess(searchText: searchText)
    }
    
    private func getSearchProcess(searchText: String) {
        getZeroHeight()
        if searchText.count > 3 {
            zeroHeightConstraintScrollView.isActive = true
            zeroHeightConstraintPageControl.isActive = true
            hideScroll()
            self.isEmpty = false
            videoGamesViewModel.getSearchedGames(searchText: searchText)
        }
        if searchBarIsEmpty() {
            zeroHeightConstraintScrollView.isActive = false
            zeroHeightConstraintPageControl.isActive = false
            hideScroll()
            self.isEmpty = true
            searchBar.text = ""
            self.notFoundLabel.isHidden = true
            self.gamesCollectionView.reloadData()
        }
    }
    
    private func getZeroHeight() {
        if zeroHeightConstraintScrollView == nil {
            zeroHeightConstraintScrollView = headerGamesScroll.heightAnchor.constraint(equalToConstant: 0)
        }
        
        if zeroHeightConstraintPageControl == nil {
            zeroHeightConstraintPageControl = headerGamesPageControl.heightAnchor.constraint(equalToConstant: 0)
        }
    }
    
    private func hideScroll() {
        headerGamesScroll.isHidden = !searchBarIsEmpty()
        headerGamesPageControl.isHidden = !searchBarIsEmpty()
    }
}

extension VideoGamesVC: VideoGamesDelegate {
    func failWith(error: String?) {
        if let err = error, err != "" {
            self.alert(message: err)
            return
        }
        self.gamesCollectionView.reloadData()
        notFoundLabel.isHidden = false
    }
    
    func succes() {
        self.configurePagerPosters()
        self.gamesCollectionView.reloadData()
        notFoundLabel.isHidden = true
    }
}
