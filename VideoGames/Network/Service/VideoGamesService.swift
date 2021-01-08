//
//  VideoGamesService.swift
//  VideoGames
//
//  Created by zeynep tokcan on 7.01.2021.
//

import Foundation
import Moya

public enum VideoGamesService {
    case games
    case gameDetailsByGameId( _ gameId : String)
}

extension VideoGamesService: TargetType {
    public var baseURL: URL {
        return URL(string: BASE_URL)!
    }
    
    public var path: String {
        switch self {
        case .games:
            return "/games"
        case .gameDetailsByGameId(let gameId):
            return "/games/\(gameId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .games, .gameDetailsByGameId:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {

        switch self {
        case .games, .gameDetailsByGameId:
            return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        
        return ["Content-Type": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
