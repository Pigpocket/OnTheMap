//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Tomas Sidenfaden on 9/8/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Variables
    
    var locations = [StudentLocation]()
    var annotations = [MKPointAnnotation]()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = false
        
        setAnnotations()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // Show browser and navigate to media URL when annotation is tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        // Delete the session on the Udacity server
        UdacityClient.sharedInstance().taskForDeleteSession(session: UdacityClient.sharedInstance().sessionID!) { (data, error) in
            
            performUIUpdatesOnMain {
            
                // If successful...
                if (data != nil) {
                    
                    // Dismiss the view controller
                    self.dismiss(animated: true, completion: nil)
                    
                    } else {
                    
                    // Notify the user
                    AlertView.showAlert(view: self, message: "Couldn't delete session")
                }
            }
        }
    }
    
    @IBAction func refreshPins(_ sender: Any) {
        
        setAnnotations()
        print("These are the locations after refreshingL: \(self.locations)")
    }
    
    @IBAction func addLocationPressed(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    func setAnnotations() {
        
        // Clear all annotations
      //  self.mapView.removeAnnotations(annotations)
        
        // Get the student locations
        ParseClient.sharedInstance().getStudentLocations() { (studentLocations, error) in
            
            performUIUpdatesOnMain {
                
                AlertView.startActivityIndicator(self.mapView)
                
                // Assign student locations to local variable
                if let studentLocations = studentLocations {
                    self.locations = studentLocations
                }
                
                var tempArray = [MKPointAnnotation]()
                //array =
                // Populate annotations
                
                for dictionary in self.locations {
                    
                    let lat = CLLocationDegrees(dictionary.latitude)
                    let long = CLLocationDegrees(dictionary.longitude)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = dictionary.firstName
                    let last = dictionary.lastName
                    let mediaURL = dictionary.mediaURL
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    tempArray.append(annotation)
                    
                   // self.annotations.append(annotation)
                }
                
                // Add the annotations to the annotations array
              self.mapView.removeAnnotations(self.annotations)
                self.annotations = tempArray
                self.mapView.addAnnotations(self.annotations)
                
                AlertView.stopActivityIndicator(self.view)
            }
        }
    }
    
    deinit {
        print("The MapViewController was deinitialized")
    }
}
