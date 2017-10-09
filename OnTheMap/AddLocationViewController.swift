//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/28/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        
        locationTextField.delegate = self
        websiteTextField.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationPressed(_ sender: Any) {
        
        // Show alert if locationTextField or websiteTextField are empty
        if self.locationTextField.text == "" || self.websiteTextField.text == "" {
            
            let alertController = UIAlertController()
            let alert = UIAlertAction(title: "You didn't enter a location or website", style: .cancel, handler: nil)
            alertController.addAction(alert)
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            // Populate locationData struct with locationText and mediaURL
            locationData.locationText = self.locationTextField.text!
            locationData.mediaURL = self.websiteTextField.text!
        
            // Get the location
            getLocation(completionHandler: { (success, error) in
                
                // If geocoding successful...
                if success {
                    
                    // Get my objectId
                    ParseClient.sharedInstance().getMyObjectID(uniqueKey: user.objectId) { (success, error) in
                        
                        print("***The locationData prior to put function is: \n Latitude: \(locationData.latitude) \n \(locationData.longitude)")
                        // If the objectId field in 'user' struct is empty...
                        if user.objectId == "" {
                            
                            // Post my student location
                            ParseClient.sharedInstance().postStudentLocation(firstName: user.firstName, lastName: user.lastName, mapString: locationData.locationText, mediaURL: locationData.mediaURL, latitude: locationData.latitude, longitude: locationData.longitude, completionHandlerForPostStudentLocation: { (success, error) in
                                
                                    // Update the UI
                                    performUIUpdatesOnMain {
                                        if success {
                                            print("We successfully posted the Student Location")
                                    }
                                }
                            })
                            
                        } else {
                            
                            print("***put Function is being called***")
                            // Change my student location
                            ParseClient.sharedInstance().putStudentLocation(objectId: user.objectId, firstName: user.firstName, lastName: user.lastName, mapString: locationData.locationText, mediaUrl: locationData.mediaURL, latitude: locationData.latitude, longitude: locationData.longitude, completionHandlerForPut: { (success, error) in
                                
                                // Update the UI
                                performUIUpdatesOnMain {
                                    if success == true {
                                        print("Successfully completed putStudentLocation")
                                        
                                        // Ensure user struct has info in it
                                        print("User name exists and first name is: \(user.firstName)")
                                        print("Location exists and location text is: \(locationData.locationText)")
                                    }
                                }
                            })
                        }
                    }
                }
            })
        
            // Present the ConfirmLocationViewController
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmLocationViewController") as! ConfirmLocationViewController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func getLocation(completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        // Create an instance of the geocoder
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationTextField.text!) { (placemark, error) in
            
            // Check for an error when retrieving the coordinates
            if error != nil {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error attempting to retrieve your coordinates"]
                completionHandler(false, NSError(domain: "getLocation", code: 0, userInfo: userInfo))
            
            } else {
            
                // GUARD: Confirm placemark exists
                guard let placemark = placemark else {
                    let userInfo = [NSLocalizedDescriptionKey: "There was an error with your placemark"]
                    completionHandler(false, NSError(domain: "getLocation", code: 1, userInfo: userInfo))
                    return
                }
                
                // GUARD: Confirm latitude exists in placemark
                guard let latitude = placemark[0].location?.coordinate.latitude else {
                    let userInfo = [NSLocalizedDescriptionKey: "There was an error with the latitude"]
                    completionHandler(false, NSError(domain: "getLocation", code: 2, userInfo: userInfo))
                    return
                }
                
                // GUARD: Confirm longitude exists in placemark
                guard let longitude = placemark[0].location?.coordinate.longitude else {
                    let userInfo = [NSLocalizedDescriptionKey: "There was an error with the longitude"]
                    completionHandler(false, NSError(domain: "getLocation", code: 3, userInfo: userInfo))
                    return
                }
                
                // Populate locationData with latitude and longitude
                locationData.latitude = latitude
                locationData.longitude = longitude
                
                completionHandler(true, nil)
                print("getLocation was successful. \n Latitude=\(latitude) \n Longitude=\(longitude)")
            }
        }
    }
    
    deinit {
        print("The AddLocationViewController was dismissed")
    }
    
}
