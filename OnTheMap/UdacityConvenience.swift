//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/12/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    
    func authenticateUser (email:String, password:String, completionHandlerForAuthenticateUser: @escaping (_ success: Bool, _ error:String?) -> Void) {
        
        // MARK: TODO - call taskForPOSTSession
        taskForPOSTSession(email: email, password: password) { (data, error) in
            
            // Guard that there is no error
            if let error = error {
                print(error)
                completionHandlerForAuthenticateUser(false, "Wrong username or password")
            } else {
            guard let data = data else {
                print(error!)
                completionHandlerForAuthenticateUser(false, "Could not get data")
                return
            }
                
            // Guard that "account" is in newData
            if let account = data[UdacityResponseKeys.Account] as? [String:AnyObject] {
                    
                // Extract account key and store in UdacityClient
                if let accountKey = account[UdacityResponseKeys.AccountKey] as? String? {
                    self.accountKey = accountKey
                } else {
                    completionHandlerForAuthenticateUser(false, "Unable to extract account key")
                }
            }
                
            // Guard that "session" is in newData
            if let session = data[UdacityClient.UdacityResponseKeys.Session] as? [String:AnyObject] {
                    
                // Extract session id and store in UdacityClient
                if let sessionID = session[UdacityClient.UdacityResponseKeys.SessionID] as? String? {
                    self.sessionID = sessionID
                    completionHandlerForAuthenticateUser(true, nil)
                } else {
                    completionHandlerForAuthenticateUser(false, "There ain't no session ID, pal")
                    }
                }
            }
        }
    }
}

