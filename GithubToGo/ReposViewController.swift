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
    var searchResults: [Repo]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Repo Cell Nib
        let repoCellNib = UINib(nibName: "RepoCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(repoCellNib!, forCellReuseIdentifier: "REPO_CELL")

        self.ghService.requestOAuthAccess()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("REPO_CELL") as RepoCell
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let searchString = searchBar.text.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil) as String
        let resourcePath = "/search/repositories"
        let params = ["q" : searchString]
        self.ghService.fetchRepos(atResourcePath: resourcePath, withParams: params) { (repos, errorMessage) -> Void in
            if let repoResults = repos {
                println(repoResults.count.description)
            }
        }
    }
}
