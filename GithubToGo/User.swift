//
//  User.swift
//  GithubToGo
//
//  Created by Casey R White on 10/25/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class User {

    let id: Int
    let login: String
    let reposURL: String
    let avatarURL: String
    var avatarImage: UIImage?
    
    init(data: NSDictionary) {
        self.id = data["id"] as Int
        self.login = data["login"] as String
        self.reposURL = data["repos_url"] as String
        self.avatarURL = data["avatar_url"] as String
    }
}