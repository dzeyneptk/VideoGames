//
//  GameDetailResponseModel.swift
//  VideoGames
//
//  Created by zeynep tokcan on 7.01.2021.
//

import Foundation

struct GameDetailResponseModel : Codable {
    let id : Int?
    let name : String?
    let description : String?
    let metacritic : Int?
    let released : String?
    let background_image : String?
 }
