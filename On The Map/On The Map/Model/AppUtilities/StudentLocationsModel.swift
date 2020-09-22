//
//  StudentLocationsModel.swift
//  On The Map
//
//  Created by Binyamin Alfassi on 19/09/2020.
//  Copyright © 2020 Binyamin Alfassi. All rights reserved.
//

import Foundation
import MapKit

class StudentsLocationsModel {
    static var studentsLocationList = [StudentLocation]()
    static var studentsLocationAnnotations = [MKPointAnnotation]()
    
    class func updateStudentsLocationList(newList: [StudentLocation]) {
        studentsLocationList = newList
        updateAnnotations()
    }
    
    class func updateAnnotations() {
        for student in studentsLocationList {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            studentsLocationAnnotations.append(annotation)
        }
    }
}
