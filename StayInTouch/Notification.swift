//
//  Notification.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 5/17/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit

class Notification {
    
    var icon: UIImage?;
    var title: String;
    var name: String;
    var link: String;
    var email: String;
    var tag: String;
    var key: String;
    var contactID: String;
    var date: String?;
    var source: String?;
    
    init?(icon: UIImage?, title: String, name: String, link: String, email: String, tag: String, key: String, contact: String, source: String) {
        self.icon = icon;
        self.title = title;
        self.name = name;
        self.link = link;
        self.email = email;
        self.tag = tag;
        self.key = key;
        self.contactID = contact;
        self.source = source;
        if title.isEmpty || name.isEmpty{
            return nil;
        }
    }
    func setDate(date: String)
    {
        self.date = date;
    }
}
