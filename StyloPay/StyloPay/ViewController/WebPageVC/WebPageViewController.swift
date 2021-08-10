//
//  WebPageViewController.swift
//  StyloPay
//
//  Created by Anmol Aggarwal on 19/08/19.
//  Copyright © 2019 Anmol Aggarwal. All rights reserved.
//

import UIKit
import WebKit

class WebPageViewController: UIViewController {
     // MARK: - StoryBoard Instance
    static func storyboardInstance() -> WebPageViewController {
        return Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: String.className(self)) as! WebPageViewController
    }
    
    // MARK: - Outlets and reference of UI Components
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var webViewKit: WKWebView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet var mainView: UIView!
    // MARK: - Other Variables
    var isSideMenu  = true
    var strUrl = "https://stylopay.com/privacy.html"
    let theme = ThemeManager.currentTheme()
    
    // MARK: - LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTheme()
        webViewKit.uiDelegate = self
        webViewKit.navigationDelegate = self

        if let url = URL(string: strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)   {
            let request = URLRequest(url: url as URL)
            webViewKit.load(request)
            webViewKit.contentMode = .scaleAspectFill
        }
    }
    
    func configureTheme(){
        mainView.backgroundColor = theme.backgroundColor
        backgroundImageView.isHidden = theme.backgroundImageHidden
        backButton.setImage(theme.backImage, for: .normal)
        
    }
    // MARK: - Button Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - WebKit UI and Navigation Delegate Methods
extension WebPageViewController:WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation:
        WKNavigation!) {
        self.activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation
        navigation: WKNavigation!) {
        self.activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    func webView(_ webView: WKWebView, didFail navigation:
        WKNavigation!, withError error: Error) {
        self.activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
