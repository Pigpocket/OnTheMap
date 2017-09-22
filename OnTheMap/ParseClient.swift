//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/21/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class ParseClient: NSObject {
    
    
    func taskForGetStudentLocations(limit: Int, skip: Int, order: String, completionHandlerForGET: @escaping (_ results: AnyObject?, NSError?) -> Void) {
    
    let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        if error != nil { // Handle error...
            return
        }
        print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
    }
    task.resume()
}

}
