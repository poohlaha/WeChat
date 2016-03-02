//
//  ShoppingViewController.swift
//  WeChat
//
//  Created by Smile on 16/3/2.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//购物页面

/**
    在info.plist中添加
    <plist>
        <dict>
        ....
            <key>NSAppTransportSecurity</key>
            <dict>
                <key>NSAllowsArbitraryLoads</key>
                <true/>
            </dict>
        </dict>
    </plist>
*/
class ShoppingViewController: UIViewController,UIWebViewDelegate {

    var webView:UIWebView!
    var backgroundView:UIView!
    var topHeight:CGFloat = 0
    var loadingView:UIActivityIndicatorView!//UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFrame()
    }
    
    func initFrame(){
        topHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.sharedApplication().statusBarFrame.height
        self.navigationItem.title = "ztyjr888/WeChat"
        
        initWebViewFrame()
        initBackgroundView()
        initLoadingView()
    }
    
    //MARKS: 加载进度条
    func initLoadingView(){
        loadingView = UIActivityIndicatorView(frame: CGRectMake(0,topHeight,32,32))
        loadingView.center = self.backgroundView.center
        loadingView.activityIndicatorViewStyle = .Gray
        backgroundView.addSubview(loadingView)
    }
    
    //MARKS: 初始化背景view
    func initBackgroundView(){
        backgroundView = UIView(frame: self.webView.frame)
        backgroundView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(backgroundView)
        
        initLoadingView()
    }
    
    //MARKS: 初始化WebView
    func initWebViewFrame(){
        webView = UIWebView(frame: CGRectMake(0,topHeight,self.view.bounds.width,self.view.bounds.height))
        let url = NSURL(string: "https://github.com/ztyjr888/WeChat")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        webView.opaque = false//webView是否是不透明的，false为透明
        webView.backgroundColor = UIColor.darkGrayColor()
        webView.delegate = self
        
        let label = UILabel(frame: CGRectMake(0,10,self.view.bounds.width,20))
        label.text = "网页由 github.com 提供"
        label.textColor = UIColor.lightGrayColor()
        label.font = UIFont(name: "Arial", size: 12)
        label.textAlignment = .Center
        
        webView.insertSubview(label, belowSubview: webView.scrollView)
        self.view.addSubview(webView)
    }
    
    //MARKS: webView加载失败
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
    }
    
    //MARKS: webView加载完成
    func webViewDidFinishLoad(webView: UIWebView) {
        self.backgroundView.removeFromSuperview()
    }
    
    //MARKS: webView开始加载
    func webViewDidStartLoad(webView: UIWebView) {
    }
    
}
