//
//  RepoWebViewController.swift
//  GithubToGo
//
//  Created by Casey R White on 10/26/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit
import WebKit

class RepoWebViewController: UIViewController {

    let webView = WKWebView()
    var targetURL: String?
    
    override func loadView() {
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: targetURL!)!))
        
    }

}
