//
//  AddCommentViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/26.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//添加评论页面
class AddCommentViewController: UIViewController{

    var textField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        initNavigationBar()
        //createTextField()
    }
    
    func initNavigationBar(){
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
        self.navigationController?.title = "评论"
        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "send")
        //MARKS: 设置导航行背景及字体颜色
        WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
    }
    
    func createTextField(){
        textField = UITextField()
        textField.frame = UIScreen.mainScreen().bounds
        textField.textAlignment = .Left
        //textField.borderStyle = .None//去掉边框
        textField.becomeFirstResponder()//添加键盘
    }
    
    func cancel(){
        print("cancel")
    }
    
    func send(){
        print("send")
    }
}
