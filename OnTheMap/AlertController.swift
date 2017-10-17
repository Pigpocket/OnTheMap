//
//  AlertController.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 10/13/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class AlertView: NSObject {
    
    
    
    class func showAlert(view: UIViewController , message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
        performUIUpdatesOnMain {
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    static func startActivityIndicator(_ view: UIView) {
        
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.center = view.center
        //activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityIndicator)
        
        print("/n *******startActivity running*****")
        
        //activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    static func stopActivityIndicator(_ view: UIView) {
        
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
}
    
    class ViewController: UIViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            AlertView.showAlert(view: self, message: "Test alert")
            // Do any additional setup after loading the view, typically from a nib.
        }
}
