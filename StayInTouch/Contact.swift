//
//  Contact.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 7/8/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import Foundation

class Contact
{
    var name: String;
    var ID: String;
    
    init?(name: String, id: String) {
        self.name = name;
        self.ID = id;
        if name.isEmpty || id.isEmpty{
            return nil;
        }
    }
}
