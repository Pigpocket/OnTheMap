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
    
    func getStudentLocations(completionHandlerForGetStudentLocations: @escaping (_ studentLocation: [StudentLocation]?, _ error: String?) -> Void) {
        
        let parameters: [String:AnyObject] = [
            JSONParameterKeys.limit: 100 as AnyObject,
            JSONParameterKeys.order: "-updatedAt" as AnyObject
        ]
        
        taskForGetManyLocations(method: Methods.Location, parameters: parameters) { (data, error) in
            
            // Check that there is no error
            if let error = error {
                completionHandlerForGetStudentLocations(nil, "There was an error when trying to get student locations: \(error)")
            } else {
                
                // Create a dictionary of student locations from the data
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
        
        taskForGetStudentLocation(method: ParseClient.Methods.Location, parameters: parameters) { (results, error) in
            
            // Check that there is no error
            if let error = error {
                completionHandlerForGetStudentLocation(false, "There was an error when trying to get the student location: \(error)")
            } else {
                
                // Get the data
                if let results = results?["results"] as? [[String:AnyObject]] {
                    
                    // Get my location dictionary
                    let myLocation = results[results.count - 1]
                    
                    // GUARD: Get my objectId
                    guard let objectId = myLocation["objectId"] as? String else {
                        print("Couldn't get objectId")
                        completionHandlerForGetStudentLocation(false, "Couldn't find key objectId in \(results)")
                        return
                    }
                    
                    // Assign values to user struct
                    User.shared.objectId = objectId
                    
                    completionHandlerForGetStudentLocation(true, nil)
                    
                } else {
                    completionHandlerForGetStudentLocation(false, "Unable to get array of student locations")
                }
            }
        }
    }
    
    func putStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completionHandlerForPut: @escaping (_ success: Bool, _ error: String?) -> Void) {
            
        let jsonBody: [String: AnyObject] = [
            JSONBodyKeys.uniqueKey: uniqueKey as AnyObject,
            JSONBodyKeys.firstName: firstName as AnyObject,
            JSONBodyKeys.lastName: lastName as AnyObject,
            JSONBodyKeys.mediaURL: mediaUrl as AnyObject,
            JSONBodyKeys.mapString: mapString as AnyObject,
            JSONBodyKeys.latitude: latitude as AnyObject,
            JSONBodyKeys.longitude: longitude as AnyObject
        ]
        
        taskForPutStudentLocation(objectId: User.shared.objectId, method: ParseClient.Methods.LocationSlash, jsonBody: jsonBody) { (results, error) in
   
            // Check that there is no error
            if let error = error {
                completionHandlerForPut(false, "There was an error when trying to put the new student location: \(error)")
            } else {
                
                // Confirm the results exist
                guard let results = results as? [String:AnyObject] else {
                    completionHandlerForPut(false, "Could not find the results in taskForPutStudentLocation")
                    return
                }
                
                // Get the createdAt date
                guard let updatedAt = results["updatedAt"] as? String else {
                    completionHandlerForPut(false, "Couldn't get the updatedAt date in results")
                    return
                }
                
                performUIUpdatesOnMain {
                
                // Assign values to user struct
                User.shared.updatedAt = updatedAt
                
                completionHandlerForPut(true, nil)
                }
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
                completionHandlerForPostStudentLocation(false, "There was an error when trying to post location: \(error)")
            } else {
                    
                // GUARD: Confirm the data exists
                guard let data = data as? [String:AnyObject] else {
                    completionHandlerForPostStudentLocation(false, "Couldn't find the data in taskForPostStudentLocation")
                    return
                }
                
                // Get the createdAt date
                guard let createdAt = data["createdAt"] as? String else {
                    completionHandlerForPostStudentLocation(false, "Couldn't find the createdAt date in results")
                    return
                }
                
                // Get the objectId
                guard let objectId = data["objectId"] as? String else {
                    completionHandlerForPostStudentLocation(false, "Couldn't find the objectId in results")
                    return
                }
                
                performUIUpdatesOnMain {
                        
                // Assign objectId and createdAt to user struct
                User.shared.objectId = objectId
                User.shared.createdAt = createdAt
                    
                completionHandlerForPostStudentLocation(true, nil)
                }
            }
        }
    }
}
