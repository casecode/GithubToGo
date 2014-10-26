//
//  UsersViewController.swift
//  GithubToGo
//
//  Created by Casey R White on 10/25/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let ghService = GithubService.sharedInstance

    
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
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
        return cell
    }

}
