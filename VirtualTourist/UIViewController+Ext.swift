//
//  UIViewController+Ext.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 7/26/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import UIKit

extension UIViewController{
    // this is a custom UIAlertController for convenience and readability
    func presentVTAlert(title:String, message: String){
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                alertViewController.dismiss(animated: true)
            }
            alertViewController.addAction(okAction)
            self.present(alertViewController, animated: true)
        }
    }
    
}
