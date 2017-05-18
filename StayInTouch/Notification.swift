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
    
    init?(read: Bool, icon: UIImage?, title: String, name: String) {
        self.read = read;
        self.icon = icon;
        self.title = title;
        self.name = name;
        if title.isEmpty || name.isEmpty{
            return nil;
        }
    }
}
