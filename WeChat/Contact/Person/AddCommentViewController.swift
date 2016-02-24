//
//  AddCommentViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/26.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//添加评论页面
class AddCommentViewController: UIViewController,WeChatCustomNavigationHeaderDelegate{

    var textView:UITextView!
    var navigation:WeChatCustomNavigationHeaderView!
    var navigationHeight:CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        initNavigationBar()
    }
    
    func initNavigationBar(){
        //获取状态栏
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.navigationHeight += statusBarFrame.height
        self.navigation = WeChatCustomNavigationHeaderView(frame: CGRectMake(0, 0,UIScreen.mainScreen().bounds.width, navigationHeight), backImage: nil, backTitle: "取消", centerLabel: "评论", rightButtonText: "发送", rightButtonImage: nil, backgroundColor: nil, leftLabelColor: nil, rightLabelColor: UIColor.greenColor())
        self.view.addSubview(self.navigation)
        self.view.bringSubviewToFront(self.navigation)
        self.navigation.delegate = self
        
        createTextField(self.navigation.frame.height)
    }
    
    func createTextField(topPadding:CGFloat){
        textView = UITextView()
        textView.frame = CGRectMake(10, topPadding, UIScreen.mainScreen().bounds.width - 10, UIScreen.mainScreen().bounds.height - topPadding)
        textView.returnKeyType = .Done
        textView.becomeFirstResponder()
        textView.font = UIFont(name: "Arial", size: 16)
        self.view.addSubview(textView)
    }
    
    func leftBarClick() {
        self.textView.resignFirstResponder()
        self.dismissViewControllerAnimated(true) { () -> Void in
            UtilTools().weChatTabBarController.selectedIndex = 1
        }
    }
    
    func rightBarClick() {
        leftBarClick()
    }
    
}
