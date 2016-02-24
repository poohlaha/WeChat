//
//  WeChatCustomViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/19.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义UIViewController
class WeChatCustomViewTableController: UIViewController,UITableViewDelegate {

    //MARKS: Properties
    var timeArray:NSMutableArray?
    var refresh:UIRefreshControl?
    let refreshWidth:CGFloat = 40
    let refreshHeight:CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initProperties()
    }
    
    //MARKS: 初始化属性
    func initProperties(){
      self.timeArray = NSMutableArray()
      self.beginRefreshing()
    }
    
    //MARKS: 开始刷新
    func beginRefreshing(){
        self.refresh = UIRefreshControl()
        self.refresh?.frame = CGRectMake(UIScreen.mainScreen().bounds.width / 2 - refreshWidth, self.refresh!.frame.origin.y, refreshWidth, refreshHeight)
        self.refresh?.tintColor = UIColor.lightGrayColor()//刷新图标颜色
        //self.refresh?.attributedTitle = NSAttributedString(string: "下拉刷新")//刷新的标题
        // UIRefreshControl 会触发一个UIControlEventValueChanged事件，通过监听这个事件可以进行类似数据请求的操作了
        self.refresh?.addTarget(self, action: "refreshTableView:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    //MARKS: 刷新tableView
    func refreshTableView(refresh_:UIRefreshControl){
        if (refresh_.refreshing) {
            refresh_.attributedTitle = NSAttributedString(string: "正在刷新")
            //运行时系统负责去找方法的，在编译时候不做任何校验,2秒后调用
            self.performSelector("refreshTableViewData", withObject: nil, afterDelay: 2)
        }
    }
    
    //MARKS: 刷新数据
    func refreshTableViewData(){
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let sysTime = dateFormat.stringFromDate(NSDate())
        
        //self.refresh?.attributedTitle = NSAttributedString(string: String("上一次更新时间为:\(sysTime)"))
        self.refresh?.attributedTitle = NSAttributedString(string: String("刷新成功"))
        self.timeArray?.addObject(sysTime)
        
        reloadData()
        NSThread.sleepForTimeInterval(2.0)
        self.refresh?.endRefreshing()
        self.refresh?.attributedTitle = NSAttributedString(string: "")
    }
    
    func reloadData() {
        
    }
}
