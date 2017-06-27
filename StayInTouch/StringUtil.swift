//
//  StringUtil.swift
//  StayInTouch
//
//  Created by Hung-Yuan Shih on 4/8/17.
//  Copyright © 2017 Hung-Yuan Shih. All rights reserved.
//

import Foundation

class StringUtil {
    static func trim(_ input: String) -> String{
        var result = StringUtil.trimKeepCase(input);
        result = result.lowercased();
        return result;
    }
    static func trimKeepCase(_ input: String) -> String{
        return input.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines);
    }
}
