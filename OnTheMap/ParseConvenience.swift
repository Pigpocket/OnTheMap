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
            JSONParameterKeys.skip: 4 as AnyObject,
            JSONParameterKeys.order: "-updatedAt" as AnyObject
        ]
        
        taskForGetManyLocations(method: Methods.Location, parameters: parameters) { (data, error) in
            
            // Guard that there is no error
            if let error = error {
                print(error)
                completionHandlerForGetStudentLocations(nil, "There was an error when trying to get student locations")
            } else {
                
                if let results = data?["results"] as? [[String:AnyObject]] {
                    
                    let studentLocations = StudentLocation.studentLocationsFromResults(results)
                    
                    completionHandlerForGetStudentLocations(studentLocations, nil)
                    print(studentLocations)
                } else {
                    completionHandlerForGetStudentLocations(nil, "Unable to get array of student locations")
                }
            }
        }
    }
    
    func getMyObjectID(uniqueKey: String, completionHandlerForGetStudentLocation: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let parameters = [ParseClient.Constants.WhereQuery: uniqueKey as AnyObject]
        
        print("The user's UniqueKey prior to taskForGetStudentLocation is :\(User.shared.uniqueKey)")
        
        //https://parse.udacity.com/parse/classes/StudentLocation?where={"uniqueKey":"1234"}
        
        taskForGetStudentLocation(method: ParseClient.Methods.Location, parameters: parameters) { (results, error) in
            
            // Guard that there is no error
            if let error = error {
                print(error)
                completionHandlerForGetStudentLocation(false, "There was an error when trying to get the student location")
            } else {
                
                if let results = results?["results"] as? [[String:AnyObject]] {
                    
                    let user = StudentLocation.studentLocationsFromResults(results)
                    print("\n ****This is the student location from studentLocationsFromResults: \n \(user)*** ")
                    
                    // Get my location dictionary
                    let myLocation = results[results.count - 1]
                    print("\n ***This is myLocation: \(myLocation)***")
                    
                    
                    // GUARD: Get my objectId
                    guard let objectId = myLocation["objectId"] as? String else {
                        print("Couldn't get objectId")
                        completionHandlerForGetStudentLocation(false, "Couldn't find key objectId in \(results)")
                        return
                    }
                    
                    // Assign values to user struct
                    User.shared.objectId = objectId
                    //User.shared.firstName = firstName
                    //User.shared.lastName = lastName
                    //User.shared.uniqueKey = uniqueKey
                    
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
        
            print("taskforPutStudentLocation is being called")
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
                
                // Get the createdAt date
                guard let updatedAt = results["updatedAt"] as? String else {
                    print("Couldn't get the createdAt date")
                    completionHandlerForPut(false, "Couldn't get the updatedAt date in results")
                    return
                }
                
                performUIUpdatesOnMain {
                    
                User.shared.updatedAt = updatedAt
                
                print(results)
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
                    
                    //print("The data for posting student locations looks like this: \(data)")
                    performUIUpdatesOnMain {
                        
                // Assign objectId and createdAt to student location struct
                User.shared.objectId = objectId
                User.shared.createdAt = createdAt
                    
                completionHandlerForPostStudentLocation(true, nil)
                }
            }
        }
    }
}
// **** UDACITY API  => UdacityStudent struct -> uniquekey, fname,lname and objectId

// Login _. UniqueKey
// First name and last name from UDacity server -> get GETting Public User Data

//
// *** taps on post location
// location // a location => logged in user => object Id
// finish
//First getObjectId -> POST and PUT working
//Flow -> userId before user location is posted / put


