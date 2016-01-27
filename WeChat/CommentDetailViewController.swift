//
//  CommentDetailViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/26.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//评论详情页面
class CommentDetailViewController: UIViewController,WeChatCustomNavigationHeaderDelegate {

    var navigation:WeChatCustomNavigationHeaderView!
    var navigationHeight:CGFloat = 44
    var parentView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        initFrame()
    }
    
    func initFrame(){
        initNavigation()
        createKeyBord()
    }
    
    //MARKS: 初始化自定义导航条
    func initNavigation(){
        //获取状态栏
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.navigationHeight += statusBarFrame.height
        self.navigation = WeChatCustomNavigationHeaderView(frame: CGRectMake(0, 0,UIScreen.mainScreen().bounds.width, navigationHeight), backImage: nil, backTitle: "完成", centerLabel: "详情", rightButtonText: nil, rightButtonImage: nil, backgroundColor: UIColor.darkGrayColor(), leftLabelColor: UIColor.greenColor(), rightLabelColor: nil)
        self.view.addSubview(self.navigation)
        self.view.bringSubviewToFront(self.navigation)
        self.navigation.delegate = self
    }
    
    //导航条左侧事件,翻转动画
    func leftBarClick() {
        let fromView = self.view
        let toView = parentView
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.weChatKeyBord.navigationBackClick()
            }) { (Bool) -> Void in
                CATransaction.flush()
                UIView.transitionFromView(fromView, toView: toView, duration: 1, options: [UIViewAnimationOptions.TransitionFlipFromLeft,UIViewAnimationOptions.CurveEaseInOut]) { (Bool) -> Void in
                    
                }
        }
        
        
    }
    

    let keyBordDefaultHeight:CGFloat = 40
    var weChatKeyBord:WeChatCustomKeyBordView!
    //MARKS: 添加底部输入框
    func createKeyBord(){
        let frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - keyBordDefaultHeight, UIScreen.mainScreen().bounds.width, keyBordDefaultHeight)
        
        self.weChatKeyBord = WeChatCustomKeyBordView(frame: frame, bgColor: UIColor.whiteColor())
        self.view.addSubview(self.weChatKeyBord)
        self.view.bringSubviewToFront(self.weChatKeyBord)
    }
    
}
