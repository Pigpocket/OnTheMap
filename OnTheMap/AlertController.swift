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
}
    
    class ViewController: UIViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            AlertView.showAlert(view: self, message: "Test alert")
            // Do any additional setup after loading the view, typically from a nib.
        }
}
