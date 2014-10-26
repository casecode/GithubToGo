//
//  UserViewController.swift
//  GithubToGo
//
//  Created by Casey R White on 10/25/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    var userResourcePath: String?
    var repos = [Repo]()
    let ghService = GithubService.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTableViewDisplayOptions()
        
        self.userAvatarImageView.layer.cornerRadius = 8.0
        self.userAvatarImageView.clipsToBounds = true
        
        if let userToDisplay = self.user {
            self.userAvatarImageView.image = userToDisplay.avatarImage!
            self.title = userToDisplay.login
        }
        
        self.fetchUserRepos()
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("USER_REPO_CELL") as UserRepoCell
        let repo = self.repos[indexPath.row]
        self.configureCell(cell, atIndexPath: indexPath, withRepo: repo)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let repo = self.repos[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let repoWebVC = storyboard.instantiateViewControllerWithIdentifier("REPO_WEBVIEW_VC") as RepoWebViewController
        repoWebVC.targetURL = repo.htmlURL
        self.navigationController?.pushViewController(repoWebVC, animated: true)
    }
    
    // MARK: - Repo Fetch
    func fetchUserRepos() {
        self.ghService.fetchRepos(atResourcePath: self.userResourcePath!, withParams: nil, forUser: self.user!) { (repoResults, errorMessage) -> Void in
            
            if let repoSearchResults = repoResults {
                self.repos = repoSearchResults
            } else if let error = errorMessage {
                println(error)
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - TableView Configuration
    func setTableViewDisplayOptions() {
        // Self sizing cells
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // Configure cell's image and text
    func configureCell(cell: UserRepoCell, atIndexPath indexPath: NSIndexPath, withRepo repo: Repo) {
        cell.repoNameLabel.text = repo.name
        cell.repoLanguageLabel.text = repo.language
        cell.repoDescriptionLabel.text = repo.summary

        let dateDisplayFormat = "MM/dd/yyyy 'at' h:mm a"
        cell.repoLastUpdatedLabel.text = repo.lastUpdated.convertToStringWithFormat(dateDisplayFormat)
    }


}
