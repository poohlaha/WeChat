//
//  MeTwoDimeViewController.swift
//  WeChat
//
//  Created by Smile on 16/2/15.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//我的二维码
class MeTwoDimeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.tabBarController!.tabBar.hidden = true
        initFrame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARKS: 初始化一些属性
    func initFrame(){
        self.navigationItem.title = "我的二维码"
        createTwoDime()
    }
    
    //MARKS: 创建二维码
    func createTwoDime(){
        let twoDimeView = MyTwoDime(frame: self.view.frame,bgColor: UIColor.darkGrayColor())
        self.view.addSubview(twoDimeView)
    }
}
