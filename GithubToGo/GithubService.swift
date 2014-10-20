//
//  GithubService.swift
//  GithubToGo
//
//  Created by Casey R White on 10/20/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import Foundation

class GithubService {
    
    func fetchRepos(#urlString: String, queryParams: [String : String]?) {
        var builtUrl = urlString
        if let params = queryParams {
            builtUrl += "?"
            for (k,v) in params {
                builtUrl += "\(k)=\(v)"
            }
        }
        let url = NSURL(string: builtUrl)
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            println("some response")
        })
    }
}