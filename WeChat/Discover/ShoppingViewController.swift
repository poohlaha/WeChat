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

/**
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSExceptionDomains</key>
        <dict>
            <key>baidu.com</key>
            <dict>
                <key>NSIncludesSubdomains</key>
                <true/>
                <key>NSExceptionRequiresForwardSecrecy</key>
                <false/>
                <key>NSExceptionAllowsInsecureHTTPLoads</key>
                <true/>
            </dict>
        </dict>
    </dict>
*/
class ShoppingViewController: UIViewController,UIWebViewDelegate,WeChatWebViewProgressDelegate {

    var webView:UIWebView!
    var backgroundView:UIView!
    var topHeight:CGFloat = 0
    var loadingView:UIActivityIndicatorView!//UIActivityIndicatorView
    
    var progressView:WeChatWebViewProgressView!
    var progressProxy:WeChatWebViewProgress!
    var errorLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFrame()
    }
    
    func initFrame(){
        topHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.sharedApplication().statusBarFrame.height
        self.navigationItem.title = "ztyjr888/WeChat"
        
        //修改左侧为"返回"
        self.navigationController!.navigationBar.backItem?.title = "返回"
        
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "shopping-right-normal"), style: .Plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        initWebViewFrame()
        initBackgroundView()
        loadProgress()
        initBtns()
    }
    
    //MARKS: 右侧按钮点击事件
    func rightBarClick(){
        
    }
    
    //MARKS: 初始化buttons
    func initBtns(){
        //self.navigationItem.backBarButtonItem?.enabled = self.webView.canGoBack
    }
    
    //MARKS: 加载进度条
    func loadProgress(){
        self.progressProxy = WeChatWebViewProgress()
        self.webView.delegate = self.progressProxy
        self.progressProxy.webViewProxyDelegate = self
        self.progressProxy.progressDelegate = self
        
        let progressBarHeight:CGFloat = 3
        let navigationBarBounds = self.navigationController?.navigationBar.bounds
        let barFrame = CGRectMake(0, navigationBarBounds!.size.height - progressBarHeight / 2, navigationBarBounds!.size.width, progressBarHeight)
        
        self.progressView = WeChatWebViewProgressView(frame: barFrame)
        self.progressView.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]

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
        //let url = NSURL(string: "https://github.com/ztyjr888/WeChat")
        //let url = NSURL(string: "https://wq.jd.com")
        let url = NSURL(string: "https://m.taobao.com")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        webView.opaque = false//webView是否是不透明的，false为透明
        webView.backgroundColor = UIColor.darkGrayColor()
        
        let label = UILabel(frame: CGRectMake(0,10,self.view.bounds.width,20))
        label.text = "网页由 wq.jd.com 提供"
        label.textColor = UIColor.lightGrayColor()
        label.font = UIFont(name: "Arial", size: 12)
        label.textAlignment = .Center
        
        webView.insertSubview(label, belowSubview: webView.scrollView)
        self.view.addSubview(webView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.addSubview(self.progressView)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.progressView.removeFromSuperview()
    }
    
    func webViewProgress(webViewProgress: WeChatWebViewProgress, updateProgress progress: CGFloat) {
        self.progressView.setProgress(progress,animated: true)
        
        //self.navigationItem.title = self.webView.stringByEvaluatingJavaScriptFromString("document.title")
    }
    
    func initErrorLabel(){
        if errorLabel == nil {
            let errorLabelWidth:CGFloat = 30
            let beginY:CGFloat = (self.backgroundView.frame.height - topHeight - errorLabelWidth) / 2
            errorLabel = UILabel(frame: CGRectMake(0,beginY,self.view.bounds.width,errorLabelWidth))
            errorLabel!.text = "网页信息无法加载,请稍后重试!"
            errorLabel!.textColor = UIColor.lightGrayColor()
            errorLabel!.font = UIFont(name: "Arial", size: 16)
            errorLabel!.textAlignment = .Center
        }
    }
    
    
    //MARKS: webView加载失败
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
         initErrorLabel()
         self.backgroundView.addSubview(errorLabel!)
         self.view.addSubview(backgroundView)
    }
    
    //MARKS: webView加载完成
    func webViewDidFinishLoad(webView: UIWebView) {
        self.backgroundView.removeFromSuperview()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "shopping-right"), style: .Plain, target: self, action: "rightBarClick")
    }
    
    //MARKS: webView开始加载
    func webViewDidStartLoad(webView: UIWebView) {
        
    }
    
}
