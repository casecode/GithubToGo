//
//  NSDateExtension.swift
//  GithubToGo
//
//  Created by Casey R White on 10/25/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import Foundation

extension NSDate {
    
    func convertToStringWithFormat(format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
}