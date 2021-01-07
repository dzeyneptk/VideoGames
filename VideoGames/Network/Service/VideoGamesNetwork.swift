//
//  VideoGamesNetwork.swift
//  VideoGames
//
//  Created by zeynep tokcan on 7.01.2021.
//

import Moya

let MServiceProvider = MoyaProvider<VideoGamesService>()

class MoodifyNetwork : BaseNetwork {
    
    private static let instance = MoodifyNetwork()
    
    public static var shared : MoodifyNetwork {
        return instance
    }
    
    func getTracks( success : @escaping NetworkSuccessBlock<BaseResponseModel> , failure : NetworkFailureBlock?){
        MServiceProvider.request(VideoGamesService.games) { (result) in
            super.processResponse(result: result, success: success, failure: failure)
        }
    }
    
}
