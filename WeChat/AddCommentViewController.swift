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

    var textField:UITextField!
    var navigation:WeChatCustomNavigationHeaderView!
    var navigationHeight:CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        initNavigationBar()
        //createTextField()
    }
    
    func initNavigationBar(){
        //获取状态栏
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.navigationHeight += statusBarFrame.height
        self.navigation = WeChatCustomNavigationHeaderView(frame: CGRectMake(0, 0,UIScreen.mainScreen().bounds.width, navigationHeight), backImage: nil, backTitle: "取消", centerLabel: "评论", rightButtonText: "发送", rightButtonImage: nil, backgroundColor: UIColor.darkGrayColor(), leftLabelColor: nil, rightLabelColor: UIColor.greenColor())
        self.view.addSubview(self.navigation)
        self.view.bringSubviewToFront(self.navigation)
        self.navigation.delegate = self
    }
    
    func createTextField(){
        textField = UITextField()
        textField.frame = UIScreen.mainScreen().bounds
        textField.textAlignment = .Left
        //textField.borderStyle = .None//去掉边框
        textField.becomeFirstResponder()//添加键盘
    }
    
    func leftBarClick() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            let rootController = UIApplication.sharedApplication().delegate!.window?!.rootViewController as! UITabBarController
            rootController.selectedIndex = 1
        }
    }
    
    func rightBarClick() {
        leftBarClick()
    }
    
}
