//
//  DateFormatter+Extensions.swift
//  VideoGames
//
//  Created by zeynep tokcan on 7.01.2021.
//

import Foundation
extension DateFormatter {
    

    static let serverToClient: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        return formatter
    }()
    
    static let orderListFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

}
