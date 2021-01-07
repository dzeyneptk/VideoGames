//
//  BaseResponseModel.swift
//  VideoGames
//
//  Created by zeynep tokcan on 7.01.2021.
//

import Foundation

struct BaseResponseModel : Codable {
    let results : [ResultsResponseModel]?
    let count : Int?
}
