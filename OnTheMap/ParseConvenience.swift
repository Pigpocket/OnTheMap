//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/21/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
    
    func getStudentLocations(limit: Int!, skip: Int?, order: String? = "updateAt", completionHandlerForGetStudentLocations: @escaping (_ studentLocation: [StudentLocation]?, _ error: String?) -> Void) {
        
        taskForGetManyLocations(limit, skip, order) { (data, error) in
            
            // Guard that there is no error
            if let error = error {
                print(error)
                completionHandlerForGetStudentLocations(nil, "There was an error when trying to get student locations")
            } else {
                
                if let results = data?["results"] as? [[String:AnyObject]] {
                    
                    let studentLocations = StudentLocation.studentLocationsFromResults(results)
                    completionHandlerForGetStudentLocations(studentLocations, nil)
                } else {
                    completionHandlerForGetStudentLocations(nil, "Unable to get array of student locations")
                }
            }
        }
    }
    
    func getMyObjectID(uniqueKey: String, completionHandlerForGetStudentLocation: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let parameters = [ParseClient.Constants.WhereQuery: uniqueKey as AnyObject]
        
        taskForGetStudentLocation(ParseClient.Methods.Location, parameters: parameters) { (results, error) in
            
            // Guard that there is no error
            if let error = error {
                print(error)
                completionHandlerForGetStudentLocation(false, "There was an error when trying to get the student location")
            } else {
                
                if let results = results?["results"] as? [[String:AnyObject]] {
                    
                    // Get my location dictionary
                    let myLocation = results[results.count - 1]
                    print("This is myLocation: \(myLocation)")
                    
                    // GUARD: Get my objectId
                    guard let objectId = myLocation["objectId"] as? String else {
                        print("Couldn't get objectId")
                        completionHandlerForGetStudentLocation(false, "Couldn't find key objectId in \(results)")
                        return
                    }
                    
                    // GUARD: Get my first name
                    guard let firstName = myLocation["firstName"] as? String else {
                        print("Couldn't get first name")
                        completionHandlerForGetStudentLocation(false, "Couldn't get first name in \(results)")
                        return
                    }
                    
                    // GUARD: Get my last name
                    guard let lastName = myLocation["lastName"] as? String else {
                        print("Couldn't get last name")
                        completionHandlerForGetStudentLocation(false, "Couldn't get last name in \(results)")
                        return
                    }
                    
                    // GUARD: Get my unique key
                    guard let uniqueKey = myLocation["uniqueKey"] as? String else {
                        print ("Couldn't get unique key")
                        completionHandlerForGetStudentLocation(false, "Couldn't get unique key in \(results)")
                        return
                    }
                    
                    // GUARD: Get my userId???
                    
                    // Assign values to user struct
                    user.objectId = objectId
                    print("This is my objectId: \(objectId)")
                    
                    user.firstName = firstName
                    print("This is my first name: \(firstName)")
                    
                    user.lastName = lastName
                    print("This is my last name: \(lastName)")
                    
                    user.uniqueKey = uniqueKey
                    print("This is my unique key: \(uniqueKey)")
                    
                    completionHandlerForGetStudentLocation(true, nil)
                    
                } else {
                    
                    completionHandlerForGetStudentLocation(false, "Unable to get array of student locations")
                }
            }
        }
    }
    /*
    func putStudentLocation(objectId: String?, completionHandlerForPut: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        taskForPutStudentLocation(objectId: objectId) { (results, error) in
        
            if let error = error {
                print(error)
                completionHandlerForPut(false, "There was an error when trying to change the student location")
            } else {
                
                if let results = results?["results"] as? [[String:AnyObject]] {
                    
                    // Get updatedAt
                    guard let updatedAt = results["updatedAt"] as? String else {
                        print("Couldn't get updatedAt")
                        completionHandlerForPut(false, "Couldn't find key objectId in \(results)")
                        return
                    }
                    
                    // Assign objectId to user struct
                    user.objectId = objectId
                    print("This is my objectId: \(objectId)")
                    completionHandlerForGetStudentLocation(true, nil)
                } else {
                    completionHandlerForGetStudentLocation(false, "Unable to get array of student locations")
                }
            }
        }
    }
 */
    
    /*func postStudentLocation(name: String, mediaURL: String, completionHandlerForPostStudentLocation: @escaping (_ studentLocation: StudentLocation?, _ error: String?) -> Void) {
        
        taskForPostStudentLocation(name: name, mediaURL: mediaURL) { (data, error) in
            
            // Guard that there is no error
            if let error = error {
                print(error)
                completionHandlerForPostStudentLocation(nil, "There was an error when trying to post location")
            } else {
                
                if let results = data?["results"] as? [[String:AnyObject]] {
                    
                    let studentLocations = StudentLocation.studentLocationsFromResults(results)
                    
                    for student in studentLocations {
                        if name = results["firstName"] as? String {
                            
                        }
                    }
                    completionHandlerForPostStudentLocation(student, nil)
                } else {
                    completionHandlerForPostStudentLocation(nil, "Unable to get array of student locations")
                }
            }
        }
    } */
}

