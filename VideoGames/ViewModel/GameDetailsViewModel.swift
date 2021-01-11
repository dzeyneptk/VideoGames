//
//  GameDetailsViewModel.swift
//  VideoGames
//
//  Created by zeynep tokcan on 11.01.2021.
//

import Foundation

protocol GameDetailsDelegate: class {
    func fail(error: String?)
    func succesDetails()
}

class GameDetailsViewModel {
    
    private var responseModel: GameDetailResponseModel?
    var delegate: GameDetailsDelegate?
    
    func configureGameDetailNetwork(gameId: String) {
        LoadingIndicator.shared.show()
        VideoGamesNetwork.shared.getGameDetails(gameId) { (response) in
            self.responseModel = response
            LoadingIndicator.shared.hide()
            self.delegate?.succesDetails()
        } failure: { (error) in
            LoadingIndicator.shared.hide()
            self.delegate?.fail(error: error.message)
        }
    }
    
    var id : Int {
        return responseModel?.id ?? 0
    }
    
    var name : String {
        return responseModel?.name ?? ""
    }
    
    var description : String {
        return responseModel?.description ?? ""
    }
    
    var metacritic : Int {
        return responseModel?.metacritic ?? 0
    }
    
    var released : String {
        return responseModel?.released ?? ""
    }
    
    var background_image : String {
        return responseModel?.background_image ?? ""
    }
}
