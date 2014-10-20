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
        println("HELLO")
        var builtUrl = urlString
        if let params = queryParams {
            builtUrl += "?"
            for (k,v) in params {
                builtUrl += "\(k)=\(v)"
            }
        }
        
        println(builtUrl)
        
        let url = NSURL(string: builtUrl)
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if let repos = self.parseJSONDataIntoRepos(data) {
                for repo in repos {
                    println(repo.full_name)
                }
            }
        })
        
        dataTask.resume()
    }
    
    func parseJSONDataIntoRepos(rawData: NSData) -> [Repo]? {
        var error: NSError?
        if let data = NSJSONSerialization.JSONObjectWithData(rawData, options: nil, error: &error) as? NSDictionary {
            var repos = [Repo]()
            
            if let repoItems = data["items"] as? NSArray {
                for repoItem in repoItems {
                    if let repoData = repoItem as? NSDictionary {
                        let newRepo = Repo(data: repoData)
                        repos.append(newRepo)
                    }
                }
            }
            
            return repos
            
        } else {
            return nil
        }
    }
}