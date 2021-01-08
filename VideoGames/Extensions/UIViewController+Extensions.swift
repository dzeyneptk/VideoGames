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
    
    func createCloseBarButtonItem() {
       let backButton = UIButton(type: .custom)
       backButton.setImage(UIImage(named: "icoClose"), for: .normal)
       backButton.tintColor = .white
       backButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
       backButton.addTarget(self, action: #selector(navCloseButtonTapped), for: .touchUpInside)
       let backNavBar = UIBarButtonItem(customView: backButton)
       self.navigationItem.leftBarButtonItem = backNavBar
   }
    @objc func navCloseButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
