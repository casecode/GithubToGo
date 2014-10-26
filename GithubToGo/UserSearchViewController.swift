//
//  UserSearchViewController.swift
//  GithubToGo
//
//  Created by Casey R White on 10/25/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userSearchBar: UISearchBar!

    let ghService = GithubService.sharedInstance
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.ghService.sessionAuthenticated() {
            println("Session authenticated")
        } else {
            println("Requesting oauth access")
            // Add alert
            self.ghService.requestOAuthAccess()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
        cell.userAvatarImageView.image = nil
        let user = self.users[indexPath.row]
        self.configureCell(cell, atIndexPath: indexPath, withUser: user)
        return cell
    }
    
    // MARK: - SearchBar
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let searchString = searchBar.text.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil) as String
        
        self.fetchUsersWithSearchQuery(searchString)
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return text.validate()
    }
    
    // MARK: - Fetch Users
    func fetchUsersWithSearchQuery(searchQuery: String) {
        let userSearchResourcePath = "/search/users"
        let params = ["q" : searchQuery]
        self.ghService.fetchUsers(atResourcePath: userSearchResourcePath, withParams: params) { (userResults, errorMessage) -> Void in
            
            if let userSearchResults = userResults {
                self.users = userSearchResults
            } else if let error = errorMessage {
                println(error)
            }
            
            self.collectionView.reloadData()
        }
    }
    
    // Configure cell's image and text
    func configureCell(cell: UserCell, atIndexPath indexPath: NSIndexPath, withUser user: User) {
        cell.usernameLabel.text = user.login
        
        // Grab user image for cell
        self.ghService.downloadAvatarForUser(user, completionHandler: { (errorMessage, avatarImage) -> () in
            if let error = errorMessage {
                println(error)
            } else {
                let cellForImage = self.collectionView.cellForItemAtIndexPath(indexPath) as UserCell?
                cellForImage?.userAvatarImageView.image = avatarImage
            }
        })
    }

}
