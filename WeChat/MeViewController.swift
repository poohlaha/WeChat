//
//  MeViewController.swift
//  WeChat
//
//  Created by Smile on 16/2/12.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//我页面
class MeViewController: WeChatTableViewNormalController {
    
    //MARKS: Properties
    @IBOutlet weak var myHeaderImageView: UIImageView!//头像
    @IBOutlet weak var myNameLabel: UILabel!//我的昵称
    @IBOutlet weak var myWeChatNumLabel: UILabel!//我的微信号
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFrame()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.tabBarController!.tabBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARKS: 初始化属性
    func initFrame(){
        myHeaderImageView.layer.borderWidth = 0.2
        //MARKS: 设置导航行背景及字体颜色
        WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
    }
    
    
    //MARKS: tableview cell点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)//取消cell选中事件
    }
    
}
