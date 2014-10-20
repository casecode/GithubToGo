//
//  ReposViewController.swift
//  GithubToGo
//
//  Created by Casey R White on 10/20/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class ReposViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = "http://127.0.0.1:3000"
        let ghService = GithubService()
        ghService.fetchRepos(urlString: url, queryParams: nil)
    }

}
