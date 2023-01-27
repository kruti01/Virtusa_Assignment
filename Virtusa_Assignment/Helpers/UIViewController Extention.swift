//
//  UIViewController Extention.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 26/01/23.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlertWith(title:String,message:String)
    {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }

    func showActivityIndicator(withActivityView view: UIActivityIndicatorView) {
//        activityView = UIActivityIndicatorView(style: .large)
        view.center = self.view.center
        self.view.addSubview(view)
        view.startAnimating()
    }

    func hideActivityIndicator(activityView: UIActivityIndicatorView){
            DispatchQueue.main.async {
                activityView.stopAnimating()
            }
    }
}
