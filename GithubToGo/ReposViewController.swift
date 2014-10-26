//
//  ReposViewController.swift
//  GithubToGo
//
//  Created by Casey R White on 10/20/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class ReposViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var repoSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let ghService = GithubService.sharedInstance
    var repos = [Repo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Repo Cell Nib
        let repoCellNib = UINib(nibName: "RepoCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(repoCellNib!, forCellReuseIdentifier: "REPO_CELL")
        
        if self.ghService.sessionAuthenticated() {
            println("Session authenticated")
        } else {
            println("Requesting oauth access")
            // Add alert
            self.ghService.requestOAuthAccess()
        }
        
        self.tableView.dataSource = self
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("REPO_CELL") as RepoCell
        cell.repoOwnerImageView.image = nil
        let repo = self.repos[indexPath.row]
        self.configureCell(cell, atIndexPath: indexPath, withRepo: repo)
        return cell
    }
    
    // Mark: - SearchBar
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let searchString = searchBar.text.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil) as String
        
        // Set display options for tableView and fetch repos
        setTableViewDisplayOptions()
        self.fetchReposWithSearchQuery(searchString)
    }
    
    func fetchReposWithSearchQuery(searchQuery: String) {
        let repoSearchResourcePath = "/search/repositories"
        let params = ["q" : searchQuery]
        self.ghService.fetchRepos(atResourcePath: repoSearchResourcePath, withParams: params) { (repoResults, errorMessage) -> Void in
            
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
        self.tableView.rowHeight = 100.0
    }
    
    // Configure cell's image and text
    func configureCell(cell: RepoCell, atIndexPath indexPath: NSIndexPath, withRepo repo: Repo) {
        cell.repoNameLabel.text = repo.name
        cell.repoOwnerNameLabel.text = repo.ownerUsername
        cell.repoLastUpdatedLabel.text = self.convertDateToString(repo.lastUpdated)
        
        // Grab owner image for cell
        self.ghService.downloadOwnerAvatarForRepo(repo, completionHandler: { (errorMessage, avatarImage) -> () in
            if let error = errorMessage {
                println(error)
            } else {
                let cellForImage = self.tableView.cellForRowAtIndexPath(indexPath) as RepoCell?
                cellForImage?.repoOwnerImageView.image = avatarImage
            }
        })
    }
    
    func convertDateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy 'at' h:mm a"
        return dateFormatter.stringFromDate(date)
    }
}
