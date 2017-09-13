//
//  UdacityClient2.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/12/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient: NSObject {
    
    var session = URLSession.shared
    
    func taskForPostSessionID() {
        
        // Set the parameters
        let loginViewController = LoginViewController()
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("\n{\"udacity\": {\"username\": \"\(loginViewController.usernameTextField.text!)\", \"password\": \"\(loginViewController.passwordTextField.text!)\"}}\n")
        request.httpBody = "{\"udacity\": {\"username\": \"\(loginViewController.usernameTextField.text!)\", \"password\": \"\(loginViewController.passwordTextField.text!)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String, debugLabelText: String? = nil) {
                print(error)
                performUIUpdatesOnMain {
                    //self.setUIEnabled(true)
                    //self.debugTextLabel.text = "Login Failed (Login Step)."
                }
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error!)")
                //self.connectionFailureAlert()
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                //self.connectionFailureAlert()
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            /* 5. Parse the data */
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            guard let session = parsedResult![UdacityClient.UdacityResponseKeys.Session] as? [String:AnyObject] else {
                displayError("Cannot find session dictionary in '\(parsedResult)'")
                return
            }
            
            guard let sessionID = session[UdacityClient.UdacityResponseKeys.SessionID] as? String else {
                displayError("Cannot find key '\(UdacityClient.UdacityResponseKeys.SessionID)' in '\(session)'")
                return
            }
            
            guard let account = parsedResult![UdacityClient.UdacityResponseKeys.Account] as? [String:AnyObject] else {
                displayError("Cannot find account dictionary in '\(parsedResult)'")
                return
            }
            
            guard let accountKey = account[UdacityClient.UdacityResponseKeys.AccountKey] as? String else {
                displayError("Cannot find key '\(UdacityClient.UdacityResponseKeys.AccountKey)' in '\(account)'")
                return
            }
            
            /* 6. Use the data! */
            print(accountKey)
            print(sessionID)
        }
        
        task.resume()
    }
    
    deinit {
        print("The LoginViewController was deinitialized")
    }

func sharedInstance() -> UdacityClient {
    struct Singleton {
        static var sharedInstance = UdacityClient()
    }
    return Singleton.sharedInstance
}
}
