//
//  VideoGamesNetwork.swift
//  VideoGames
//
//  Created by zeynep tokcan on 7.01.2021.
//

import Moya

let MServiceProvider = MoyaProvider<VideoGamesService>()

class VideoGamesNetwork : BaseNetwork {
    
    private static let instance = VideoGamesNetwork()
    
    public static var shared : VideoGamesNetwork {
        return instance
    }
    
    func getGames( success : @escaping NetworkSuccessBlock<BaseResponseModel> , failure : NetworkFailureBlock?){
        MServiceProvider.request(VideoGamesService.games) { (result) in
            super.processResponse(result: result, success: success, failure: failure)
        }
    }
    
    func getGameDetails(  _ gameId : String , success : @escaping NetworkSuccessBlock<GameDetailResponseModel> , failure : NetworkFailureBlock?){
        MServiceProvider.request(VideoGamesService.gameDetailsByGameId(gameId)) { (result) in
            super.processResponse(result: result, success: success, failure: failure)
        }
    }
}
