//
//  MyPersonViewController.swift
//  WeChat
//
//  Created by Smile on 16/2/13.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//个人信息页面
class MyPersonViewController: WeChatTableViewNormalController {

    @IBOutlet weak var myHeaderImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
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
    
    //MARKS: 设置第三个cell无法点击
    override func viewDidAppear(animated: Bool) {
        let indexPath = NSIndexPath(forItem: 2, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.selectionStyle = .None
    }
    
    
    var myTwoDimeController:MeTwoDimeViewController?
    var loadingView:WeChatNormalLoadingView?
    var loadingViewWidth:CGFloat = 120
    var loadingViewHeight:CGFloat = 120
    
    var myAddressController:MyAddressViewController?
    
    //MARKS: 点击事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0 {
                
            } else if row == 1 {//名字
                
            } else if row == 3 {//二维码
                if myTwoDimeController == nil {
                    myTwoDimeController = MeTwoDimeViewController()
                }
                myTwoDimeController?.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(myTwoDimeController!, animated: true)
            } else if row == 4 {//我的地址,添加Loading
                self.createLoadingView()
                NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "getToMyAddress", userInfo: nil, repeats: false)
            }
        } else if section == 1 {
            if row == 0 {
                
            } else if row == 1 {
                
            } else if row == 2 {
                
            }
        }
        
    }
    
    //MARKS: 跳转到MyAddressController
    func getToMyAddress(){
        if myAddressController == nil {
            myAddressController = MyAddressViewController()
            myAddressController?.hidesBottomBarWhenPushed = true
        }
        
        self.loadingView?.removeFromSuperview()
        self.navigationController?.pushViewController(self.myAddressController!, animated: true)
    }
    
    //MAKRS: 传值,在点击事件前执行
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nameSegue" {//名字
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let destinationController = segue.destinationViewController as! MyNameViewController
                destinationController.hidesBottomBarWhenPushed = true
                destinationController.name = nameLabel.text
            }
        }
    }
    
    //MARKS: 创建加载View
    func createLoadingView(){
        if loadingView == nil {
            let navigationHeight:CGFloat = (self.navigationController?.navigationBar.frame.height)! + UIApplication.sharedApplication().statusBarFrame.height
            let beginY:CGFloat = (self.view.frame.height - navigationHeight) / 2 - self.loadingViewHeight / 2
            let beginX:CGFloat = self.view.frame.width / 2 - self.loadingViewWidth / 2
            
            loadingView = WeChatNormalLoadingView(frame: CGRectMake(beginX, beginY, loadingViewWidth, loadingViewHeight), labelText: "正在加载...")
        }
        self.view.addSubview(loadingView!)
    }
}
