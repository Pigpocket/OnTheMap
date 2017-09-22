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
    
    func getStudentLocations(_ limit: Int? = 100, _ skip: Int? = 4, _ order: String? = "updateAt", completionHandlerForGetStudentLocations: @escaping (_ results: AnyObject?, _ studentLocation: StudentLocation?, _ error: String?) -> Void) {
        
        taskForGetManyLocations(limit: limit, skip: skip, order: order) { (data, error) in
            
            // Guard that there is no error
            if let error = error {
                print(error)
                completionHandlerForGetStudentLocations(nil, nil, "There was an error when trying to authenticate")
            } else {
                if let parsedData = data {
                    completionHandlerForGetStudentLocations(data, nil, nil)
                }
                
                // Guard that you can parse data -> parsedData
                guard let data = data else {
                    print("Data is not available")
                    return
                }
                
                // Loop through the results
                
                // Guard that "account" is in data
                if let results = data["results"] as? [[String:AnyObject]] {
                    
                    for result in results {
                        print("---STUDENT LOCATION---")
                        
                        if let objectID = result["objectId"] as! String? {
                            print("ObjectId: \(objectID)")
                        } else {
                            print("***DEF DIDN'T GET THE OBJECTID")
                        }
                        
                        if let firstName = result["firstName"] as! String? {
                            print("firstName: \(firstName)")
                        } else {
                            print("***DIDN'T GET THAT FIRST NAME, BROHAMOVICH")
                        }
                        
                        if let lastName = result["lastName"] as! String? {
                            print("lastName: \(lastName)")
                        } else {
                            print("***DIDN'T GET THAT LAST NAME, BROHAMOVICH")
                        }
                        
                        if let mapString = result["mapString"] as! String? {
                            print("mapString: \(mapString)")
                        } else {
                            print("***DIDN'T GET THAT MAPSTRING, BROHAMOVICH")
                        }
                        
                        if let mediaURL = result["mediaURL"] as! String? {
                            print("mediaURL: \(mediaURL)")
                        } else {
                            print("***DIDN'T GET THAT MEDIAURL, BROHAMOVICH")
                        }
                        
                        if let latitude = result["latitude"] as! Double? {
                            print("latitude: \(latitude)")
                        } else {
                            print("***DIDN'T GET THAT LATITUDE, BROHAMOVICH")
                        }
                        
                        if let longitude = result["longitude"] as! Double? {
                            print("longitude: \(longitude)")
                        } else {
                            print("***DIDN'T GET THAT LONGITUDE, BROHAMOVICH")
                        }
                        
                        
                    }
                }
            }
        }
    }
}

