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
        
        //设置第三个cell无法点击
        let indexPath = NSIndexPath(forItem: 1, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selectionStyle = .None
    }
    
    
    var myTwoDimeController:UIViewController?
    //MARKS: 点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0 {
                
            } else if row == 1 {
                
            } else if row == 3 {//二维码
                if myTwoDimeController == nil {
                    myTwoDimeController = MeTwoDimeViewController()
                }
                myTwoDimeController?.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(myTwoDimeController!, animated: true)
            } else if row == 4 {
                
            }
        } else if section == 1 {
            if row == 0 {
                
            } else if row == 1 {
                
            } else if row == 2 {
                
            }
        }
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
