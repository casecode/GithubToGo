//
//  ReposViewController.swift
//  GithubToGo
//
//  Created by Casey R White on 10/20/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class ReposViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Repo Cell Nib
        let repoCellNib = UINib(nibName: "RepoCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(repoCellNib!, forCellReuseIdentifier: "REPO_CELL")

        let url = "http://127.0.0.1:3000"
        let ghService = GithubService.sharedInstance

        ghService.fetchRepos(urlString: url, queryParams: nil) { (repos, errorMessage) -> Void in
            if errorMessage == nil {
                println("Fetch Successful")
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("REPO_CELL") as RepoCell
        return cell
    }
}
