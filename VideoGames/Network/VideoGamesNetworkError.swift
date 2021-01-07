//
//  VideoGamesNetworkError.swift
//  VideoGames
//
//  Created by zeynep tokcan on 7.01.2021.
//

import Foundation
struct VideoGamesNetworkError : Error {
    
    private(set) public var title: String
    private(set) public var message: String
    private(set) public var code: Int

    static let defaultErrorMessage = "Default Error Message"
    static let defaultErrorTitle = "Error!"
    static let defaultErrorCode = 0
    
    
    init(errorResponse : ErrorResponse, code : Int ) {
        self.init( message: errorResponse.message ?? VideoGamesNetworkError.defaultErrorMessage,code: code)
    }
    
    init(title: String = defaultErrorTitle, message: String = defaultErrorMessage, code : Int = defaultErrorCode) {
        self.message = message
        self.title = title
        self.code = code
    }
    
}
