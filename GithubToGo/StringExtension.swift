//
//  StringExtension.swift
//  GithubToGo
//
//  Created by Casey R White on 10/25/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import Foundation

extension String {
    
    func validate() -> Bool {
        // Must allow \n so that Search button / enter key works
        let regex = NSRegularExpression(pattern: "[^0-9a-zA-Z\n]", options: nil, error: nil)
        let match = regex?.numberOfMatchesInString(self, options: nil, range: NSRange(location: 0, length: countElements(self)))
        
        if match > 0 {
            return false
        }
        return true
    }
}