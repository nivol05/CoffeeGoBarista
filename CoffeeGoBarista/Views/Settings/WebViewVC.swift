//
//  WebViewVC.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 1/23/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://coffeego.app/privacy-cookies-policy/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
}

