//
//  File.swift
//  WeChat
//
//  Created by Smile on 16/3/2.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

protocol WeChatWebViewProgressDelegate {
    func webViewProgress(webViewProgress:WeChatWebViewProgress,updateProgress progress:CGFloat)
}

class WeChatWebViewProgress:NSObject,UIWebViewDelegate{
    
    var loadingCount:Int = 0
    var maxLoadCount:Int = 0
    var currentUrl:NSURL?
    var interactive:Bool = false
    
    var progressDelegate:WeChatWebViewProgressDelegate?
    var progress:CGFloat = 0
    var progressBlock:WeChatWebViewProgressBlock = WeChatWebViewProgressBlock(progress: 0)
    
    let initialProgressValue:CGFloat = 0.1
    let interactiveProgressValue:CGFloat = 0.5
    let finalProgressValue:CGFloat = 0.9
    var webViewProxyDelegate:UIWebViewDelegate?
    
    
    //MARKS: 开始进度条
    func startProgress(){
        if progress < initialProgressValue {
            self.setProgressing(initialProgressValue)
        }
    }
    
    //MARKS: 进度条增长
    func incrementProgress(){
        if maxLoadCount <= 0{
            return
        }
        var _progress:CGFloat = self.progress
        let maxProgress:CGFloat = self.interactive ? self.finalProgressValue : self.interactiveProgressValue
        let remainPercent:CGFloat = CGFloat(self.loadingCount / self.maxLoadCount)
        let increment:CGFloat = (maxProgress - _progress) * remainPercent
        _progress += increment
        _progress = fmin(_progress, maxProgress)
        self.setProgressing(_progress)
    }
    
    //MARKS: 进度条完成
    func completeProgress(){
        self.setProgressing(1)
    }
    
    //MARKS: 重置属性
    func reset(){
        self.maxLoadCount = 0
        self.loadingCount = 0
        self.interactive = false
        self.setProgressing(0)
    }
    
    func setProgressing(progress:CGFloat){
        if progress > self.progress || self.progress == 0 {
            self.progress = progress
            
            progressDelegate?.webViewProgress(self, updateProgress: self.progress)
            
            progressBlock = WeChatWebViewProgressBlock(progress: self.progress)
        }
    }
    
    
    let completeUrlPath = "/wechatwebviewprogressproxy/complete"//完成标识
   
    //MARKS: 每次加载之前都会调用这个方法,如果返回false，代表不允许加载这个请求
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.URL?.path == self.completeUrlPath {
            self.completeProgress()
            return false
        }
        
        var ret:Bool = true
        
        if self.webViewProxyDelegate!.respondsToSelector(Selector("webView:shouldStartLoadWithRequest:navigationType:")) {
            ret = self.webViewProxyDelegate!.webView!(webView, shouldStartLoadWithRequest: request, navigationType: navigationType)
        }
        
        var isFragmentJump:Bool = false
        
        if request.URL?.fragment != nil {
            let fragmentStr:NSString = "#".stringByAppendingString((request.URL?.fragment)!)
            
            let nonFragmentURL = NSString(string:(request.URL?.absoluteString.stringByReplacingOccurrencesOfString(
                fragmentStr as String,
                withString: ""))!)
            
            isFragmentJump = (nonFragmentURL == request.URL)
        }
        
        let isTopLevelNavigation:Bool = request.mainDocumentURL == request.URL
        
        //协议头
        let isHTTPOrLocalFile = (request.URL?.scheme == "http" || request.URL?.scheme == "https" || request.URL?.scheme == "file")
        
        if ret && !isFragmentJump && isHTTPOrLocalFile && isTopLevelNavigation {
            self.currentUrl = request.URL
            reset()
        }
        
        return ret
    }
    
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        if webViewProxyDelegate!.respondsToSelector(Selector("webView:didFailLoadWithError:")) {
            self.webViewProxyDelegate!.webView!(webView, didFailLoadWithError: error)
        }
        
        if loadingCount > 0 {
            self.incrementProgress()
            self.loadingCount--
        }
        
        let readyState:String = webView.stringByEvaluatingJavaScriptFromString("document.readyState")!
        let _interactive:Bool = (readyState == "interactive")
        
        if _interactive {
            self.interactive = true
            
            let waitForCompleteJS = String(format: "window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", arguments: [webView.request!.mainDocumentURL!.scheme, webView.request!.mainDocumentURL!.host!, completeUrlPath])
            
            webView.stringByEvaluatingJavaScriptFromString(waitForCompleteJS)
            
        }

        let isNotRedirect:Bool = (self.currentUrl != nil ) && (webView.request?.mainDocumentURL != nil) && (self.currentUrl == webView.request?.mainDocumentURL!)
        
        let complete:Bool = (readyState == "complete")
        if ((complete && isNotRedirect) || error != nil) {
            self.completeProgress()
        }
       

    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        if webViewProxyDelegate!.respondsToSelector(Selector("webViewDidStartLoad:")) {
            webViewProxyDelegate!.webViewDidStartLoad!(webView)
        }
        
        
        self.loadingCount++
        self.maxLoadCount = max(self.maxLoadCount,self.loadingCount)
        self.startProgress()

    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if webViewProxyDelegate!.respondsToSelector(Selector("webViewDidFinishLoad:")) {
            self.webViewProxyDelegate!.webViewDidFinishLoad!(webView)
        }
        
        if loadingCount > 0 {
            self.incrementProgress()
            self.loadingCount--
        }
        
        let readyState:String = webView.stringByEvaluatingJavaScriptFromString("document.readyState")!
        let _interactive:Bool = (readyState == "interactive")
        if _interactive {
            self.interactive = true
            
            let waitForCompleteJS = String(format: "window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", arguments: [webView.request!.mainDocumentURL!.scheme, webView.request!.mainDocumentURL!.host!, completeUrlPath])
            
            webView.stringByEvaluatingJavaScriptFromString(waitForCompleteJS)
            
        }
        
        let isNotRedirect:Bool = (self.currentUrl != nil ) && (webView.request?.mainDocumentURL !=  nil) && (self.currentUrl == webView.request?.mainDocumentURL!)
        
        let complete:Bool = (readyState == "complete")
        if complete && isNotRedirect {
            self.completeProgress()
        }
        
    }
}

struct WeChatWebViewProgressBlock {
    var progress:CGFloat = 0
}
