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
                completionHandlerForGetStudentLocations(nil, "There was an error when trying to authenticate")
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
    
    /*func postStudentLocation(name: String, mediaURL: String, completionHandlerForPostStudentLocation: @escaping (_ studentLocation: StudentLocation?, _ error: String?) -> Void) {
        
        taskForPostStudentLocation(name: name, mediaURL: mediaURL) { (data, error) in
            
            // Guard that there is no error
            if let error = error {
                print(error)
                completionHandlerForPostStudentLocation(nil, "There was an error when trying to post location")
            } else {
                
                if let results = data?["results"] as? [[String:AnyObject]] {
                    
                    let studentLocation = StudentLocation.studentLocationsFromResults(results)
                    completionHandlerForPostStudentLocation(studentLocation, nil)
                } else {
                    completionHandlerForPostStudentLocation(nil, "Unable to get array of student locations")
                }
            }
        }
    } */
}

