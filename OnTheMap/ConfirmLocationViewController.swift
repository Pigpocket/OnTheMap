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
    var locationData = LocationData()
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("viewWillAppear in ConfirmLocationViewController has been called")
        
        // Set the coordinates
        let coordinates = CLLocationCoordinate2D(latitude: locationData.latitude, longitude: locationData.longitude)
        print(coordinates)
        
        // Set the map region
        let region = MKCoordinateRegionMake(coordinates, MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
        self.mapView.delegate = self
        
        // Set the annotation
        let title = "\((User.shared.firstName) + " " + (User.shared.lastName))"
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    // MARK: Actions
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func finishPressed(_ sender: Any) {
        
        // Get my objectId
        ParseClient.sharedInstance().getMyObjectID(uniqueKey: User.shared.uniqueKey) { (success, error) in
            
            print("***The locationData prior to put function is: \n Latitude: \(self.locationData.latitude) \n \(self.locationData.longitude)")
            // If the objectId field in 'user' struct is empty...
            if User.shared.objectId == "" {
            
                
                // Post my student location
                ParseClient.sharedInstance().postStudentLocation(firstName: User.shared.firstName, lastName: User.shared.lastName, mapString: self.locationData.locationText, mediaURL: self.locationData.mediaURL, latitude: self.locationData.latitude, longitude: self.locationData.longitude, completionHandlerForPostStudentLocation: { (success, error) in
                    
                    // Update the UI
                    performUIUpdatesOnMain {
                        if success {
                            print("We successfully posted the Student Location")
                        } else {
                            AlertView.showAlert(view: self, message: error!)
                        }
                    }
                })
            } else {
                
                print("***put Function is being called***")
                // Change my student location
                ParseClient.sharedInstance().putStudentLocation(uniqueKey: User.shared.uniqueKey, firstName: User.shared.firstName, lastName: User.shared.lastName, mapString: self.locationData.locationText, mediaUrl: self.locationData.mediaURL, latitude: self.locationData.latitude, longitude: self.locationData.longitude, completionHandlerForPut: { (success, error) in
                    
                    performUIUpdatesOnMain {
                    
                        if success == true {
                            print("Successfully completed putStudentLocation")
                            
                            // Ensure user struct has info in it
                            print("Name: \(User.shared.firstName) \(User.shared.lastName)")
                            print("UniqueKey: \(User.shared.uniqueKey)")
                            print("Location exists: \(self.locationData.locationText)")
                            print("MediaURL: \(self.locationData.mediaURL)")
                            print("Coordinates: Latitude = \(self.locationData.latitude) Longitude = \(self.locationData.longitude)")
                            print("Updated at: \(User.shared.updatedAt)")
                            
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

