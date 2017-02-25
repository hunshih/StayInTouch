//
//  printer.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 2/23/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//
import UIKit
import Firebase

class Printer{
    
    class func printUserDetails(_ user: FIRUser)
    {
        print("Anonymous: \(user.isAnonymous)")
        print("Email Verified: \(user.isEmailVerified)")
        print("ProviderId: \(user.providerID)")
        print("UID: \(user.uid)")
        print("Name: \(user.displayName)")
        print("Email: \(user.email)")
    }
    
}
