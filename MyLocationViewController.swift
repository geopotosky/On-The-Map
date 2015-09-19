//
//  MyLocationViewController.swift
//  OnTheMap
//
//  Created by George Potosky on 6/21/15.
//  Copyright (c) 2015 GeoWorld. All rights reserved.
//

import UIKit
import MapKit


class MyLocationViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    //* - Screen outlets
    @IBOutlet weak var WhereAmIBG1: UILabel!
    @IBOutlet weak var WhereAmIBG2: UILabel!
    @IBOutlet weak var WhereAmILabel: UILabel!
    @IBOutlet weak var LocationTextfield: UITextField!
    @IBOutlet weak var FindOnTheMapButtonLabel: UIButton!
    @IBOutlet weak var MyLocationBG: UILabel!
    @IBOutlet weak var MyLocationMapView: MKMapView!
    @IBOutlet weak var MyURLTextfield: UITextField!
    @IBOutlet weak var MyLocationSubmitButton: UIButton!
    @IBOutlet weak var cancelLabel: UIButton!
    @IBOutlet weak var cancelGreyLabel: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    //* - Set the textfield delegates
    let locationFieldDelegate = LocationFieldDelegate()
    let urlFieldDelegate = URLFieldDelegate()
    
    //* - Sharing appDelegate variable
    var appDelegate: AppDelegate!
    
    //* - Shared URL session variable
    var session: NSURLSession!
    
    //* - Alert message variable
    var alertTitle: String!
    var alertMessage: String!
    
    //* - Location Variables
    var latitude : String!
    var longitude : String!
    var myLat : Double!
    var myLon : Double!
    var myLocation : String!
    var myURL : String!
    var locationManager: CLLocationManager!
    
    var backgroundGradient: CAGradientLayer? = nil
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    //* - Based on student comments, this was added to help with smaller resolution devices
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    
    
    //* - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //* - Get the app delegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //* - Get the shared URL session
        session = NSURLSession.sharedSession()

        //* - Set the textfield delegate values
        self.LocationTextfield.delegate = locationFieldDelegate
        self.MyURLTextfield.delegate = urlFieldDelegate

        //* - Configure tap recognizer
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //* - Set Scene Outlet hidden values for current scene in "My Location" view
        WhereAmIBG1.hidden = false
        WhereAmIBG2.hidden = false
        WhereAmILabel.hidden = false
        LocationTextfield.hidden = false
        cancelLabel.hidden = false
        FindOnTheMapButtonLabel.hidden = false
        
        MyLocationBG.hidden = true
        MyLocationMapView.hidden = true
        MyURLTextfield.hidden = true
        MyLocationSubmitButton.hidden = true
        cancelGreyLabel.hidden = true
        activityIndicatorView.hidden = true

        //* - Keyboard notifications and actions
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //* - Keyboard notifications and actions
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }

    
    //* - Keyboard Fixes
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    //* - "My Location" scene button function
    
    @IBAction func WhereAmIButton(sender: UIButton) {
        
        //* - Check to see if you have a network connection before attempting to logon
        if Reachability.isConnectedToNetwork() == false {
            //* - Call Alert message
            self.alertTitle = "Network Error."
            self.alertMessage = "Internet Connection Failed."
            self.locationAlertMessage()
        } else {
        if LocationTextfield.text.isEmpty {
            //* - Call Alert message
            self.alertTitle = "Location Missing Error."
            self.alertMessage = "Location is missing. Please enter a valid location."
            self.locationAlertMessage()
            
        } else {
            //* - Animate Activity indicator while geocoding
            self.activityIndicatorView.hidden = false
            self.activityIndicatorView.startAnimating()
            
            //* - See new location values
            var address = self.LocationTextfield.text
            self.appDelegate.myLocation = self.LocationTextfield.text
            var geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
                //* - Check for server side geocode error
                if let placemark = placemarks?[0] as? CLPlacemark {
                    //* - Store new coordinates for posting
                    let location = placemark.location as CLLocation
                    let coordinate = location.coordinate as CLLocationCoordinate2D
                    let latlong = ["%f, %f", coordinate.latitude, coordinate.longitude]
                    self.appDelegate.myLatitude = coordinate.latitude as Double
                    self.appDelegate.myLongitude = coordinate.longitude as Double
                    
                    //* - Add pin for my location
                    self.MyLocationMapView.addAnnotation(MKPlacemark(placemark: placemark))
                    
                    //* - Move my pin location to center of map display
                    self.MyLocationMapView.setCenterCoordinate(location.coordinate, animated: true)
                    
                    //* - Change outlets hidden values for next scene in my location view
                    self.WhereAmIBG1.hidden = true
                    self.WhereAmIBG2.hidden = true
                    self.WhereAmILabel.hidden = true
                    self.LocationTextfield.hidden = true
                    self.FindOnTheMapButtonLabel.hidden = true
                    self.cancelLabel.hidden = true
                    self.MyLocationBG.hidden = false
                    self.MyLocationMapView.hidden = false
                    self.MyURLTextfield.hidden = false
                    self.MyLocationSubmitButton.hidden = false
                    self.cancelGreyLabel.hidden = false
                    
                    //* - Set the initial zoom map location based on my location
                    let initialLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    self.zoomInOnMyLocation(initialLocation)
                    
                    //* - Turn off Activity indicator while geocoding
                    self.activityIndicatorView.hidden = true
                    self.activityIndicatorView.stopAnimating()
                }
                else {
                    //* - Call Alert message
                    self.alertTitle = "Location Error."
                    self.alertMessage = "Location does not exist."
                    self.locationAlertMessage()
                    
                    //* - Turn off Activity indicator while geocoding
                    self.activityIndicatorView.hidden = true
                    self.activityIndicatorView.stopAnimating()

                }
            })
        }
        }
    }

    
    //* - Location Zoom function
    
    func zoomInOnMyLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        MyLocationMapView.setRegion(coordinateRegion, animated: true)
    }

    
    //* - "My URL" scene button function
    
    @IBAction func MyLocationSubmitButton(sender: UIButton) {
        if MyURLTextfield.text.isEmpty {
            //* - Call Alert message
            self.alertTitle = "URL Missing Error."
            self.alertMessage = "URL field is missing."
            self.locationAlertMessage()
        } else {
            var urlString = MyURLTextfield.text // validate this URL
            if let urlString = urlString{
                if let url = NSURL(string: urlString){
                    //Check if your application can open the NSURL instance
                    if UIApplication.sharedApplication().canOpenURL(url){
                        //* - Set my new URL value
                        self.appDelegate.myURL = self.MyURLTextfield.text
                        
                        //* - Show and start the activity indicator
                        self.activityIndicatorView.hidden = false
                        self.activityIndicatorView.startAnimating()
                        
                        //* - Call the post location function
                        OTMClient.sharedInstance().postLocationViewController(self) { (success, errorString) in
                            if success {
                                //* - Hide and stop the activity indicator
                                self.activityIndicatorView.hidden = true
                                self.activityIndicatorView.stopAnimating()
                                
                                //* - Go back to map view
                                dispatch_async(dispatch_get_main_queue()) {
                                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
                                    self.presentViewController(controller, animated: true, completion: nil)
                                }
                            } else {
                                //* - Call Alert message
                                self.alertMessage = "Alert!"
                                self.alertMessage = errorString
                                self.locationAlertMessage()
                            }
                        }
                        
                    } else {
                        //* - Call Alert message
                        self.alertTitle = "URL Error."
                        self.alertMessage = "Invalid URL"
                        self.locationAlertMessage()
                    }
                }else {
                    //* - Call Alert message
                    self.alertTitle = "URL Error."
                    self.alertMessage = "Invalid URL"
                    self.locationAlertMessage()
                }
            } else {
                //* - Call Alert message
                self.alertTitle = "URL Error."
                self.alertMessage = "Invalid URL"
                self.locationAlertMessage()
            }
        }
    }


    
    //* - Alert Message function
    func locationAlertMessage(){
        dispatch_async(dispatch_get_main_queue()) {
            let actionSheetController: UIAlertController = UIAlertController(title: "\(self.alertTitle)", message: "\(self.alertMessage)", preferredStyle: .Alert)
            //* - Create and add the OK action
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
            }
            actionSheetController.addAction(okAction)
            
            //* - Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
    }
    
    
    //* - Cancel button function
    @IBAction func cancelButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    //* ------------------------------------ Keyboard Functions --------------------------------------- *//
    
    
    //* - Subscribe to Keyboard appearing and hiding notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //* - Move screen up to prevent keyboard overlap
    func keyboardWillShow(notification: NSNotification) {
        if FindOnTheMapButtonLabel.isFirstResponder(){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //* - Move screen back down after done using keyboard
    func keyboardWillHide(notification: NSNotification) {
        if FindOnTheMapButtonLabel.isFirstResponder(){
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    //* - Calculate the keyboard height and place in variable
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //* - Unsubscribe from Keyboard Appearing and hiding notifications
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }

}

