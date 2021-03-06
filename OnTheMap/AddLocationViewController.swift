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
    
    // MARK: Properties
    
    var user = User()
    var locationData = LocationData()
    var activityIndicator = UIActivityIndicatorView()
    
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
            
            AlertView.showAlert(view: self, message: "You didn't enter a location or website")
            
        } else {
            
            // Populate locationData struct with locationText and mediaURL
            locationData.locationText = self.locationTextField.text!
            locationData.mediaURL = self.websiteTextField.text!
        
            // Get the location
            getLocation(completionHandler: { (success, error) in
                    
                // If geocoding successful...
                if success {
                    
                    // Present the ConfirmLocationViewController
                    self.performSegue(withIdentifier: "FinishSegue", sender: self)
                    
                } else {
                    
                    AlertView.showAlert(view: self, message: "Couldn't find that location")
                }
            })
        }
    }
    
    func getLocation(completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        // Create an instance of the geocoder
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationTextField.text!) { (placemark, error) in
            
            AlertView.startActivityIndicator(self.view, activityIndicator: self.activityIndicator)
            
            performUIUpdatesOnMain {
                
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
                self.locationData.latitude = latitude
                self.locationData.longitude = longitude
                
                completionHandler(true, nil)
                }
                
            AlertView.stopActivityController(self.view, activityIndicator: self.activityIndicator)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FinishSegue" {
            let controller = segue.destination as! ConfirmLocationViewController
            controller.locationData = self.locationData
        }
    }
}
