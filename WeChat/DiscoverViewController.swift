//
//  DiscoverViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/8.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class DiscoverViewController: WeChatTableViewNormalController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFrame()
    }
    
    func initFrame(){
        initTableView()
        //MARKS: 设置导航行背景及字体颜色
        WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
    }
}
