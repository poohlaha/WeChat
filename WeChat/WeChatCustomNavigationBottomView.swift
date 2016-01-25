//
//  WeChatCustomNavigationBottomView.swift
//  WeChat
//
//  Created by Smile on 16/1/21.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义导航条底部
class WeChatCustomNavigationBottomView {

    var isLayedOut:Bool = false
    
    var labelText:String?
    var labelView:UIView?
    var bottomView:UIView!
    var labelHeight:CGFloat = 0
    var bottomHeight:CGFloat = 40
    
    func initData(text:String?){
        if text != nil {
            if !text!.isEmpty{
                self.labelText = text
            }
        }
        
        createLabel()
    }
    
    func createLabel(){
        if self.labelText != nil {
            if !self.labelText!.isEmpty {
                labelView = WeChatNavigationBottomLabelView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height - labelHeight - bottomHeight, UIScreen.mainScreen().bounds.width, labelHeight), text: self.labelText!,bgColor:UIColor.blackColor(),bottomHeight:bottomHeight)
               self.labelHeight = labelView!.frame.height
            }
        }
        
        self.bottomView = WeChatNavigationBottomLabelBottomView(height: bottomHeight)
    }
    
}
