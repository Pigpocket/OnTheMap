//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/10/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Functions
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        
        // guard that username AND passowrd is != ""
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.connectionFailureAlert("Username or password field empty")
        } else {
            UdacityClient.sharedInstance().authenticateUser(email: usernameTextField.text!, password: passwordTextField.text!) { (success, error) in
                
                if success == true {
                    self.completeLogin()
                } else {
                    OperationQueue.main.addOperation {
                    self.connectionFailureAlert(error!)
                    }
                }
            }
        }

        //ParseClient.sharedInstance().getStudentLocations(limit: 5, skip: 10, order: "") { (studentLocation, error) in

        

    }
    
    func completeLogin() {
        performUIUpdatesOnMain {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func connectionFailureAlert(_ error: String) {
        let alertController = UIAlertController(title: "Login Error", message: error, preferredStyle: .alert)
        let networkFailureNotice = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(networkFailureNotice)
        present(alertController, animated: true, completion: nil)
    }
 
    deinit {
        print("The LoginViewController was deinitialized")
    }
}

extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
    }
}
