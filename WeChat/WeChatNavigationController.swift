//
//  WeChatNavigationController.swift
//  WeChat
//
//  Created by Smile on 16/1/11.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class WeChatNavigation {
    
    //MARKS: Properties
    let barTintColor = UIColor(red: 65/255, green: 67/255, blue: 73/255, alpha:1)
    let tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha:1)
    let titleColor = UIColor.whiteColor()
    
    func setNavigationBarProperties(navigationBar:UINavigationBar) {
        //MARKS: 设置导航行背景及字体颜色
        navigationBar.barTintColor = barTintColor
        navigationBar.tintColor = tintColor
        
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: titleColor,forKey: NSForegroundColorAttributeName)
        navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
    }
}