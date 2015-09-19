//
//  WebViewController.swift
//  OnTheMap
//
//  Created by George Potosky on 7/12/15.
//  Copyright (c) 2015 GeoWorld. All rights reserved.
//

import Foundation
import UIKit

//* - Web Viewer Scene

class WebViewController: UIViewController, UIWebViewDelegate {
    
    //* - Web View Outlets
    @IBOutlet weak var webView: UIWebView!
    
    //* - Web View global variables
    var urlRequest: NSURLRequest? = nil

    
    //* - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //* - Initialize the webview
        webView.delegate = self
        
    }

    
    //* - Show the web page
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
            //* - Call webview with URL
            self.webView.loadRequest(self.urlRequest!)
    }
    
    
    //* - Cancel the Web View
    
    @IBAction func cancelWebView(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
