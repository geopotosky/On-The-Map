//
//  OTMClient.swift
//  OnTheMap
//
//  Created by George Potosky on 6/29/15.
//  Copyright (c) 2015 GeoWorld. All rights reserved.
//


import Foundation
import UIKit


class OTMClient : NSObject {
    
    //* - Shared session
    var session: NSURLSession
    
    //* - Get the app delegate
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    //* - Student Information Arrray
    var studentLocations: [Students]!
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    
    //* - Authentication Loop
    
    func authenticateWithViewController(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        //* - Assign username & password delegate values to new variables
        let username = self.appDelegate.username
        let password = self.appDelegate.password
        
        //* - Chain completion handlers for each request, if applicable, so that they run one after the other */
        self.postSession(username, password: password) { (success, accountKey, errorString) in
            
            if success {            
                self.getUserData(accountKey) { (success, errorString) in
                    if success {
                        completionHandler(success: true, errorString: errorString)
                    } else {
                        completionHandler(success: success, errorString: errorString)
                    }
                }
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }

    
    //* - Facebook Authentication Loop
    
    func authenticateFBWithViewController(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        //* - Assign access token delegate value to new variable
        let accessToken = self.appDelegate.accessToken

        //* - Chain completion handlers for each request, if applicable, so that they run one after the other */
        self.postFBSession(accessToken) { (success, accountKey, errorString) in
            
            if success {
                self.getUserData(accountKey) { (success, errorString) in
                    if success {
                        completionHandler(success: true, errorString: errorString)
                    } else {
                        completionHandler(success: success, errorString: errorString)
                    }
                }
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }

    
    //* - Logoff Authentication Loop
    
    func authenticateLogoffViewController(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        //* - Chain completion handlers for each request, if applicable, so that they run one after the other */
        self.logoffSession() { (success, errorString) in
            
            if success {
                completionHandler(success: true, errorString: errorString)
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
    

    //* - Get Student Location Loop
    
    func getStudentLocationViewController(hostViewController: UIViewController, completionHandler: (success: Bool, results: [[String : AnyObject]]?, errorString: String?) -> Void) {
        
        //* - Chain completion handlers for each request, if applicable, so that they run one after the other */
        self.getStudentLocation() { (success, results, errorString) in
            
            if success {
                completionHandler(success: true, results: results, errorString: errorString)
            } else {
                completionHandler(success: success, results: nil, errorString: errorString)
            }
        }
    }
    

    //* - Logoff Authentication Loop
    
    func postLocationViewController(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        //* - Assign username & password delegate values to new variables
        let myFirstname = self.appDelegate.myFirstName
        let myLastname = self.appDelegate.myLastName
        let myLocation = self.appDelegate.myLocation
        let myURL = self.appDelegate.myURL
        let myLat = self.appDelegate.myLatitude
        let myLon = self.appDelegate.myLongitude
        
        //* - Chain completion handlers for each request, if applicable, so that they run one after the other */
        self.postMyLocation(myFirstname, myLastname: myLastname, myLocation: myLocation, myURL: myURL, myLat: myLat, myLon: myLon) { (success, errorString) in
            
            if success {
                completionHandler(success: true, errorString: errorString)
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
    
    
    //* - Call the Udacity POST Student Session API
    
    func postSession(username: String, password: String, completionHandler: (success: Bool, accountKey: String?, errorString: String?) -> Void) {
        
        //* - Set username & password parameters
        let methodParameters = [
            "username": username as String!,
            "password": password as String!
        ]
        
        //* - Build & Configure the URL
        let urlString = Constants.UdacityBaseURLSecure + Methods.Session
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, accountKey: nil, errorString: "\(error)")
                
            } else {
                
                /* Parse the data */
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary!
                if let errorText = parsedResult["error"] as? String {
                    completionHandler(success: false, accountKey: nil, errorString: "Login Failed (Account Key).")
                } else {
                    
                    /* Use the data! */
                    if let sessionDictionary = parsedResult.valueForKey(ParameterKeys.Account) as? [String: AnyObject]{
                        if let accountKey = sessionDictionary[ParameterKeys.Key] as? String {
                            completionHandler(success: true, accountKey: accountKey, errorString: nil)
                        } else {
                            if let status_code = parsedResult["status"] as? Int {
                                completionHandler(success: false, accountKey: nil, errorString: "Login Failed (Account Key).")
                            } else {
                                completionHandler(success: false, accountKey: nil, errorString: "Login Failed (Account Key).")
                            }
                        }
                        
                    }
                }
            }
        }
        task.resume()
    }

    
    //* - Call the Udacity POST Student Session for Facebook API
    
    func postFBSession(accessToken: String, completionHandler: (success: Bool, accountKey: String?, errorString: String?) -> Void) {
        
        //* - Build & Configure the URL
        let urlString = Constants.UdacityBaseURLSecure + Methods.Session
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)

        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"\(accessToken)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, accountKey: nil, errorString: "\(error)")
                
            } else {
                
                /* Parse the data */
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary!
                if let errorText = parsedResult["error"] as? String {
                    completionHandler(success: false, accountKey: nil, errorString: "Login Failed (Account Key).")
                } else {
                    
                    /* Use the data! */
                    if let sessionDictionary = parsedResult.valueForKey(ParameterKeys.Account) as? [String: AnyObject]{
                        if let accountKey = sessionDictionary[ParameterKeys.Key] as? String {
                            completionHandler(success: true, accountKey: accountKey, errorString: nil)
                        } else {
                            if let status_code = parsedResult["status"] as? Int {
                                completionHandler(success: false, accountKey: nil, errorString: "Login Failed (Account Key).")
                            } else {
                                completionHandler(success: false, accountKey: nil, errorString: "Login Failed (Account Key).")
                            }
                        }
                        
                    }
                }
            }
        }
        task.resume()
    }

    
    //* - Call the Udacity GET Student Info API
    
    func getUserData(accountKey: String!, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        //* - Set the parameters */
        let methodParameters = [
            "accountKey": accountKey as String?
        ]
        
        //* - Build & Configure the URL
        let urlString = Constants.UdacityBaseURLSecure + Methods.Users + "\(accountKey)"
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            
            if let error = downloadError {
                completionHandler(success: false, errorString: "Get User Data Failed.")
            } else {
                
                /* Parse the data */
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                /* Use the data! */
                if let sessionDictionary = parsedResult.valueForKey(ParameterKeys.User) as? [String: AnyObject]{
                    let myLastName = sessionDictionary[ParameterKeys.LastName] as! String
                    let myFirstName = sessionDictionary[ParameterKeys.FirstName] as! String
                    self.appDelegate.myLastName = myLastName
                    self.appDelegate.myFirstName = myFirstName
                    completionHandler(success: true, errorString: nil)
                    
                } else {
                    completionHandler(success: false, errorString: "Get User Data Failed.")
                }
            }
        }
        /* Start the request */
        task.resume()
    }
    
    
    //* - Call the Udacity Logout Session API
    
    func logoffSession(completionHandler: (success: Bool, errorString: String?) -> Void) {

        //* - Build & Configure the URL
        let urlString = Constants.UdacityBaseURLSecure + Methods.Session
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)

        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            //* - Check to see if you have a network connection before attempting to logon
            if Reachability.isConnectedToNetwork() == false {
                completionHandler(success: false, errorString: "Internet Connection Failed.")
            } else {
                //* - Check for server side error
                if error != nil {
                    completionHandler(success: false, errorString: "\(error)")
                }
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary!
                
                //* - Use the data!
                if let logoffDictionary = parsedResult.valueForKey("session") as? [String: AnyObject]{
                    if let logoffID = logoffDictionary["id"] as? String {
                        dispatch_async(dispatch_get_main_queue()) {
                            completionHandler(success: true, errorString: nil)
                        }
                    } else {
                        if let status_code = parsedResult["status"] as? Int {
                            completionHandler(success: false, errorString: "\(status_code).")
                        } else {
                            completionHandler(success: false, errorString: "Could not find status code.")
                        }
                    } //*- End status parsing
                } //* - End session parsing
            } //* - End Network Connection Check
        } //* - End task
        task.resume()
    }

    
    //* Function to get the student location data
    
    func getStudentLocation(completionHandler: (success: Bool, results: [[String : AnyObject]]?, errorString: String?) -> Void) {
        
        //* - Build & Configure the URL
        let urlString = Constants.ParseAPIBaseURLSecure + Methods.StudentLocation
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            
            //* - Check to see if you have a network connection before attempting to logon
            if Reachability.isConnectedToNetwork() == false {
                completionHandler(success: false, results: nil, errorString: "Internet Connection Failed.")
                
            } else {
                //* - Check for a server download error
                if let error = downloadError {
                    completionHandler(success: false, results: nil, errorString: "\(error)")
                } else {
                    
                    //* - Parse the data
                    var parsingError: NSError? = nil
                    let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                    
                    //* - Use the data!
                    if let error = parsingError {
                        completionHandler(success: false, results: nil, errorString: "\(error)")
                    } else {
                        if let results = parsedResult["results"] as? [[String : AnyObject]] {
                            //* - Send parsed data to Students struct to populate array
                            self.studentLocations = Students.studentsFromResults(results)
                            completionHandler(success: true, results: results, errorString: nil)
                            
                        } else {
                            completionHandler(success: false, results: nil, errorString: "Could not find results in \(parsedResult)")
                        }
                    }
                }
            }
        }
        
        //* - Start the request
        task.resume()
    }

    
    //* Function to post the student location data
    
    func postMyLocation(myFirstname: String!, myLastname: String!, myLocation: String!, myURL: String!, myLat: Double!, myLon: Double!, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        //* - Set the parameters */
        let methodParameters = [
            "myFirstname": myFirstname as String!,
            "myLastname": myLastname as String!,
            "myLocation": myLocation as String!,
            "myURL": myURL as String!,
            "mLat": myLat as Double!,
            "myLon": myLon as Double
        ]
        
        //* - Build & Configure the URL
        let urlString = Constants.ParseAPIBaseURLSecure + Methods.StudentLocation
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"\(myFirstname)\", \"lastName\": \"\(myLastname)\",\"mapString\": \"\(myLocation)\", \"mediaURL\": \"\(myURL)\",\"latitude\": \(myLat), \"longitude\": \(myLon)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            //* - Check to see if you have a network connection before attempting to logon
            if Reachability.isConnectedToNetwork() == false {
                completionHandler(success: false, errorString: "Internet Connection Failed")
            } else {
                //* - Check for server post error
                if error != nil {
                    completionHandler(success: false, errorString: "Could not complete the post \(error)")
                    
                } else {
                    //* - Parse the data
                    var parsingError: NSError? = nil
                    let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary!
                    if let errorCode = parsedResult["error"] as? String {
                        completionHandler(success: false, errorString: "\(errorCode)")
                        
                    } else {
                        completionHandler(success: true, errorString: nil)

                    }
                }
            }
        }
        task.resume()
    }

    //* - Shared Instance
    
    class func sharedInstance() -> OTMClient {
        
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        
        return Singleton.sharedInstance
    }
}