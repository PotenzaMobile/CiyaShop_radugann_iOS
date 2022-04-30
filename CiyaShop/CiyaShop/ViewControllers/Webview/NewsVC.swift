//
//  NewsVC.swift
//  CiyaShop
//
//  Created by Apple on 30/04/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit
import WebKit

class NewsVC: UIViewController,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate  {
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var wkWebView: WKWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setThemeColors()
        setupWebview()
        // Do any additional setup after loading the view.
    }

    // MARK: - Themes Methods
    func setThemeColors() {
        self.view.setBackgroundColor()
        
        
        self.lblHeaderTitle.textColor = secondaryColor
        btnBack.tintColor =  secondaryColor
    }
    
    // MARK: - Webview Methods
    func setupWebview() {
        //Webview
        wkWebView.allowsBackForwardNavigationGestures = true
        wkWebView.scrollView.bouncesZoom = false
        wkWebView.scrollView.delegate = self
        wkWebView.navigationDelegate = self
        
        
        //Reuest loading
        let requestUrl = URL(string: "https://shop.radugann.com/novosti/")

        print("webview url - ","https://shop.radugann.com/novosti/")
        var request = NSMutableURLRequest(url: requestUrl!,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 5);
      
        request = NSMutableURLRequest(url: requestUrl!,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 5)
        
        
        wkWebView.load(request as URLRequest)

        
    }
    
    
    // MARK: - WKWebView Delegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoader()
        wkWebView.evaluateJavaScript("javascript:(function() { " +
                           "var head = document.getElementsByClassName('main-header-bar-wrap')[0].style.display='none'; " +
                           "})()");

        wkWebView.evaluateJavaScript("javascript:(function() { " +
                           "var foot = document.getElementsByClassName('hfe-before-footer-wrap')[0].style.display='none'; " +
                           "})()");

        wkWebView.evaluateJavaScript("javascript:(function() { " +
                           "var foot2 = document.getElementsByClassName('site-footer')[0].style.display='none'; " +
                           "})()");
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        hideLoader()
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let javaScript = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);"
        wkWebView.evaluateJavaScript(javaScript, completionHandler: nil)
    }
    //MARK:- Other redirection methods
    func redirectToOrderSuccess() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            DispatchQueue.main.async {
                hideLoader()
                removeAllFromCart()
                
                
            }
        }
    }
    // MARK: - Button Clicked
    
    @IBAction func btnBackClicked(_ sender: Any) {
        
        if wkWebView.canGoBack {
            wkWebView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
