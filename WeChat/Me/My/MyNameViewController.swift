//
//  MyNameViewController.swift
//  WeChat
//
//  Created by Smile on 16/3/14.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//名字页面
class MyNameViewController: WeChatTableViewNormalController,UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    var name:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFrame()
    }
    
    //MARKS: 初始化
    func initFrame(){
        initNavigation()
        
        nameField.text = name
        
        //设置文本框获得焦点
        nameField.becomeFirstResponder()
        
        //设置"保存"按钮不可用
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.nameField.delegate = self
        self.nameField.addTarget(self, action: "textDidChange", forControlEvents: .EditingChanged)
    }
    
    //MARKS: 初始化自定义导航条
    func initNavigation(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "leftBarClick")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: "rightBarClick")
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.greenColor()
        
        //修改右侧导航条按钮颜色
        self.navigationItem.title = "名字"
    }
    
    //MARKS: 取消点击事件
    func leftBarClick() {
       self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARKS: 保存点击事件
    func rightBarClick() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func textDidChange() {
        if self.nameField.text == "" {
            self.navigationItem.rightBarButtonItem?.enabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        
        if self.nameField.text?.characters.count > 15 {
            var text = NSString(string: self.nameField.text!)
            let range = NSRange(location: 0,length: 15)
            text = text.substringWithRange(range)
            self.nameField.text = text as String
        }
    }
    
    
}
