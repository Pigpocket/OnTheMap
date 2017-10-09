//
//  PinConfirmViewController.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/29/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Properties
    
    let annotation = MKPointAnnotation()
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // Set the coordinates
        let coordinates = CLLocationCoordinate2D(latitude: locationData.latitude, longitude: locationData.longitude)
        print(coordinates)
        
        // Set the map region
        let region = MKCoordinateRegionMake(coordinates, MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
        self.mapView.delegate = self
        
        // Set the annotation
        let title = "\((user.firstName) + " " + (user.lastName))"
        let subtitle = locationData.mediaURL
        annotation.coordinate = coordinates
        annotation.title = title
        annotation.subtitle = subtitle
        
        // Add the annotation
        mapView.addAnnotation(self.annotation)
        self.mapView.addAnnotation(self.annotation)
        
        print("the current map region is: \(region)")
        
        /*performUIUpdatesOnMain {
            
        } */
    }
    
    // MARK: Actions
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func finishPressed(_ sender: Any) {
        
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
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    deinit {
        print("ConfirmLocationViewController was dismissed")
    }

}
