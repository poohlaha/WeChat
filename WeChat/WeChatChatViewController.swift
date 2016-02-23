//
//  WeChatChatViewController.swift
//  WeChat
//
//  Created by Smile on 16/2/1.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义聊天界面
class WeChatChatViewController: UIViewController,WeChatEmojiDialogBottomDelegate {
    
    var nagTitle:String!
    var weChatKeyBord:WeChatCustomKeyBordView!
    var tableView:UITableView!
    var nagHeight:CGFloat = 0//导航条高度

    override func viewDidLoad() {
        super.viewDidLoad()
        initFrame()
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.navigationController?.tabBarController!.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
    }
    
    //MARKS: 初始化
    func initFrame(){
        //MARKS: 设置导航行背景及字体颜色
        WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
        //隐藏底部tabbar
        //self.navigationController?.tabBarController!.tabBar.hidden = true
        self.nagHeight = self.navigationController!.navigationBar.frame.height
        self.navigationItem.title = self.nagTitle
        self.view.backgroundColor = UIColor.whiteColor()
        //创建键盘
        createKeyBord()
        //createTableView()
        self.view.addGestureRecognizer(WeChatUITapGestureRecognizer(target:self,action: "tableViewTap:"))
    }
    
    //MARKS: 创建tableView
    func createTableView(){
        self.tableView = UITableView()
        let tableViewHeight = UIScreen.mainScreen().bounds.height - self.nagHeight - self.weChatKeyBord.defaultHeight
        self.tableView.frame = CGRectMake(0, self.nagHeight, UIScreen.mainScreen().bounds.width, tableViewHeight)
        self.tableView.separatorStyle = .None
        self.tableView.scrollEnabled = true
        self.tableView.showsVerticalScrollIndicator = true
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.addGestureRecognizer(WeChatUITapGestureRecognizer(target:self,action: "tableViewTap:"))
        self.view.addSubview(self.tableView)
    }
    
    //MARKS: tableView点击事件,隐藏键盘
    func tableViewTap(gesture:WeChatUITapGestureRecognizer){
        self.weChatKeyBord.textView.resignFirstResponder()
    }
    
    //MARKS: 添加底部输入框
    func createKeyBord(){
        self.weChatKeyBord = WeChatCustomKeyBordView(placeholderText: nil)
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
