//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/21/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit
import MapKit

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
    
    func putStudentLocation(objectId: String?, method: String, firstName: String, lastName: String, mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completionHandlerForPut: @escaping (_ success: Bool, _ error: String?) -> Void) {
            
        let jsonBody: [String: AnyObject] = [
            JSONBodyKeys.firstName: firstName as AnyObject,
            JSONBodyKeys.lastName: lastName as AnyObject,
            JSONBodyKeys.mapString: mapString as AnyObject,
            JSONBodyKeys.mediaURL: mediaUrl as AnyObject,
            JSONBodyKeys.latitude: latitude as AnyObject,
            JSONBodyKeys.longitude: longitude as AnyObject
        ]
        
        taskForPutStudentLocation(objectId: objectId, method: method, jsonBody: jsonBody) { (results, error) in
        
            // Check that there is no error
            if let error = error {
                print(error)
                completionHandlerForPut(false, "There was an error when trying to put the new student location")
            } else {
                
                // Confirm the results exist
                guard let results = results as? [String:AnyObject] else {
                    print("Couldn't get the results")
                    completionHandlerForPut(false, "Could not find the results in taskForPutStudentLocation")
                    return
                }
                
                // Confirm the objectId exists
                guard let objectId = results["objectId"] as? String else {
                    print("Couldn't get the objectId")
                    completionHandlerForPut(false, "Could not find the objectId in \(results)")
                    return
                }
                    
                // Assign objectId to user struct
                user.objectId = objectId
                print("This is my objectId, created in the putStudentLocation function: \(objectId)")
                completionHandlerForPut(true, nil)
            }
        }
    }
    
    func postStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandlerForPostStudentLocation: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let jsonBody: [String:AnyObject] = [
            JSONBodyKeys.firstName: firstName as AnyObject,
            JSONBodyKeys.lastName: lastName as AnyObject,
            JSONBodyKeys.mapString: mapString as AnyObject,
            JSONBodyKeys.mediaURL: mediaURL as AnyObject,
            JSONBodyKeys.latitude: latitude as AnyObject,
            JSONBodyKeys.longitude: longitude as AnyObject
        ]
        
        taskForPostStudentLocation(method: ParseClient.Methods.Location, jsonBody: jsonBody) { (data, error) in
            
            // Check that there is no error
         	   if let error = error {
                print(error)
                completionHandlerForPostStudentLocation(false, "There was an error when trying to post location")
            } else {
                    
                // GUARD: Confirm the data exists
                guard let data = data as? [String:AnyObject] else {
                    print("The data did not exist")
                    completionHandlerForPostStudentLocation(false, "Couldn't find the data in taskForPostStudentLocation")
                    return
                }
                
                // Get the createdAt date
                guard let createdAt = data["createdAt"] as? String else {
                    completionHandlerForPostStudentLocation(false, "Couldn't find the createdAt key: \(error)")
                    return
                }
                
                // Get the objectId
                guard let objectId = data["objectId"] as? String else {
                    completionHandlerForPostStudentLocation(false, "Couldn't find the objectId: \(error)")
                    return
                }
                
                // Assign objectId and createdAt to student location struct
                user.objectId = objectId
                user.createdAt = createdAt
            }
            
            completionHandlerForPostStudentLocation(true, nil)
        }
    }
}


