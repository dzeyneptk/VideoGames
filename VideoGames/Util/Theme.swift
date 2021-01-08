//
//  Theme.swift
//  VideoGames
//
//  Created by zeynep tokcan on 8.01.2021.
//

import Foundation
import UIKit

final class Theme {
    
    static func apply() {
        
        let navigationBar = UINavigationBar.appearance()
        navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont()
        ]
        
        let backImage = UIImage(named: "backIco")
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationBar.tintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(nil, for: .default)
        
        
        
        //navigationController?.navigationBar.topItem?.backBarButtonItem =
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .black
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white,
                                              .font: UIFont()]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            let backButtonAppearence = UIBarButtonItemAppearance()
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
            backButtonAppearence.normal.titleTextAttributes = titleTextAttributes
            backButtonAppearence.highlighted.titleTextAttributes = titleTextAttributes
            appearance.backButtonAppearance = backButtonAppearence
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            navigationBar.isTranslucent = false
            
        }
        
    }
}
