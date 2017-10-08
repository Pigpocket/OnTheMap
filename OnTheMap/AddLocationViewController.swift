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

class AddLocationViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
    }
    
    // MARK: Actions
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationPressed(_ sender: Any) {
        
        if self.locationTextField.text == "" || self.websiteTextField.text == "" {
            
            let alertController = UIAlertController()
            let alert = UIAlertAction(title: "You didn't enter a location or website", style: .cancel, handler: nil)
            alertController.addAction(alert)
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            locationData.locationText = self.locationTextField.text!
            locationData.mediaURL = self.websiteTextField.text!
        
            getLocation(completionHandler: { (success, error) in
                if success {
                    ParseClient.sharedInstance().getMyObjectID(uniqueKey: user.objectId) { (success, error) in
                        
                        if user.objectId == "" {
                            
                            ParseClient.sharedInstance().postStudentLocation(firstName: user.firstName, lastName: user.lastName, mapString: locationData.locationText, mediaURL: locationData.mediaURL, latitude: locationData.latitude, longitude: locationData.longitude, completionHandlerForPostStudentLocation: { (success, error) in
                                
                                    performUIUpdatesOnMain {
                                        if success {
                                            print("We successfully posted the Student Location")
                                    }
                                }
                            })
                            
                        } else {
                            
                            ParseClient.sharedInstance().taskForPutStudentLocation(objectId: user.objectId, completionHandlerForPutMethod: { (results, error) in
                            })
                        }
                        if let error = error {
                            print(error)
                        } else {
                            if success == true {
                                print("Successfully completed getMyObjectID")
                                
                                // Ensure user struct has info in it
                                print("User name exists and first name is: \(user.firstName)")
                                print("Location exists and location text is: \(locationData.locationText)")
                            }
                        }
                    }
                }
            })
        }
        
        ParseClient.sharedInstance().taskForPutStudentLocation(objectId: "AgaDXQdRtt") { (results, error) in
            if let error = error {
                print(error)
            } else {
                print("Put function executed successfully")
            }
        }
        
        // Present the ConfirmLocationViewController
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmLocationViewController") as! ConfirmLocationViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    func getLocation(completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationTextField.text!) { (placemark, error) in
            
            if error != nil {
                let userInfo = [NSLocalizedDescriptionKey: "There was an error attempting to retrieve your coordinates"]
                completionHandler(false, NSError(domain: "getLocation", code: 0, userInfo: userInfo))
            } else {
                
                guard let placemark = placemark else {
                    let userInfo = [NSLocalizedDescriptionKey: "There was an error with your placemark"]
                    completionHandler(false, NSError(domain: "getLocation", code: 1, userInfo: userInfo))
                    return
                }
                
                guard let latitude = placemark[0].location?.coordinate.latitude else {
                    let userInfo = [NSLocalizedDescriptionKey: "There was an error with the latitude"]
                    completionHandler(false, NSError(domain: "getLocation", code: 2, userInfo: userInfo))
                    return
                }
                
                guard let longitude = placemark[0].location?.coordinate.longitude else {
                    let userInfo = [NSLocalizedDescriptionKey: "There was an error with the longitude"]
                    completionHandler(false, NSError(domain: "getLocation", code: 3, userInfo: userInfo))
                    return
                }
                
                locationData.latitude = latitude
                locationData.longitude = longitude
                completionHandler(true, nil)
            }
        }
    }
    
    deinit {
        print("The AddLocationViewController was dismissed")
    }
    
}
