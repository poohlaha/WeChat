//
//  CommentDetailViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/26.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//评论详情页面
class CommentDetailViewController: UIViewController,WeChatCustomNavigationHeaderDelegate,WeChatEmojiDialogBottomDelegate {

    var navigation:WeChatCustomNavigationHeaderView!
    var navigationHeight:CGFloat = 0
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
        self.navigationHeight = statusBarFrame.height + 44
        self.navigation = WeChatCustomNavigationHeaderView(frame: CGRectMake(0, 0,UIScreen.mainScreen().bounds.width, navigationHeight), backImage: nil, backTitle: "完成", centerLabel: "详情", rightButtonText: nil, rightButtonImage: nil, backgroundColor: UIColor.darkGrayColor(), leftLabelColor: UIColor.greenColor(), rightLabelColor: nil)
        self.view.addSubview(self.navigation)
        self.view.bringSubviewToFront(self.navigation)
        self.navigation.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigation.removeFromSuperview()
        initNavigation()
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
                    self.navigationController?.popViewControllerAnimated(false)
                }
        }
        
        
    }
    

    var weChatKeyBord:WeChatCustomKeyBordView!
    //MARKS: 添加底部输入框
    func createKeyBord(){
        self.weChatKeyBord = WeChatCustomKeyBordView(placeholderText: "评论")
        self.view.addSubview(self.weChatKeyBord)
        self.view.bringSubviewToFront(self.weChatKeyBord)
        self.weChatKeyBord.delegate = self
    }
    
    //添加自定义聊天框底部
    func addBottom() -> UIView{
        let bottomView = UIView()
        let beginY = self.weChatKeyBord.biaoQingDialog!.scrollView.frame.origin.y + self.weChatKeyBord.biaoQingDialog!.scrollView.frame.height
        let height:CGFloat = self.weChatKeyBord.biaoQingDialog!.bottomHeight
        bottomView.frame = CGRectMake(0, beginY, UIScreen.mainScreen().bounds.width, height)
        
        //添加左侧表情
        let leftView = UIView()
        leftView.frame = CGRectMake(0, 0, 40, bottomView.frame.height)
        leftView.backgroundColor = self.weChatKeyBord.biaoQingDialog!.scrollView.backgroundColor
        
        let imageWidth:CGFloat = 25
        let imageHeight:CGFloat = 25
        let leftImageView = UIImageView()
        let leftPadding:CGFloat = (leftView.frame.width - imageWidth) / 2
        let topPadding:CGFloat = (leftView.frame.height - imageHeight) / 2
        leftImageView.frame = CGRectMake(leftPadding, topPadding, imageWidth, imageHeight)
        leftImageView.image = UIImage(named: "morePic")
        leftView.addSubview(leftImageView)
        bottomView.addSubview(leftView)
        
        
        //右侧button
        let buttonWidth:CGFloat = 50
        let rightBtn = UIButton()
        rightBtn.frame = CGRectMake(bottomView.frame.width - buttonWidth, 0, buttonWidth, bottomView.frame.height)
        rightBtn.backgroundColor = UIColor(red: 0/255, green: 153/255, blue: 255/255, alpha: 1)
        rightBtn.setTitle("发送", forState: .Normal)
        rightBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        rightBtn.titleLabel?.textAlignment = .Center
        rightBtn.titleLabel?.font = UIFont(name: "Arial-bold", size: 16)
        bottomView.addSubview(rightBtn)
        
        return bottomView
    }
}
