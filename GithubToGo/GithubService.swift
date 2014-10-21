//
//  GithubService.swift
//  GithubToGo
//
//  Created by Casey R White on 10/20/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import Foundation

class GithubService {
    
    class var sharedInstance : GithubService {
        struct Static {
            static let instance : GithubService = GithubService()
        }
        return Static.instance
    }
    
    func fetchRepos(#urlString: String, queryParams: [String : String]?, completionHandler completion: (repos: [Repo]?, errorMessage: String?) -> Void) {
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

            var repos: [Repo]?
            var errorMessage: String?
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if error == nil {
                    switch httpResponse.statusCode {
                    case 200...299:
                        if let repoObjects = self.parseJSONDataIntoRepos(data) {
                            repos = repoObjects
                        } else {
                            errorMessage = "Unable to parse JSON data"
                        }
                    case 400...499:
                        errorMessage = "Bad request"
                    case 500...599:
                        errorMessage = "Server error"
                    default:
                        errorMessage = "Unknown error"
                    }
                } else {
                    errorMessage = "ERROR: \(error.localizedDescription as String)"
                }
            } else {
                errorMessage = "Reqest unsuccesful"
            }

            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completion(repos: repos, errorMessage: errorMessage)
            })
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