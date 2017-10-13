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
                    //self.accountKey = accountKey
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
            
            
            
            //get public data
            // firstname and lastname -> Udacity API
        }
    }
    
    func getUdacityPublicUserData(uniqueKey: String, completionHandlerForGetPublicUserData: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        taskForGETPublicUserData(method: Method.Users, uniqueKey: uniqueKey) { (data, error) in
            
            // Check for an error
            if let error = error {
                print(error)
                completionHandlerForGetPublicUserData(false, "There was an error getting public user data")
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
                User.shared.firstName = firstName
                print("firstName = \(firstName)")
                User.shared.lastName = lastName
                print("lastName = \(lastName)")
                User.shared.uniqueKey = key
                self.accountKey = key
                print("userId = \(key)")
                
                completionHandlerForGetPublicUserData(true, nil)
            }
        }
    }
    
    /*func deleteSession(session: String, completionHandlerForDelete: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        taskForDeleteSession(session: session) { (data, error) in
            
            // Check for an error
            if let error = error {
                print(error)
                completionHandlerForDelete(false, "There was an error deleting the session")
            }
            
            // GUARD: 
            guard let data = data as? [String:AnyObject] else {
                completionHandlerForDelete(false, "Could not retrieve the delete data")
                return
            }
            
            guard let id = data["id"] as? String else {
                completionHandlerForDelete(false, "Could not find key 'id'")
                return
            }
            
        }
    } */
}


