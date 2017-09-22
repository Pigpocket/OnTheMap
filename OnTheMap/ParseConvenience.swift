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
                    print("This is the \(parsedData)")
                }
                
                // Guard that you can parse data -> parsedData
                guard let data = data else {
                    print("Data is not available")
                    return
                }
                
                // Loop through the results
                
                // Guard that "account" is in data
                if let results = data["results"] as? [[String:AnyObject]] {
                    print("***OBJECTID \(results) was extracted from parsedResults***")
                    
                    for result in results {
                        print("EL FUEGO")
                        if let objectID = result["objectId"] as! String? {
                            print("***TOTALLY SUCCESSFULLY GOT THE OBJECTID AND IT'S \(objectID)")
                        } else {
                            print("***DEF DIDN'T GET THE OBJECTID")
                        }
                    }
                }
            }
        }
    }
}

