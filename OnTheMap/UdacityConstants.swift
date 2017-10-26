//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/10/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    struct Constants {
        
        static let UdacityBaseURL = "https://www.udacity.com/api/"
        static let SessionURL = "https://www.udacity.com/api/session"
        static let ApplicationJSON = "application/json"
    }
    
    struct Method {
        
        static let Session = "session"
        static let Users = "users/"
    }
    
    struct JSONBodyKeys {
        
        static let UdacityDict = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    struct JSONParameterKeys {
        
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }
    
    struct UdacityResponseKeys {
        
        static let Session = "session"
        static let SessionID = "id"
        static let Account = "account"
        static let AccountKey = "key"
    }
    
}
