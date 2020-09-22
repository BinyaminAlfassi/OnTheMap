//
//  MapViewController.swift
//  On The Map
//
//  Created by Binyamin Alfassi on 19/09/2020.
//  Copyright © 2020 Binyamin Alfassi. All rights reserved.
//

import UIKit
import MapKit
// This class implements the screen for MAP locations
class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: Outlets and Variables
    // Map view
    @IBOutlet weak var mapView: MKMapView!
    
    // A list of all students location stored in the Model
    var studentsLocationList: [StudentLocation] {return StudentsLocationsModel.studentsLocationList}
    
    //MARK: View Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting the buttons for Navigation bar
        setNavigationButtons()
        // Getting students location list using Udacity client
        getStudentsList()
        // Setting viewController as map view's delegate
        mapView.delegate = self

    }
    
    //MARK: Utilities functions
    // This function set all buttons in navigation bar
    func setNavigationButtons() {
        // Refresh button -> will refresh the list of students locations
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(getStudentsList))
        // Add Button -> Add a new location.
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation))
        self.navigationItem.rightBarButtonItems = [addButton, refreshButton]
        // Logout button -> User logout
        let logoutButton: UIBarButtonItem = UIBarButtonItem()
        logoutButton.title = "LOGOUT"
        logoutButton.target = self
        logoutButton.action = #selector(logout)
        self.navigationItem.leftBarButtonItem = logoutButton
    }
    // This function get students location using Udacity client request
    @objc func getStudentsList() {
        UdacityClient.getStudentsLocation(completion: handleStudentsListResponse(studentsLocationList:error:))
    }
    // This function handles the response of request for stuents list
    func handleStudentsListResponse(studentsLocationList: [StudentLocation], error: Error?) {
        if let error = error {
            print(error)
            ShowFailure(message: "Could not fetch locations.\nPlease try again later.")
            lockUI(lock: true)
        } else {
            // Updating the model
            StudentsLocationsModel.updateStudentsLocationList(newList: studentsLocationList)
            // Updating the map with new pin (Annotation)
            mapView.addAnnotations(StudentsLocationsModel.studentsLocationAnnotations)
        }
    }
    // This function invokes a screen to add a new student-location
    @objc func addLocation() {
        let newVc = (storyboard?.instantiateViewController(identifier: "AddLocationID"))!
        present(newVc, animated: true, completion: nil)
    }
    // Logout user and returns the user to login screen
    @objc func logout() {
        UdacityClient.logout {
            self.dismiss(animated: true, completion: nil)
        }
    }
    // Lock UI if an error occurs
    func lockUI(lock: Bool){
        let buttons = self.navigationItem.rightBarButtonItems!
        for button in buttons {
            button.isEnabled = !lock
        }
    }
    
    // This function present a faluite notice on the screen
    func ShowFailure(message: String) {
        let alertVC = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: Map View Functions
    // This function places pins
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
    // This function handles tapping on a pin. It opens safari with media URL if URL is valid
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, completionHandler: nil)
            }
        }
    }
}
