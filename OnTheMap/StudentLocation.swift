//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/21/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

struct StudentLocation {
    
    // MARK: Properties
    
    var createdAt = ""
    var updatedAt = ""
    var objectID = ""
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    var mapString = ""
    var mediaURL = ""
    var latitude = 0.0
    var longitude = 0.0
    
    // construct a StudentLocation from a dictionary
    init?(dictionary: [String:AnyObject]) {
        
        // GUARD: Do all dictionary keys have values?
        guard
            let createdAt = dictionary["createdAt"] as? String,
            let objectID = dictionary["objectId"] as? String,
            let uniqueKey = dictionary["uniqueKey"] as? String,
            let firstName = dictionary["firstName"] as? String,
            let lastName = dictionary["lastName"] as? String,
            let mapString = dictionary["mapString"] as? String,
            let mediaURL = dictionary["mediaURL"] as? String,
            let latitude = dictionary["latitude"] as? Double,
            let longitude = dictionary["longitude"] as? Double,
            let updatedAt = dictionary["updatedAt"] as? String
            
            // If not, return nil
            else { return nil }

            // Otherwise initalize values
            self.createdAt = createdAt
            self.objectID = objectID
            self.uniqueKey = uniqueKey
            self.firstName = firstName
            self.lastName = lastName
            self.mapString = mapString
            self.mediaURL = mediaURL
            self.latitude = latitude
            self.longitude = longitude
            self.updatedAt = updatedAt
        }
    
    static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var studentLocations = [StudentLocation]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            if let studentLocation = StudentLocation(dictionary: result) {
                studentLocations.append(studentLocation)
            }
        }
        return studentLocations
    }
}
