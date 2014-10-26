//
//  UserRepoCell.swift
//  GithubToGo
//
//  Created by Casey R White on 10/26/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class UserRepoCell: UITableViewCell {
    
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoLanguageLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var repoLastUpdatedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
