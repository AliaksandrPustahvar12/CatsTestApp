//
//  WikiView.swift
//  CatsTestApp
//
//  Created by Aliaksandr Pustahvar on 5.09.23.
//

import UIKit
import WebKit

class WikiView: UIViewController {
    
    var webView: WKWebView!
    var url: URL?
       
       override func loadView() {
           webView = WKWebView()
           view = webView
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           if let selectedURL = url {
               let request = URLRequest(url: selectedURL)
               webView.load(request)
           }
    }
}
