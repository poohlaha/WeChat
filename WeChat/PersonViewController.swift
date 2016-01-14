//
//  PersonViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/14.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//个人信息页面
class PersonViewController: WeChatTableViewNormalController {

    //MARKS:Properties
    var navigationTitle:String?
    var headerImage:UIImage?
    var personInfos:[PersonInfo] = [PersonInfo]()
    let headerBgHeight:CGFloat = 300
    let headerHeight:CGFloat = 400
    
    //重写属性,去掉tableview header
    override var CELL_HEADER_HEIGHT:CGFloat {
        get {
            return 0
        }
        
        set {
            self.CELL_HEADER_HEIGHT = newValue
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFrame()
    }
    
    //MARKS: 初始化
    func initFrame(){
        //设置标题
        navigationItem.title = navigationTitle
        
        //MARKS: 设置导航行背景及字体颜色
        WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
        
        //去掉tableview分割线
        //tableView.separatorStyle = .None
        tableView.scrollEnabled = true
        tableView.showsVerticalScrollIndicator = true
        initTableHeaderView()
    }
    
    //MARKS: 初始化数据
    func initData(){
        
    }
    
    //MARKS: 获取随机数
    func getRandom() -> UInt32 {
        let max: UInt32 = 10
        let min: UInt32 = 1
        let num = arc4random_uniform(max - min) + min
        return num
    }
    
    //初始化tableHeaderView
    func initTableHeaderView(){
        //背景大图
        let bgImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: headerBgHeight))
        bgImageView.image = UIImage(named: "info-bg\(getRandom())")
        
        //头像小图
        let headerImageX = UIScreen.mainScreen().bounds.width - (headerImage?.size.width)! - 10
        let headerImageY = headerBgHeight - (headerImage?.size.height)! / 2
        let headerImageView = UIImageView(frame: CGRect(x: headerImageX, y: headerImageY, width: headerImage!.size.width, height: headerImage!.size.height))
        headerImageView.image = headerImage
        
        let headerView:UIView = UIView(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.width,headerHeight))
        headerView.addSubview(bgImageView)
        headerView.addSubview(headerImageView)
        
        
        tableView.tableHeaderView = headerView
    }
    
    //MARKS: 返回cell行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personInfos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath) as! PersonInfoCell
        
        return cell
    }
    
}
