//
//  CustomButton1.swift
//  OnTheMap
//
//  Created by George Potosky on 6/24/15.
//  Copyright (c) 2015 GeoWorld. All rights reserved.
//

import Foundation
import UIKit

//* - Create customer button
class CustomButton1: UIButton {
    required init(coder Decoder: NSCoder) {
        super.init(coder: Decoder)
        let myNewColor = UIColor(red:0.0,green:0.5,blue:0.8,alpha:1.0)
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = myNewColor.CGColor
        self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor.whiteColor()
        self.tintColor = myNewColor
    }
}
