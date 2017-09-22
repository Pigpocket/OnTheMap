//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/12/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    
    func authenticateUser (email:String, password:String, completionHandlerForAuthenticateUser: @escaping (_ data: AnyObject?, _ error:String?) -> Void) {
    
        // MARK: TODO - if necessary, prep for calling taskForPOSTSession
        
        if email == "" && password == "" {
        
        }
        
        // MARK: TODO - call taskForPOSTSession
        taskForPOSTSession(email: email, password: password) { (data, error) in
           
            // OVERARCING GUIDELINES
            // call completionHandlerForAuthenticateUser (true, "") if everything is successful
            // call completionHandlerForAuthenticateUser (false, "{any appropriate error string}") in each of the fail points
            
            // guard that error != nil
            
            if let error = error {
                print(error)
                completionHandlerForAuthenticateUser(nil, "There was an error when trying to authenticate")
            } else {
                if let parsedData = data {
                    completionHandlerForAuthenticateUser(data, nil)
                    print(parsedData)
                }
                
                // guard that you can parse data -> parsedData
                
                guard let data = data else {
                    print("Data is not available")
                    return
                }
                
                // substring the parsedData -> newData -- Tomás: didn't I already do this in taskForPostSession???
                
                // guard that "account" is in newData
                
                if let account = data[UdacityResponseKeys.Account] as? [String:AnyObject] {
                    print("account dictionary was extracted from parsedResults")
                    
                    // extract account key -> udacityID -- store in UdacityCient
                    
                    if let accountKey = account[UdacityResponseKeys.AccountKey] as? String? {
                        print("accountKey was extracted from account")
                        self.accountKey = accountKey
                    } else {
                        let userInfo = [NSLocalizedDescriptionKey: "Could not get accountKey from \(UdacityClient.UdacityResponseKeys.Account)"]
                        NSError(domain: "account", code: 0, userInfo: userInfo)
                    }
                }
                
                // guard that "session" is in newData
                
                if let session = data[UdacityClient.UdacityResponseKeys.Session] as? [String:AnyObject] {
                    print("Able to extract session dictionary")
                    
                    // extracion session id -> udacitySessionID -- store in UdacityClient
                    
                    if let sessionID = session[UdacityClient.UdacityResponseKeys.SessionID] as? String? {
                        print("Able to extract sessionID")
                        self.sessionID = sessionID
                    } else {
                        let userInfo = [NSLocalizedDescriptionKey: "Could not get the sessionID from \(UdacityClient.UdacityResponseKeys.Session)"]
                        NSError(domain: "sessionID", code: 1, userInfo: userInfo)
                    }
                }
            }
        }
    }
    
    func postSessionID(username: String, password: String, completionHandler: @escaping (_ results: String?, _ error: NSError?) -> Void) {
    print("postSessionID is being called")
        
        authenticateUser(email: username, password: password) { (success, error) in
            
            print("taskForPostMethod is being called")
            
            guard error == nil else {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error"]
                completionHandler(nil, NSError(domain: "postSessionID", code: 0, userInfo: userInfo))
                return
            }

            }
        }

        /* 6. Use the data! */

}

