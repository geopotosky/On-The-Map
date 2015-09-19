//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by George Potosky on 6/15/15.
//  Copyright (c) 2015 GeoWorld. All rights reserved.
//

import Foundation
import MapKit

class StudentLocation: NSObject, MKAnnotation {
    let title: String
//    let locationName: String
//    let lastName: String
//    let firstName: String
//    let mapString: String
    let mediaURL: String
//    let objectId: String
//    let createdAt: NSDate
//    let updatedAt: NSDate
    let coordinate: CLLocationCoordinate2D
    
    //init(lastName: String, firstName: String, mapString: String, mediaURL: String, objectId: String, createdAt: NSDate, updatedAt: NSDate, coordinate: CLLocationCoordinate2D) {
//    init(lastName: String, mapString: String, coordinate: CLLocationCoordinate2D) {
    init(title: String, mediaURL: String, coordinate: CLLocationCoordinate2D) {
//        self.lastName = lastName
//        self.firstName = firstName
//        self.mapString = mapString
        self.mediaURL = mediaURL
//        self.objectId = objectId
//        self.createdAt = createdAt
//        self.updatedAt = updatedAt
        self.title = title
//        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String {
        return mediaURL
    }

    
    // pinColor for disciplines: Sculpture, Plaque, Mural, Monument, other
//    func pinImage() -> MKPinAnnotationColor  {
//        
//        }

    
}