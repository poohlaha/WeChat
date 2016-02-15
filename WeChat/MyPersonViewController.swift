//
//  MyPersonViewController.swift
//  WeChat
//
//  Created by Smile on 16/2/13.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class MyPersonViewController: WeChatTableViewNormalController {

    @IBOutlet weak var myHeaderImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initFrame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARKS: 初始化属性
    func initFrame(){
        //MARKS: 设置导航行背景及字体颜色
        WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
        self.navigationItem.title = "个人信息"
        
        //添加边框
        self.myHeaderImageView.layer.borderWidth = 0.2
    }
}
