//
//  Locations.swift
//  OnTheMap
//
//  Created by George Potosky on 6/16/15.
//  Copyright (c) 2015 GeoWorld. All rights reserved.
//

import Foundation
import MapKit

struct STLocation {
    
    //* - Create Annotations Array for Student Pins
    
    static func STLocationFromResults(results: [[String : AnyObject]]) -> [MKPointAnnotation] {

        //* - Create Annotations array property
        var annotations = [MKPointAnnotation]()
        
        //* - Iterate through array of dictionaries; each Student is a dictionary
        for result in results {
            let lat = CLLocationDegrees(result["latitude"] as! Double)
            let long = CLLocationDegrees(result["longitude"] as! Double)

            //* - The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            //* - Create properties used for annonations
            let first = result["firstName"] as! String
            let last = result["lastName"] as! String
            let mediaURL = result["mediaURL"] as! String
            
            //* - Here we create the annotation and set its coordiate, title, and subtitle properties
            var annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
            
        return annotations
    }
}


    