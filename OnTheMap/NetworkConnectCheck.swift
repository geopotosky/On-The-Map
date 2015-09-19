//
//  NetworkConnectCheck.swift
//  OnTheMap
//
//  Created by George Potosky on 7/7/15.
//  Copyright (c) 2015 GeoWorld. All rights reserved.
//

import Foundation
public class Reachability {
    
    //* - Run a URL check against google.com to see if you have network connectivity
    class func isConnectedToNetwork()->Bool{
        
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {  //* - 200 response = OK
                Status = true
            }
        }
        
        return Status
    }
}
