//
//  WeChatNavigationController.swift
//  WeChat
//
//  Created by Smile on 16/1/11.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class WeChatNavigation {
    
    func setNavigationBarProperties(navigationBar:UINavigationBar) {
        //MARKS: 设置导航行背景及字体颜色
        navigationBar.barTintColor = WeChatColor().barTintColor
        navigationBar.tintColor = WeChatColor().tintColor
        
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: WeChatColor().titleColor,forKey: NSForegroundColorAttributeName)
        navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
    }
}