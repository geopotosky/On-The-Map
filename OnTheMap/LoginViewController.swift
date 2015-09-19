//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by George Potosky on 6/10/15.
//  Copyright (c) 2015 GeoWorld. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    //* - Login View outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginLabel: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    //* - Login View global variables
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    var alertMessage: String!
    var accessToken: String!
    
    //* - Set the textfield delegates
    let usernameFieldDelegate = UsernameFieldDelegate()
    let passwordFieldDelegate = PasswordFieldDelegate()

    //var backgroundGradient: CAGradientLayer? = nil
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
        
        //* - textfield delegate values
        self.usernameTextField.delegate = usernameFieldDelegate
        self.passwordTextField.delegate = passwordFieldDelegate
        
        //* - textfield padding
        let emailTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let emailTextFieldPaddingView = UIView(frame: emailTextFieldPaddingViewFrame)
        usernameTextField.leftView = emailTextFieldPaddingView
        usernameTextField.leftViewMode = .Always
        
        let passwordTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let passwordTextFieldPaddingView = UIView(frame: passwordTextFieldPaddingViewFrame)
        passwordTextField.leftView = passwordTextFieldPaddingView
        passwordTextField.leftViewMode = .Always
        
        //* - Configure tap recognizer
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        
        
        //* - Hide the activity Indicator as default
        self.activityIndicatorView.hidden = true
        
        
        if (FBSDKAccessToken.currentAccessToken() == nil)
        {
            self.loginLabel.enabled = true
        }
        else
        {
            self.loginLabel.enabled = false
            alertMessage = "Log out of Facebook before continuing."
            loginAlertMessage()
        }

        //* - Set the Facebook button for use
        fbLoginButton.delegate = self
        fbLoginButton.loginBehavior = FBSDKLoginBehavior.Browser
        self.view.addSubview(fbLoginButton)
        
        
    }
    
    
    //* - Keyboard notifications and actions
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
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

    
    //* - After successful login, call the Map View Controller with student pins
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }

    
    //* - Report errors to Alert Viewer
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                //* - hide and stop the activity indicator
                self.activityIndicatorView.hidden = true
                self.activityIndicatorView.stopAnimating()
                
                //* - Call Error Alert message
                self.alertMessage = errorString
                self.loginAlertMessage()
            }
        })
    }
    
    
    //* - Udacity Login Button function
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        
        //* - If Udacity Login button is touched, set the Facebook login trigger to FALSE
        self.appDelegate.FBlogin = false
        
        if usernameTextField.text.isEmpty && passwordTextField.text.isEmpty {
            //* - Call Error Alert message
            alertMessage = "Username and Password is missing. Please enter a valid username and password."
            //AlertMessages.sharedInstance().loginAlertMessage2(alertMessage)
            loginAlertMessage()
        } else if usernameTextField.text.isEmpty {
            //* - Call Error Alert message
            alertMessage = "Username is missing. Please enter a valid username."
            loginAlertMessage()
            
        } else if passwordTextField.text.isEmpty {
            //* - Call Error Alert message
            alertMessage = "Password is missing. Please enter a valid password."
            loginAlertMessage()

        } else {
            
            //* - Check to see if you have a network connection before attempting to logon
            if Reachability.isConnectedToNetwork() == false {
                //* - Call Error Alert message
                alertMessage = "Internet Connection Failed."
                loginAlertMessage()
                
            } else {
                //* - Save the username & password to a shared field
                self.appDelegate.username = self.usernameTextField.text
                self.appDelegate.password = self.passwordTextField.text
            
                //* - Show and start the activity indicator
                self.activityIndicatorView.hidden = false
                self.activityIndicatorView.startAnimating()
            
                //* - Call the login APIs
                OTMClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
                    if success {
                        //* - Hide and stop the activity indicator
                        self.activityIndicatorView.hidden = true
                        self.activityIndicatorView.stopAnimating()
                    
                        //*- Launch the Map Scene
                        self.completeLogin()
                    
                    } else {
                        //* - Launch the login error function
                        self.displayError(errorString)
                    }
                }
            }
        }
    }

    
    //* - Facebook Login Button function
    
    func loginButton(fbLoginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil
        {
            //* - If Facebook Login button is touched, set the Facebook login trigger to TRUE
            self.appDelegate.FBlogin = true
            let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
            self.appDelegate.accessToken = accessToken
            
            //* - Show and start the activity indicator
            self.activityIndicatorView.hidden = false
            self.activityIndicatorView.startAnimating()
            
            //* - Call the Facebook Login APIs
            OTMClient.sharedInstance().authenticateFBWithViewController(self) { (success, errorString) in
                if success {
                    //* - Hide and stop the activity indicator
                    self.activityIndicatorView.hidden = true
                    self.activityIndicatorView.stopAnimating()
                    
                    //*- Launch the Map Scene
                    self.completeLogin()
                    
                } else {
                    //* - Launch the login error function
                    self.displayError(errorString)
                }
            }
        }
        else
        {
            //* Display Facebook login error
            alertMessage = error.localizedDescription
            loginAlertMessage()
        }
        
    }
    
    
    //* - Facebook Logout Button function
    func loginButtonDidLogOut(fbLoginButton: FBSDKLoginButton!) {
        self.loginLabel.enabled = true
        alertMessage = "Successfully logged out of Facebook"
        loginAlertMessage()
    }
    
    
    //* - Alert Message function
    func loginAlertMessage(){
        dispatch_async(dispatch_get_main_queue()) {
            let actionSheetController: UIAlertController = UIAlertController(title: "Alert!", message: "\(self.alertMessage)", preferredStyle: .Alert)
            //* - Create and add the OK action
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }
        actionSheetController.addAction(okAction)
            
        //* - Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
    }

    
    //* - If you are don't have a Udacity account, sign up here
    @IBAction func signupButton(sender: UIButton) {
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: "https://www.google.com/url?q=https%3A%2F%2Fwww.udacity.com%2Faccount%2Fauth%23!%2Fsignin&sa=D&sntz=1&usg=AFQjCNERmggdSkRb9MFkqAW_5FgChiCxAQ")!)
    }


    //* ------------------------------------ Keyboard Functions --------------------------------------- *//
    
    //* - Subscribe to Keyboard appearing and hiding notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //* - Move screen up to prevent keyboard overlap
    func keyboardWillShow(notification: NSNotification) {
        if loginLabel.isFirstResponder(){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //* - Move screen back down after done using keyboard
    func keyboardWillHide(notification: NSNotification) {
        if loginLabel.isFirstResponder(){
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




