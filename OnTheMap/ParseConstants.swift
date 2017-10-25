//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/10/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
    
    struct Constants {
        
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApplicationJSON = "application/json"
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/"
        static let AuthorizationURL = ""
        static let WhereQuery = "where"
        static let parseBaseURL = "https://parse.udacity.com/parse/classes/"
    }
    
    struct JSONBodyKeys {
        
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mediaURL = "mediaURL"
        static let mapString = "mapString"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    struct JSONParameterKeys {
        
        static let ApplicationID = "X-Parse-Application-Id"
        static let RestAPIKey = "X-Parse-REST-API-Key"
        static let ContentType = "Content-Type"
        static let limit = "limit"
        static let skip = "skip"
        static let order = "order"
    }
    
    struct Methods {
        
        static let Location = "StudentLocation"
        static let LocationSlash = "StudentLocation/"
        static let Session = "session"
    }
}
