//
//  InitialsUtil.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 8/13/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import Foundation
import UIKit

extension Character {
    var asciiValue: Int {
        get {
            let s = String(self).unicodeScalars
            return Int(s[s.startIndex].value)
        }
    }
}

class InitialsUtil{
    static func generateColor(name: String) -> UIColor {
        let nameArr : [String] = name.components(separatedBy: " ");
        var firstChar = 0;
        var secondChar = 0;
        if(nameArr.count == 1)
        {
            let first = nameArr[0].characters.first;
            firstChar = (first?.asciiValue)!;
            print("first char hash to \(firstChar)");
        }
        else if(nameArr.count == 2)
        {
            let first = nameArr[0].characters.first;
            firstChar = (first?.asciiValue)!;
            print("first char hash to \(firstChar)");
            let second = nameArr[1].characters.first;
            secondChar = (second?.asciiValue)!;
            print("second char hash to \(secondChar)");
        }
        let fFirst = Float(firstChar);
        let fSecond = Float(secondChar);
        let red = ((fFirst * 10).truncatingRemainder(dividingBy: 255.0))/255.0;
        let green = ((fFirst * fSecond * 10).truncatingRemainder(dividingBy: 255.0))/255.0;
        let blue = ((fSecond * 10).truncatingRemainder(dividingBy: 255.0))/255.0;
        print("Name is: \(name)");
        print("RGB:(\(red),\(green),\(blue))");
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0);
    }
}
