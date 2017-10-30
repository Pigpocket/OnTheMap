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
    
    // MARK: Properties
    
    var activityIndicator = UIActivityIndicatorView()
    
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
        
        setUIEnabled(false)
        
        // GUARD: Confirm that username AND passowrd is != ""
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            
            // Notify the user
            AlertView.showAlert(view: self, message: "Username or password field empty")
        
        } else {
            
            AlertView.startActivityIndicator(self.view, activityIndicator: self.activityIndicator)
            
            // Authenticate the user
            UdacityClient.sharedInstance().authenticateUser(email: self.usernameTextField.text!, password: self.passwordTextField.text!, completionHandlerForAuthenticateUser: { (success, errorString) in
                
                // Check for error
                if let errorString = errorString {
                    
                    performUIUpdatesOnMain {
                    
                        AlertView.stopActivityController(self.view, activityIndicator: self.activityIndicator)
                        AlertView.showAlert(view: self, message: errorString)
                        self.setUIEnabled(true)
                        return
                    }
                }
                
                // If authentication is unsuccessful...
                if success {
                    
                    // Get the Udacity Public User Data
                    UdacityClient.sharedInstance().getUdacityPublicUserData(uniqueKey: User.shared.uniqueKey, completionHandlerForGetPublicUserData: { (success, errorString) in
                        
                        performUIUpdatesOnMain {
                            
                            // Check for error
                            if let errorString = errorString {
                            
                                AlertView.stopActivityController(self.view, activityIndicator: self.activityIndicator)
                                AlertView.showAlert(view: self, message: errorString)
                                self.setUIEnabled(true)
                                return
                                }
                        
                            // If sucessful in getting Udacity Public Data...
                            if success {
                                
                                // Log in
                                AlertView.stopActivityController(self.view, activityIndicator: self.activityIndicator)
                                self.completeLogin()
                            
                            // If unable to get Udacity Public Data...
                            } else {
                                
                                // Notify the user and log in
                                AlertView.stopActivityController(self.view, activityIndicator: self.activityIndicator)
                                AlertView.showAlert(view: self, message: "Unable to get public user data")
                                self.completeLogin()
                            }
                        }
                    })
                
                // If unable to authenticate...
                } else {
                            
                    performUIUpdatesOnMain {
                    
                        // Notify the user
                        AlertView.stopActivityController(self.view, activityIndicator: self.activityIndicator)
                        AlertView.showAlert(view: self, message: "Username or password incorrect")
                    }
                }
            })
        }
        self.setUIEnabled(true)
    }

    func completeLogin() {
        performUIUpdatesOnMain {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
    }
}

extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
    }
}
