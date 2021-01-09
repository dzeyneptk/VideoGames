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
    private var resultsResponse: [ResultsResponseModel]?
    private var detailResultsResponse: GameDetailResponseModel?
    private var uiResponse: [ResultsResponseModel]?
    private var slides : [Slide] = []
    private var slide1 : Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
    private var slide2 : Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
    private var slide3 : Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
    private var cityNameIdDictionary = [String: Int]()
    private var isEmpty = true
    private var favoritesArray = [FavoriteModel]()
    var delegate: GameSelectDelegate?
    var chosenGameId = 0
    
    // MARK: - IBOutlets
    //  @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var headerGamesScroll: UIScrollView!
    @IBOutlet weak var headerGamesPageControl: UIPageControl!
    @IBOutlet weak var gamesCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var notFoundLabel: UILabel!
    
    
    // MARK: -  Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideoGamesNetwork()
        configureUI()
        configureSearchbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // movieDetailVM.delegate = self
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
    
    private func configureVideoGamesNetwork() {
        LoadingIndicator.shared.show()
        VideoGamesNetwork.shared.getGames { [weak self] (response) in
            guard let self = self else {return}
            self.resultsResponse = response.results
            self.uiResponse = response.results
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
        configureGameDetailNetwork(gameId: String(resultsResponse?[0].id ?? 0))
    }
    @objc private func gameClicked2() {
        configureGameDetailNetwork(gameId: String(resultsResponse?[1].id ?? 0))
    }
    @objc private func gameClicked3() {
        configureGameDetailNetwork(gameId: String(resultsResponse?[2].id ?? 0))
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
        if headerGamesScroll.isHidden {
            cell.configure(response: uiResponse?[indexPath.row])
        } else {
            cell.configure(response: uiResponse?[indexPath.row + 3])
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uiResponse != nil ? uiResponse!.count : 0
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
        headerGamesScroll.isHidden = !searchBarIsEmpty()
        headerGamesPageControl.isHidden = !searchBarIsEmpty()
        if(searchBarIsEmpty()){
            self.isEmpty = true
            searchBar.text = ""
            showGames(games: resultsResponse)
        } else {
            self.isEmpty = false
            if let resultList = self.resultsResponse?.filter({ (response) -> Bool in
                (response.name?.lowercased().contains(searchText.lowercased()))!
            }) {
                showGames(games: resultList)
                notFoundLabel.isHidden = resultList.count > 0
            }
        }
    }
    
    private func showGames(games: [ResultsResponseModel]?) {
        self.uiResponse = games
        self.gamesCollectionView.reloadData()
        self.notFoundLabel.isHidden = true
    }
}
