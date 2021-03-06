//
//  GithubService.swift
//  GithubToGo
//
//  Created by Casey R White on 10/20/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class GithubService {
    
    class var sharedInstance : GithubService {
        struct Static {
            static let instance : GithubService = GithubService()
        }
        return Static.instance
    }
    
    let apiURL = "https://api.github.com"
    let clientID = "client_id=5ea1a02e038fcbe67b93"
    let clientSecret = "client_secret=d2935c2b120db0495e88dfb528b0744ad456a978"
    let githubOAuthURL = "https://github.com/login/oauth/authorize?"
    let scope = "scope=user,repo"
    let redirectURL = "redirect_uri=githubtogo://path"
    let githubPOSTURL = "https://github.com/login/oauth/access_token"
    let tokenKey = "GithubAccessToken"
    
    var authenticatedSession: NSURLSession!
    let imageQueue = NSOperationQueue()
    var imageCache = [Int : UIImage]()
    
    func sessionAuthenticated() -> Bool {
        if self.authenticatedSession != nil {
            return true
        } else if let token = self.retrieveStoredToken() {
            self.configureAuthenticatedSessionWithToken(token)
            return true
        } else {
            return false
        }
    }
    
    // MARK: - OAuth
    func requestOAuthAccess() {
        let url = githubOAuthURL + clientID + "&" + redirectURL + "&" + scope
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    func handleOAuthURL(callbackURL : NSURL) {
        // Parse callbackURL from Github
        let query = callbackURL.query
        let components = query?.componentsSeparatedByString("code=")
        let code = components?.last

        // Construct query for final POST request
        let urlQuery = clientID + "&" + clientSecret + "&" + "code=\(code!)"
        var request = NSMutableURLRequest(URL: NSURL(string: githubPOSTURL)!)
        request.HTTPMethod = "POST"
        let postData = urlQuery.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        let length = postData!.length
        request.setValue("\(length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        
        let dataTask: Void = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                println("Hello this is an error")
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...204:
                        let tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
                        let components = tokenResponse?.componentsSeparatedByString("&")
                        let accessToken = components?.first as? String
                        let accessTokenComponents = accessToken?.componentsSeparatedByString("access_token=")
                        let token = accessTokenComponents?.last
                        
                        NSUserDefaults.standardUserDefaults().setObject(token!, forKey: self.tokenKey)
                        NSUserDefaults.standardUserDefaults().synchronize()
                        self.configureAuthenticatedSessionWithToken(token!)
                    default:
                        println("Token request failed")
                    }
                }
            }
        }).resume()
    }
    
    func retrieveStoredToken() -> String? {
        if let token = NSUserDefaults.standardUserDefaults().valueForKey(self.tokenKey) as? String {
            return token
        } else {
            return nil
        }
    }
    
    func configureAuthenticatedSessionWithToken(token: String) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = ["Authorization" : "token \(token)"]
        self.authenticatedSession = NSURLSession(configuration: configuration)
    }
    
    // MARK: - Fetch Requests
    func fetchRepos(atResourcePath path: String?, withParams params: [String : String]?, forUser user: User?, completionHandler completion: (repoResults: [Repo]?, errorMessage: String?) -> Void) {
        
        let url = self.buildURL(resourcePath: path, withParams: params)
        
        let dataTask: Void = self.authenticatedSession.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            var repos: [Repo]?
            var errorMessage: String?
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if error == nil {
                    switch httpResponse.statusCode {
                    case 200...299:
                        if let requestedUser = user {
                            if let repoObjects = self.parseJSONDataIntoUserRepos(data, forUser: requestedUser) {
                                repos = repoObjects
                            } else {
                                errorMessage = "Unable to parse JSON data"
                            }
                        } else {
                            if let repoObjects = self.parseJSONDataIntoRepos(data) {
                                repos = repoObjects
                            } else {
                                errorMessage = "Unable to parse JSON data"
                            }
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
                errorMessage = "Request unsuccessful"
            }

            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completion(repoResults: repos, errorMessage: errorMessage)
            })
        }).resume()
    }

    func fetchUsers(atResourcePath path: String?, withParams params: [String : String]?, completionHandler completion: (userResults: [User]?, errorMessage: String?) -> Void) {
        
        let url = self.buildURL(resourcePath: path, withParams: params)
        
        let dataTask: Void = self.authenticatedSession.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            var users: [User]?
            var errorMessage: String?
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if error == nil {
                    switch httpResponse.statusCode {
                    case 200...299:
                        if let userObjects = self.parseJSONDataIntoUsers(data) {
                            users = userObjects
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
                errorMessage = "Request unsuccessful"
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completion(userResults: users, errorMessage: errorMessage)
            })
        }).resume()
    }
    
    func buildURL(resourcePath path: String?, withParams params: [String : String]?) -> NSURL {
        var builtUrl = self.apiURL
        if let resourcePath = path {
            builtUrl += resourcePath
        }
        
        if let queryParams = params {
            builtUrl += "?"
            let paramCount = queryParams.count
            var i = 0
            for (k,v) in queryParams {
                ++i
                builtUrl += "\(k)=\(v)"
                if i < paramCount {
                    builtUrl += "&"
                }
            }
        }
        
        println(builtUrl)
        let url = NSURL(string: builtUrl)
        return url!
    }
    
    // MARK: - JSON Response Parsing
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
    
    func parseJSONDataIntoUserRepos(rawData: NSData, forUser user: User) -> [Repo]? {
        var error: NSError?
        if let data = NSJSONSerialization.JSONObjectWithData(rawData, options: nil, error: &error) as? NSArray {
            var repos = [Repo]()
            
            for item in data {
                if let userRepo = item as? NSDictionary {
                    let newRepo = Repo(data: userRepo, forUser: user)
                    repos.append(newRepo)
                }
            }

            
            return repos
            
        } else {
            return nil
        }
    }
    
    func parseJSONDataIntoUsers(rawData: NSData) -> [User]? {
        var error: NSError?
        if let data = NSJSONSerialization.JSONObjectWithData(rawData, options: nil, error: &error) as? NSDictionary {
            var users = [User]()
            
            if let userItems = data["items"] as? NSArray {
                for userItem in userItems {
                    if let userData = userItem as? NSDictionary {
                        let newUser = User(data: userData)
                        users.append(newUser)
                    }
                }
            }
            
            return users
            
        } else {
            return nil
        }
    }
    
    func downloadAvatarForUser(user: User, completionHandler: (errorMessage: String?, avatarImage: UIImage?) -> ()) {
        
        self.imageQueue.addOperationWithBlock { () -> Void in
            var errorMessage: String?
            // If user already has image, use that image
            if let avatar = user.avatarImage
            {
                println("Using image from user")
            }
                // If image already in cache, do not download again
            else if let avatar = self.imageCache[user.id]
            {
                println("Using image from image cache")
                user.avatarImage = avatar
            }
                // Otherwise, download image
            else
            {
                println("Downloading image")
                
                let url = NSURL(string: user.avatarURL)
                let imageData = NSData(contentsOfURL: url!)
                
                if imageData!.length > 0 {
                    user.avatarImage = UIImage(data: imageData!)
                    self.imageCache[user.id] = user.avatarImage
                } else {
                    errorMessage = "No image found"
                }
            }
            // Resolve completion handler on main queue
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(errorMessage: errorMessage, avatarImage: user.avatarImage)
            })
        }
    }

}