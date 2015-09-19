//
//  MapViewController.swift
//  OnTheMap
//
//  Created by George Potosky on 6/14/15.
//  Copyright (c) 2015 GeoWorld. All rights reserved.
//


import UIKit
import MapKit
import FBSDKCoreKit
import FBSDKLoginKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    //* - Map View Controller outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pinImage: UIBarButtonItem!
    
    //* - Map View variables
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    var annotations: [MKPointAnnotation] = [MKPointAnnotation]()
    var alertTitle: String!
    var alertMessage: String!
    

    //* - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()

        //* - Get the app delegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //* - Find, parse & save the student JSON data
        
        OTMClient.sharedInstance().getStudentLocationViewController(self) { (success, results, errorString) in
            if success {
                self.annotations = STLocation.STLocationFromResults(results!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotations(self.annotations)
                }
                self.mapView.delegate = self
            } else {
                //* - Call Alert message
                self.alertMessage = "Alert!"
                self.alertMessage = errorString
                self.myAlertMessage()
            }
        }
    }

    
    
    //* - Call the Add location scene button
    @IBAction func addMyLocation(sender: UIBarButtonItem) {
        let storyboard = self.storyboard
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MyLocationViewController") as! MyLocationViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    //* - Logoff button function
    @IBAction func LogoffButton(sender: UIBarButtonItem) {
        //* - You logged in with Udacity. Proceed to Udacity logout function
        if self.appDelegate.FBlogin == false {
            
            //* - Call the Logoff API
            
            OTMClient.sharedInstance().authenticateLogoffViewController(self) { (success, errorString) in
                if success {
                    //* - Call Alert message
                    self.alertTitle = "SUCCESS!"
                    self.alertMessage = "You are now logged off."
                    self.myAlertMessage()
                    
                } else {
                    //* - Call Alert message
                    self.alertMessage = "Alert!"
                    self.alertMessage = errorString
                    self.myAlertMessage()
                    
                }
            }
        }
        //* - You logged in with Facebook. Now auto-logout of Facebook
        else {
            //* - Log out of Facebook
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            //* - Go back to the login view
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

    //* - Alert Message function
    func myAlertMessage(){
        if self.alertTitle == "SUCCESS!" {
            dispatch_async(dispatch_get_main_queue()) {
                let actionSheetController: UIAlertController = UIAlertController(title: "\(self.alertTitle)", message: "\(self.alertMessage)", preferredStyle: .Alert)
                //Create and add the OK action
                let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
                    self.presentViewController(controller, animated: true, completion: nil)
                }
                actionSheetController.addAction(okAction)
                
                //* - Present the AlertController
                self.presentViewController(actionSheetController, animated: true, completion: nil)
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue()) {
                let actionSheetController: UIAlertController = UIAlertController(title: "\(self.alertTitle)", message: "\(self.alertMessage)", preferredStyle: .Alert)
                //Create and add the OK action
                let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
                }
                actionSheetController.addAction(okAction)
            
                //* - Present the AlertController
                self.presentViewController(actionSheetController, animated: true, completion: nil)
            }
        }
    }

}