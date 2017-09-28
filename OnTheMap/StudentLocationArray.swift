//
//  StudentLocationArray.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/27/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class StudentLocationArray {
    
    class var sharedInstance: StudentLocationArray {
        
        struct Static {
            static var instance: StudentLocationArray = StudentLocationArray()
        }
        
        return Static.instance
    }
    
    var studentArray: [StudentLocation] = [StudentLocation]()
    
    static func locationsFromResults(_ results: [[String: AnyObject]]) -> [StudentLocation] {
        
        var studentLocations = [StudentLocation]()
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
    }
    
}
