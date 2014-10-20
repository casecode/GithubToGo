//
//  Repo.swift
//  GithubToGo
//
//  Created by Casey R White on 10/20/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import Foundation

class Repo {
    
    let name: String
    let full_name: String
    let html_url: String
//    let created_at: NSDate
//    let last_updated: NSDate
    let setToPrivate: Bool
    let owner_username: String
    let owner_avatar_url: String
    
    init(data: NSDictionary) {
        self.name = data["name"] as String
        self.full_name = data["full_name"] as String
        self.html_url = data["html_url"] as String
        self.setToPrivate = data["private"] as Bool
        
        let ownerData = data["owner"] as NSDictionary
        self.owner_username = ownerData["login"] as String
        self.owner_avatar_url = ownerData["avatar_url"] as String
    }
    
}