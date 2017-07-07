//
//  Notification.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 5/17/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import UIKit

class Notification {
    
    var read: Bool;
    var icon: UIImage?;
    var title: String;
    var name: String;
    var link: String;
    var email: String;
    var tag: String;
    var key: String;
    
    init?(read: Bool, icon: UIImage?, title: String, name: String, link: String, email: String, tag: String, key: String) {
        self.read = read;
        self.icon = icon;
        self.title = title;
        self.name = name;
        self.link = link;
        self.email = email;
        self.tag = tag;
        self.key = key;
        if title.isEmpty || name.isEmpty{
            return nil;
        }
    }
}
