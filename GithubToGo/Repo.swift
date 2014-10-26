//
//  Repo.swift
//  GithubToGo
//
//  Created by Casey R White on 10/20/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class Repo {
    
    let name: String
    let fullName: String
    let htmlURL: String
    let setToPrivate: Bool
    var summary: String = ""
    let createdAt: NSDate
    let lastUpdated: NSDate
    var language: String = "Unknown"
    let owner: User
    
    init(data: NSDictionary) {
        self.name = data["name"] as String
        self.fullName = data["full_name"] as String
        self.htmlURL = data["html_url"] as String
        self.setToPrivate = data["private"] as Bool
        if let repoDesc = data["description"] as? String {
            self.summary = repoDesc
        }
        if let lang = data["language"] as? String {
            self.language = lang
        }
        
        // Set NSDate properties
        let createdAtUnformatted = data["created_at"] as String
        let lastUpdatedUnformatted = data["updated_at"] as String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.createdAt = dateFormatter.dateFromString(createdAtUnformatted)!
        self.lastUpdated = dateFormatter.dateFromString(lastUpdatedUnformatted)!
        
        let ownerData = data["owner"] as NSDictionary
        self.owner = User(data: ownerData)
    }
    
    init(data: NSDictionary, forUser user: User) {
        self.name = data["name"] as String
        self.fullName = data["full_name"] as String
        self.htmlURL = data["html_url"] as String
        self.setToPrivate = data["private"] as Bool
        if let repoDesc = data["description"] as? String {
            self.summary = repoDesc
        }
        if let lang = data["language"] as? String {
            self.language = lang
        }
        
        // Set NSDate properties
        let createdAtUnformatted = data["created_at"] as String
        let lastUpdatedUnformatted = data["updated_at"] as String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.createdAt = dateFormatter.dateFromString(createdAtUnformatted)!
        self.lastUpdated = dateFormatter.dateFromString(lastUpdatedUnformatted)!
        
        self.owner = user
    }
    
}