//
//  TableViewController.swift
//  OnTheMap
//
//  Created by George Potosky on 6/14/15.
//  Copyright (c) 2015 GeoWorld. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //* - Table View outlets
    @IBOutlet weak var studentTableView: UITableView!

    //* - Table View global variables
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    var alertTitle: String!
    var alertMessage: String!
    
    //* - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //* - Call the Student Location API
        
        //* - Find, parse & save the student JSON data
        OTMClient.sharedInstance().getStudentLocationViewController(self) { (success, results, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    self.studentTableView.reloadData()
                }
            } else {
                self.alertMessage = "Alert!"
                self.alertMessage = errorString
                self.myAlertMessage()
            }
        }
    }

    
    //* - Table Functions
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("locationTableViewCell") as! UITableViewCell
        //* - Set Student Name value
        cell.textLabel?.text = OTMClient.sharedInstance().studentLocations[indexPath.row].firstName! + " " + OTMClient.sharedInstance().studentLocations[indexPath.row].lastName!
        //* - Set location value
        cell.detailTextLabel?.text = "From: " + OTMClient.sharedInstance().studentLocations[indexPath.row].mapString!
        //* - Set pin image
        var image : UIImage = UIImage(named: "pinImage")!
        cell.imageView!.image = image
        
        return cell
    }
    
    
    //* - Count # of students for rows in table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMClient.sharedInstance().studentLocations.count
    }

    
    //* - Go to student URL if selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let student1 = studentList[indexPath.row]
        let student1 = OTMClient.sharedInstance().studentLocations[indexPath.row]
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: student1.mediaURL!)!)
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