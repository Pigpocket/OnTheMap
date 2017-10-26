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
            
            // Check that there is no error
            if let error = error {
                completionHandlerForAuthenticateUser(false, "Wrong username or password: \(error)")
            } else {
                
            // GUARD: Does the data exist?
            guard let data = data else {
                completionHandlerForAuthenticateUser(false, "Could not get data: \(error)")
                return
            }
                
            // Check that "account" is in newData
            if let account = data[UdacityResponseKeys.Account] as? [String:AnyObject] {
                    
                // Extract account key and store in UdacityClient
                if let accountKey = account[UdacityResponseKeys.AccountKey] as? String? {
                    
                    // Assign value to user struct
                    User.shared.uniqueKey = accountKey!
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
    
    func getUdacityPublicUserData(uniqueKey: String, completionHandlerForGetPublicUserData: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        taskForGETPublicUserData(method: Method.Users, uniqueKey: uniqueKey) { (data, error) in
            
            // Check for an error
            if let error = error {
                completionHandlerForGetPublicUserData(false, "There was an error getting public user data: \(error)")
            }
            
            // GUARD: Check data exists
            guard let data = data!["user"] as? [String:AnyObject] else {
                completionHandlerForGetPublicUserData(false, "Could not retrieve the public user data")
                return
            }
            
            // GUARD: The first name exists
            guard let firstName = data["first_name"] as? String else {
                completionHandlerForGetPublicUserData(false, "Could not find key 'firstName'")
                return
            }
            
            // GUARD: The last name exists
            guard let lastName = data["last_name"] as? String else {
                completionHandlerForGetPublicUserData(false, "Could not find key 'lastName'")
                return
            }
            
            // GUARD: The object ID exists
            guard let key = data["key"] as? String else {
                completionHandlerForGetPublicUserData(false, "Could not find key")
                return
            }
            
            performUIUpdatesOnMain {
                
                // Assign values to user struct
                User.shared.firstName = firstName
                User.shared.lastName = lastName
                User.shared.uniqueKey = key
                
                completionHandlerForGetPublicUserData(true, nil)
            }
        }
    }
}


