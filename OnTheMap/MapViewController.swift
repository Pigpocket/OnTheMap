//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/8/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class MapViewController: UIViewController {
    
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("The MapViewController was deinitialized")
    }
}
