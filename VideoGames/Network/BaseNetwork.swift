//
//  BaseNetwork.swift
//  VideoGames
//
//  Created by zeynep tokcan on 7.01.2021.
//

import Foundation
import Moya

typealias NetworkFailureBlock = ((VideoGamesNetworkError) -> ())
typealias NetworkSuccessBlock<T> = ((T) -> ()) where T:Codable

let JSON_ERROR_CODE = 1


class BaseNetwork {
    func processResponse<T>(result : Result<Moya.Response,MoyaError>, success : NetworkSuccessBlock<T>? , failure : NetworkFailureBlock? ) {
        switch result {
            case let .success(response):
                validate(response, success: success, failure: failure)
            case let .failure(error):
                failure?(VideoGamesNetworkError(message: error.errorDescription ?? ""))
        }
    }
    
    private func validate<T>(_ response : Response , success : NetworkSuccessBlock<T>?, failure : NetworkFailureBlock?){
        if ( response.statusCode >= 200 && response.statusCode < 300){
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(.serverToClient)
                let data = try response.map(T.self, using: decoder)
                success?(data)
            } catch (let error){
                print(error)
                failure?(VideoGamesNetworkError())
            }
        }else{
            do {
                let data = try response.map(ErrorResponse.self)
                failure?(VideoGamesNetworkError(errorResponse: data,code: response.statusCode))
            } catch {
                failure?(VideoGamesNetworkError(code: JSON_ERROR_CODE))
            }
            
        }
    }
}
