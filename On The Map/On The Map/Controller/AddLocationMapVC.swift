//
//  AddLocationMapVC.swift
//  On The Map
//
//  Created by Binyamin Alfassi on 20/09/2020.
//  Copyright © 2020 Binyamin Alfassi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//MARK: Description
// This class implemets screen to verify the location using a map and posting a new student location
class AddLocationMapVC: UIViewController, MKMapViewDelegate {

    //MARK: Outlets and Variables
    // Map View
    @IBOutlet weak var mapView: MKMapView!
    // The location to be added
    var selectedLocation: MKMapItem?
    // The Media URL
    var selectedMediaUrl: String?
    
//    let locationManager = CLLocationManager()
//    var resultSearchController: UISearchController? = nil
    //MARK: View Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting map view delegate
        mapView.delegate = self
        // placing a new pin on the map of the new location
        placePin()
        // Setting maps region to be around the new location
        zoomMap()
    }
    //MARK: Actions and Functions
    // Set the region of the map to be around the new location
    func zoomMap(){
        let coordinate = (self.selectedLocation?.placemark.coordinate)!
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    // placing a new pin on the map for the new location
    func placePin() {
        let placemark = self.selectedLocation!.placemark as MKPlacemark
        mapView.addAnnotation(placemark)
    }
    // This function is envoked when FINISH button is tapped.
    // It will post the new location along with the mediaURL
    @IBAction func finishTapped(_ sender: Any) {
        let placemark = self.selectedLocation!.placemark as MKPlacemark
        UdacityClient.postStudentLocation(studentLocation: placemark, mediaURL: self.selectedMediaUrl!, completion: handlePostSatudentLocation(success:error:))
    }
    // Handles the request of posting new location
    func handlePostSatudentLocation(success: Bool, error: Error?) {
        if success {
            dismiss(animated: true, completion: nil)
        } else {
            ShowFailure(message: "Something went wrong")
        }
    }
    // present an Alrt message to the screen
    func ShowFailure(message: String) {
            let alertVC = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
}

