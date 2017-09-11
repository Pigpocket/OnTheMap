//
//  GCD.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/10/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation


func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
