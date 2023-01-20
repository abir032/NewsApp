//
//  WebView.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 16/1/23.
//

import UIKit
import WebKit
class WebView: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var url = " "
    @IBOutlet weak var showIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
    }
    func loadWebView(){
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            if webView.isLoading {
                showIndicator.startAnimating()
                showIndicator.isHidden = false
                
            }else {
                showIndicator.stopAnimating()
                showIndicator.isHidden = true
                
            }
            
        }
        
    }
    
}
