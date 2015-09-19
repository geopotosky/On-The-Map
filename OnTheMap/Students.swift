//
//  Students.swift
//  OnTheMap
//
//  Created by George Potosky on 6/19/15.
//  Copyright (c) 2015 GeoWorld. All rights reserved.
//

import UIKit

//* - Create Students Array for Table View

struct Students {
    
    let createdAt: NSDate?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: NSDate?
    
    static let CreatedAt = "createdAt"
    static let Firstname = "firstName"
    static let Lastname = "lastName"
    static let Latitude = "latitude"
    static let Longitude = "longitude"
    static let Mapstring = "mapString"
    static let MediaURL = "mediaURL"
    static let ObjectId = "objectId"
    static let UniqueKey = "uniqueKey"
    static let UpdatedAt = "updatedAt"
    
    //* - Initialize JSON properties
    init(dictionary: [String : AnyObject]) {
        self.createdAt = dictionary[Students.CreatedAt] as? NSDate
        self.firstName = dictionary[Students.Firstname] as? String
        self.lastName = dictionary[Students.Lastname] as? String
        self.latitude = dictionary[Students.Latitude] as? Double
        self.longitude = dictionary[Students.Longitude] as? Double
        self.mapString = dictionary[Students.Mapstring] as? String
        self.mediaURL = dictionary[Students.MediaURL] as? String
        self.objectId = dictionary[Students.ObjectId] as? String
        self.uniqueKey = dictionary[Students.UniqueKey] as? String
        self.updatedAt = dictionary[Students.UpdatedAt] as? NSDate
    }
}

extension Students {
    
//* - Create Student Information Array
    static func studentsFromResults(results: [[String : AnyObject]]) -> [Students] {
            
        var studentList = [Students]()
        
        //* - Iterate through array of dictionaries; each Student is a dictionary
        for result in results {
            studentList.append(Students(dictionary: result))
        }
        return studentList
    }
}

