//
//  ResultsViewModel.swift
//  VideoGames
//
//  Created by zeynep tokcan on 11.01.2021.
//

import Foundation

class ResultsViewModel {
    
    private var responseModel: ResultsResponseModel
    
    init (model: ResultsResponseModel) {
        self.responseModel = model
    }
    
    var name : String {
        return responseModel.name ?? ""
    }
    
    var released : String {
        return responseModel.released ?? ""
    }
    
    var background_image : String {
        return responseModel.background_image ?? ""
    }
    
    var rating : Double {
        return responseModel.rating ?? 0.0
    }
    
    var id: Int {
        return responseModel.id ?? 0
    }
}
