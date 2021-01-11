//
//  VideoGamesViewModel.swift
//  VideoGames
//
//  Created by zeynep tokcan on 11.01.2021.
//

import Foundation

protocol VideoGamesDelegate: class {
    func failWith(error: String?)
    func succes()
}

class VideoGamesViewModel {
    private var resultsResponseModel: [ResultsResponseModel]?
    private var searchedResponseModel: [ResultsResponseModel]?
    private var viewModel: [ResultsViewModel] = []
    weak var delegate: VideoGamesDelegate?
    
    func configureVideoGamesNetwork() {
        LoadingIndicator.shared.show()
        VideoGamesNetwork.shared.getGames { [weak self] (response) in
            guard let self = self else {return}
            self.resultsResponseModel = response.results
            LoadingIndicator.shared.hide()
            self.delegate?.succes()
        } failure: { (error) in
            LoadingIndicator.shared.hide()
            self.delegate?.failWith(error: error.message)
        }
    }
    
    func getSearchedGames(searchText: String){
        self.searchedResponseModel = resultsResponseModel?.filter({ (response) -> Bool in
            (response.name?.lowercased().contains(searchText.lowercased()) ?? false)
        })
        if let model = searchedResponseModel, !model.isEmpty {
            self.viewModel.removeAll()
            searchedResponseModel?.forEach({ (model) in
                self.viewModel.append(ResultsViewModel(model: model))
            })
            self.delegate?.succes()
        } else {
            self.delegate?.failWith(error: "")
        }
    }
    
    var searchedGames: [ResultsViewModel] {
        return viewModel
    }
    
    var countSearchedGames: Int {
        return searchedResponseModel?.count ?? 0
    }
    
    var countAllGames: Int {
        return resultsResponseModel?.count ?? 0
    }
    
    func getAllGames() -> [ResultsViewModel] {
        var viewModel = [ResultsViewModel]()
        resultsResponseModel?.forEach({ (model) in
            viewModel.append(ResultsViewModel(model: model))
        })
        return viewModel
    }
}
