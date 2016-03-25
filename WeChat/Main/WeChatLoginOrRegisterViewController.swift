//
//  FirstLoginOrRegisterViewController.swift
//  WeChat
//
//  Created by Smile on 16/3/25.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//第一次打开显示登陆或注册按钮
class WeChatLoginOrRegisterViewController: UIViewController {

    let leftOrRightPadding:CGFloat = 20
    var buttonWidth:CGFloat = 0
    let buttonHeight:CGFloat = 40
    var buttonBeginY:CGFloat = 0
    
    var loginViewController:WeChatLoginViewController?
    var registerViewController:WeChatRegisterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intFrame()
    }
    
    func intFrame(){
        let view = UIView(frame:self.view.frame)
        let imageView = UIImageView(image: UIImage(named: "firstStart")!)
        imageView.frame = view.frame
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        
        self.buttonWidth = (view.frame.width - 20 * 3) / 2
        self.buttonBeginY = view.frame.height - self.leftOrRightPadding - buttonHeight
        
        let loginButton = createButton("登陆", beginX: self.leftOrRightPadding,bgColor: UIColor.whiteColor(),textColor: UIColor.darkGrayColor())
        let registerButton = createButton("注册", beginX: view.frame.width - self.leftOrRightPadding - self.buttonWidth,bgColor: UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1),textColor: UIColor.whiteColor())
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        loginButton.addTarget(self, action: "loginButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        registerButton.addTarget(self, action: "registerButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(view)
    }
    
    //MARKS: 注册按钮事件
    func loginButtonClick(){
        if self.loginViewController == nil {
            self.loginViewController = WeChatLoginViewController()
        }
    }
    
    //MAKRS: 登陆按钮事件
    func registerButtonClick(){
        if self.registerViewController == nil {
            self.registerViewController = WeChatRegisterViewController()
        }
        
        self.presentViewController(self.registerViewController!, animated: true, completion: nil)
    }
    
    
    func createButton(title:String,beginX:CGFloat,bgColor:UIColor,textColor:UIColor) -> UIButton{
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(beginX, buttonBeginY, buttonWidth, buttonHeight)
        button.setTitle(title, forState: .Normal)
        button.backgroundColor = bgColor
        button.setTitleColor(textColor, forState: .Normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 3
        return button
    }
}
