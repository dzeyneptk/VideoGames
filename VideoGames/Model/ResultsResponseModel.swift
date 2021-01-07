//
//  ResultsResponseModel.swift
//  VideoGames
//
//  Created by zeynep tokcan on 7.01.2021.
//

import Foundation
struct ResultsResponseModel : Codable {
    let name : String?
    let released : String?
    let background_image : String?
    let rating : Double?
}
