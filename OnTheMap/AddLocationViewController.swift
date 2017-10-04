//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/28/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class AddLocationViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        
        
    }
    
    // MARK: Actions
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationPressed(_ sender: Any) {
        
        
        ParseClient.sharedInstance().getMyObjectID { (success, error) in
            print("This function is being called")
            if let error = error {
                print(error)
            } else {
                if success == true {
                print("Successfully completed getMyObjectID")
                }
            }
        }
        
        ParseClient.sharedInstance().taskForPostStudentLocation(name: locationTextField.text!, mediaURL: websiteTextField.text!) { (studentLocation, error) in
            if let error = error {
                print(error)
            } else {
                if let studentLocation = studentLocation {
                    print("student location is \(studentLocation)")
                }
            }
        }
        
        ParseClient.sharedInstance().taskForPutStudentLocation(objectId: "AgaDXQdRtt") { (results, error) in
            if let error = error {
                print(error)
            } else {
                print("Put function executed successfully")
            }
        }
        
        // Present the ConfirmLocationViewController
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmLocationViewController") as! ConfirmLocationViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    deinit {
        print("The AddLocationViewController was dismissed")
    }
    
}
