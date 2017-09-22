//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/12/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    
    func authenticateUser (email:String, password:String, completionHandlerForAuthenticateUser: @escaping (_ data: AnyObject?, _ sessionID: String?, _ error:String?) -> Void) {
    
        // MARK: TODO - if necessary, prep for calling taskForPOSTSession
        
        if email == "" && password == "" {
        
        }
        
        // MARK: TODO - call taskForPOSTSession
        taskForPOSTSession(email: email, password: password) { (data, error) in
            
            // Guard that there is no error
            if let error = error {
                print(error)
                completionHandlerForAuthenticateUser(nil, nil, "There was an error when trying to authenticate")
            } else {
                if let parsedData = data {
                    completionHandlerForAuthenticateUser(data, nil, nil)
                }
                
            // Guard that you can parse data -> parsedData
            guard let data = data else {
                print("Data is not available")
                return
            }
                
            // Guard that "account" is in newData
            if let account = data[UdacityResponseKeys.Account] as? [String:AnyObject] {
                print("account dictionary was extracted from parsedResults")
                    
                // Extract account key and store in UdacityClient
                if let accountKey = account[UdacityResponseKeys.AccountKey] as? String? {
                    print("accountKey was extracted from account")
                    self.accountKey = accountKey
                } else {
                    completionHandlerForAuthenticateUser(nil, nil, "Unable to extract account key")
                }
            }
                
            // Guard that "session" is in newData
            if let session = data[UdacityClient.UdacityResponseKeys.Session] as? [String:AnyObject] {
                print("Able to extract session dictionary")
                    
                // Extract session id and store in UdacityClient
                if let sessionID = session[UdacityClient.UdacityResponseKeys.SessionID] as? String? {
                    print("Able to extract sessionID")
                    self.sessionID = sessionID
                    completionHandlerForAuthenticateUser(data, sessionID, nil)
                } else {
                    completionHandlerForAuthenticateUser(nil, nil, "There ain't no session ID, pal")
                    }
                }
            }
        }
    }
}

