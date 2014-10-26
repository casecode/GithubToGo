//
//  RepoCell.swift
//  GithubToGo
//
//  Created by Casey R White on 10/21/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {
    
    @IBOutlet weak var repoOwnerImageView: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoOwnerNameLabel: UILabel!
    @IBOutlet weak var repoLastUpdatedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.repoOwnerImageView.layer.cornerRadius = 8.0
        self.repoOwnerImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
