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
    
    var session = URLSession.shared
    
    var studentLocation: [StudentLocation] = []
    
    func taskForGetManyLocations(_ limit: Int!, _ skip: Int?, _ order: String?, completionHandlerForGET: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) {
    
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=10")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
        
            /* GUARD: Was there an error */
            guard error == nil else {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error with your request: \(error)"]
                completionHandlerForGET(nil, NSError(domain: "taskForGetManyLocations", code: 0, userInfo: userInfo))
                return
            }
        
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: \(response.statusCode)!"]
                    completionHandlerForGET(nil, NSError(domain: "taskForGetManyLocations", code: 1, userInfo: userInfo))
                } else if let response = response {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: \(response)!"]
                    completionHandlerForGET(nil, NSError(domain: "taskForGetManyLocations", code: 2, userInfo: userInfo))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                    completionHandlerForGET(nil, NSError(domain: "taskForGetManyLocations", code: 3, userInfo: userInfo))
                }
                return
            }
        
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request!"]
                completionHandlerForGET(nil, NSError(domain: "taskForGetStudentLocation", code: 1, userInfo: userInfo))
                return
            }
        
            //print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
        
            /* Parse the data */
        
            self.parseJSONObject(data, completionHandlerForConvertData: completionHandlerForGET)
        
        }
    
        task.resume()
    }
    
    func taskForPostStudentLocation(name: String, mediaURL: String, completionHandlerForPOST: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Stinky\", \"lastName\": \"Pete\",\"mapString\": \"Palm Desert, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            /* GUARD: Was there an error */
            guard error == nil else {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error with your request: \(error)"]
                completionHandlerForPOST(nil, NSError(domain: "taskForGetPostStudentLocation", code: 0, userInfo: userInfo))
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? HTTPURLResponse {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: \(response.statusCode)!"]
                    completionHandlerForPOST(nil, NSError(domain: "taskForGetPostStudentLocation", code: 1, userInfo: userInfo))
                } else if let response = response {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: \(response)!"]
                    completionHandlerForPOST(nil, NSError(domain: "taskForGetPostStudentLocation", code: 2, userInfo: userInfo))
                } else {
                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                    completionHandlerForPOST(nil, NSError(domain: "taskForGetPostStudentLocation", code: 3, userInfo: userInfo))
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request!"]
                completionHandlerForPOST(nil, NSError(domain: "taskForGetPostStudentLocation", code: 1, userInfo: userInfo))
                return
            }
            
            self.parseJSONObject(data, completionHandlerForConvertData: completionHandlerForPOST)
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
    
    func parseJSONObject(_ data: Data, completionHandlerForConvertData: (_ results: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: \(data)"]
            completionHandlerForConvertData(nil, NSError(domain: "parseJSONObject", code: 0, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }

    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
