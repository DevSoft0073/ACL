
//
//  NewsDetailViewController.swift
//  ACL
//
//  Created by Gagandeep on 27/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailViewController: BaseViewController {

    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var banner: UIImageView!
    
    @IBOutlet weak var descTextView: UITextView!
    var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         font-family:
//        print("here is ui fonts",UIFont.familyNames)
//        <style> body { font-size: 80%; font-family: Roboto-Bold;} </style>
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        </head>
        <body>
        \(news?.newsDescription?.string ?? "")
        </body>
        </html>
        """
        let aux = "<span style=\"font-family: Roboto; font-size: 16px\">\(html)</span>"

        
//        webView.loadHTMLString(aux, baseURL: Bundle.main.bundleURL)
        
        if let imageName = news?.banner {
            banner.sd_setImage(with: URL(string: imageName), placeholderImage: UIImage(named: "NewsBanner"))
        }
        self.webView.isHidden = true
        self.descTextView.isHidden = false
       
        self.descTextView.text = news?.newsDescription?.string
        
    }
    
    override func viewWillLayoutSubviews() {
       // bottomView.applyGradient(colours: [AppTheme.darkPurple, AppTheme.megenta])
    }
    
    @IBAction func Backction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
