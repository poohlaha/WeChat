//
//  WeChatWebViewLoading.swift
//  WeChat
//
//  Created by Smile on 16/3/2.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//WebView进度条
class WeChatWebViewProgressView: UIView {
    
    var progressBarView:UIView!
    var barAnimationDuration:NSTimeInterval = 0.27
    var fadeAnimationDuration:NSTimeInterval = 0.27
    var fadeOutDelay:NSTimeInterval = 0.1
    //var progressBarColor:UIColor = UIColor(red: 22/255, green: 126/255, blue: 251/255, alpha: 1)// iOS7 Safari bar color
    var progressBarColor:UIColor = UIColor(red: 51/255, green: 153/255, blue: 102/255, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureViews(){
        self.userInteractionEnabled = false
        self.autoresizingMask = .FlexibleWidth
        
        self.progressBarView = UIView(frame: self.bounds)
        self.progressBarView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
        
        let tintColor = progressBarColor
        //tintColor = (UIApplication.sharedApplication().delegate?.window!!.tintColor)!
        self.progressBarView.backgroundColor = tintColor
        self.addSubview(progressBarView)
    }
    
    func setProgress(progress:CGFloat){
        setProgress(progress,animated: false)
    }
    
    func setProgress(progress:CGFloat,animated:Bool){
        let isGrowing:Bool = (progress > 0)
        UIView.animateWithDuration(
            (isGrowing && animated) ? self.barAnimationDuration : 0,
            delay: 0,
            options: .CurveEaseInOut,
            animations: { () -> Void in
                var frame = self.progressBarView.frame
                frame.size.width = progress * self.bounds.size.width
                self.progressBarView.frame = frame
            }) { (Bool) -> Void in
                
        }
        
        if progress >= 1 {
            UIView.animateWithDuration(
                animated ? self.fadeAnimationDuration : 0,
                delay: self.fadeOutDelay,
                options: .CurveEaseInOut,
                animations: { () -> Void in
                    self.progressBarView.alpha = 0
                }, completion: { (Bool) -> Void in
                    var frame = self.progressBarView.frame
                    frame.size.width = 0
                    self.progressBarView.frame = frame
            })
        } else {
            UIView.animateWithDuration(
                animated ? self.fadeAnimationDuration : 0,
                delay: 0,
                options: .CurveEaseInOut,
                animations: { () -> Void in
                    self.progressBarView.alpha = 1
                }, completion: nil)
        }
       
    }
    
   
}
