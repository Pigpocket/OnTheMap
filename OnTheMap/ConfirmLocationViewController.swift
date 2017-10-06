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
        
        // Set the annotation
        let coordinates = CLLocationCoordinate2D(latitude: locationData.latitude, longitude: locationData.longitude)
        
        // Set the map region
        
        let region = MKCoordinateRegionMake(coordinates, MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        
        let title = "\((user.firstName) + " " + (user.lastName))"
        let subtitle = locationData.mediaURL
        annotation.coordinate = coordinates
        annotation.title = title
        annotation.subtitle = subtitle
        
        self.mapView.delegate = self
        mapView.addAnnotation(self.annotation)
        
        self.mapView.addAnnotation(self.annotation)
        self.mapView.setRegion(region, animated: true)
        print("the current map region is: \(region)")
        
        performUIUpdatesOnMain {
            
        }
    }
    
    // MARK: Actions
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func finishPressed(_ sender: Any) {
        
        
        //let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        //self.present(controller, animated: true, completion: nil)
    }
    
    
    
    deinit {
        print("ConfirmLocationViewController was dismissed")
    }

}
