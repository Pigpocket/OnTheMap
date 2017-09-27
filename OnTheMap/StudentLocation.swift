//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/21/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

struct StudentLocation {
    
    // MARK: Properties
    
    var objectID = ""
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    var mapString = ""
    var mediaURL = ""
    var latitude = 0.0
    var longitude = 0.0
    
    // construct a StudentLocation from a dictionary
    init(dictionary: [String:AnyObject]) {
        
        if let objectID = dictionary["objectId"] as? String {
            self.objectID = objectID
        }
        if let uniqueKey = dictionary["uniqueKey"] as? String {
            self.uniqueKey = uniqueKey
        }
        if let firstName = dictionary["firstName"] as? String {
            self.firstName = firstName
        }
        if let lastName = dictionary["lastName"] as? String {
            self.lastName = lastName
        }
        if let mapString = dictionary["mapString"] as? String {
            self.mapString = mapString
        }
        if let mediaURL = dictionary["mediaURL"] as? String {
            self.mediaURL = mediaURL
        }
        if let latitude = dictionary["latitude"] as? Double {
            self.latitude = latitude
        }
        if let longitude = dictionary["longitude"] as? Double {
            self.longitude = longitude
        }
    }
    
    static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var studentLocations = [StudentLocation]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
    }
}
