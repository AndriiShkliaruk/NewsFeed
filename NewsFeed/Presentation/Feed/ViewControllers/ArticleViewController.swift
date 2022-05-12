//
//  ArticleViewController.swift
//  NewsFeed
//
//  Created by Andrii Shkliaruk on 12.05.2022.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController, Storyboarded {
    @IBOutlet private weak var webView: WKWebView!
    var url: URL?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let url = url else { return }
        webView.load(URLRequest(url: url))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.stopLoading()
    }
}
