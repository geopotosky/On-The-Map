//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by George Potosky on 8/20/15.
//  Copyright (c) 2015 GeoWorld. All rights reserved.
//

import Foundation

extension OTMClient {
    
    //* - Constants
    struct Constants {
        
    //* - URLs
        static let UdacityBaseURL : String = "http://www.udacity.com/api/"
        static let UdacityBaseURLSecure : String = "https://www.udacity.com/api/"
        static let ParseAPIBaseURLSecure : String = "https://api.parse.com/1/classes/"
    }
    
    //* - Methods
    struct Methods {
        
        static let Session = "session"
        static let Users = "users/"
        static let StudentLocation = "StudentLocation"
        
    }
    
    //* - Parameter Keys
    struct ParameterKeys {
        
        static let Key = "key"
        static let Account = "account"
        static let User = "user"
        static let LastName = "last_name"
        static let FirstName = "first_name"
    }
    
}