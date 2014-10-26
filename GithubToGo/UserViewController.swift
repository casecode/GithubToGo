//
//  UserViewController.swift
//  GithubToGo
//
//  Created by Casey R White on 10/25/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let avatar = self.user?.avatarImage {
            self.userAvatarImageView.image = avatar
        }
    }

}
