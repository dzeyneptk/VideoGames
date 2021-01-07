//
//  IndicatorView.swift
//  VideoGames
//
//  Created by zeynep tokcan on 7.01.2021.
//

import Foundation
import NVActivityIndicatorView

class LoadingIndicator {
    
    public static let shared = LoadingIndicator()
    
    private var containerView = UIView()
    
    private var activityIndicator = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 80, height: 80)), type: .ballRotateChase, color: UIColor(named: "primaryColor"))
    
    func show() {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        containerView.frame = window.frame
        containerView.center = window.center
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        activityIndicator.center = CGPoint(x: containerView.bounds.width / 2, y: containerView.bounds.height / 2)
        
        containerView.addSubview(activityIndicator)
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.addSubview(self.containerView)
            self.activityIndicator.startAnimating()
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.containerView.removeFromSuperview()
        }
    }
 
}
