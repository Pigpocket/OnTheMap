//
//  UserStruct.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 10/3/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

struct User {
    
    static var shared: User = User()
    
    var firstName: String = ""
    var lastName: String = ""
    var userId: String = ""
    var objectId: String = ""
    var uniqueKey: String = ""
    var updatedAt: String = ""
    var createdAt: String = ""
    
}

