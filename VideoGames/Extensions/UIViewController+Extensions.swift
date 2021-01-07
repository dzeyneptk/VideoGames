//
//  UIViewController+Extensions.swift
//  VideoGames
//
//  Created by zeynep tokcan on 7.01.2021.
//

import UIKit

extension UIViewController {
    
    func alert(message: String, title: String = "", okButtonTitle: String = "OK", cancelButtonTitle: String? = nil, okHandler: ((UIAlertAction) -> Void)? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: okButtonTitle, style: .default, handler: okHandler)
        alertController.addAction(OKAction)
        if let cancelbtntitle = cancelButtonTitle {
            let cancelAction = UIAlertAction(title: cancelbtntitle, style: .cancel, handler: cancelHandler)
            alertController.addAction(cancelAction)
        }
        self.present(alertController, animated: true, completion: nil)
      }
    
}
