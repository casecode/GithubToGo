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
        let repo = self.repos[indexPath.row]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' h:mm a" // superset of OP's format
        let dateString = dateFormatter.stringFromDate(repo.last_updated)
        cell.repoNameLabel.text = dateString
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let searchString = searchBar.text.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil) as String
        let resourcePath = "/search/repositories"
        let params = ["q" : searchString]
        self.ghService.fetchRepos(atResourcePath: resourcePath, withParams: params) { (repoResults, errorMessage) -> Void in
            if let searchResults = repoResults {
                self.repos = searchResults
                self.tableView.reloadData()
            }
        }
    }
}
