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
        //MARKS: 设置导航行背景及字体颜色
        WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if(section == 3 && row == 0){//购物
            let shoppingViewController = ShoppingViewController()
            shoppingViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(shoppingViewController, animated: false)
        }
        
        if(section == 1 && row == 0){
            let scanViewController = ScanViewController()
            scanViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(scanViewController, animated: false)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)//取消cell选中事件
    }
}
