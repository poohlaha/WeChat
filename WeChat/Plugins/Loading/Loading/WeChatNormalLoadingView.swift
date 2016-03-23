//
//  WeChatNormalLoadingView.swift
//  WeChat
//
//  Created by Smile on 16/3/21.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//
import UIKit

//加载动画,使用UIActivityIndicatorView活动指示器
class WeChatNormalLoadingView: UIView {
    
    var label:UILabel?
    var indicatorview:UIActivityIndicatorView!
    var labelText:String?
    var topOrBottomPadding:CGFloat = 10
    
    init(frame:CGRect,labelText:String?){
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.darkGrayColor()
        self.alpha = 0.8
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        if labelText != nil {
            self.labelText = labelText
        }
        
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARKS: 初始化view
    func initView(){
        indicatorview = UIActivityIndicatorView()
        if self.labelText != nil {
            self.indicatorview.frame = CGRectMake(0, topOrBottomPadding, self.frame.width, self.frame.height * (2 / 3) - topOrBottomPadding)
        }else{
            self.indicatorview.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        }
        
        indicatorview.startAnimating()
        indicatorview.activityIndicatorViewStyle = .WhiteLarge
        self.addSubview(indicatorview)
        
        if self.labelText != nil {
            let label = UILabel()
            let labelHeight:CGFloat = self.frame.height * (1 / 3)
            label.frame = CGRectMake(0, self.frame.height - labelHeight - topOrBottomPadding, self.frame.width, labelHeight)
            label.text = self.labelText!
            label.textColor = UIColor.whiteColor()
            label.font = UIFont(name: "AlNile", size: 15)
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = .Center
            self.addSubview(label)
        }
    }

}
