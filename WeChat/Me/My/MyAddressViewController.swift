//
//  MyAddressViewController.swift
//  WeChat
//
//  Created by Smile on 16/3/21.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//我的地址
class MyAddressViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView:UITableView!
    
    var footerView:UIView!
    let footerViewHeight:CGFloat = 40
    let SECTION_COUNT:Int = 1
    
    let CELL_HEADER_HEIGHT:CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTableView()
        createTableViewFooter()
    }
    
    //MARKS: 创建tableview
    func createTableView(){
        tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        self.tableView.showsVerticalScrollIndicator = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    //创建TableViewFooter
    func createTableViewFooter(){
        footerView = UIView(frame: CGRectMake(0,0,tableView.frame.size.width,footerViewHeight))
        footerView.backgroundColor = UIColor.whiteColor()
        
        //画底部线条
        let shape = WeChatDrawView().drawLineAtLast(0,height: self.footerView.frame.height)
        shape.lineWidth = 0.2
        footerView.layer.addSublayer(shape)
        
        createViewForFooter()
        self.tableView.tableFooterView =  footerView
        
        self.tableView.tableFooterView?.addGestureRecognizer(WeChatUITapGestureRecognizer(target:self,action: "tableFooterTap:"))
    }
    
    //MARKS: tableViewFooter点击事件
    var addressViewController:AddressViewController?
    
    func tableFooterTap(gestrue: WeChatUITapGestureRecognizer){
        let view = gestrue.view
        view?.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        if addressViewController == nil {
            addressViewController = AddressViewController()
            //let sb = UIStoryboard(name:"Me", bundle: nil)
            //addressViewController = sb.instantiateViewControllerWithIdentifier("AddressViewControllerSB") as? AddressViewController
            addressViewController?.hidesBottomBarWhenPushed = true
        }
        
        self.presentViewController(addressViewController!, animated: true) { () -> Void in
            view?.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func createViewForFooter(){
        let view = UIView(frame:self.footerView.frame)
        
        let footerLeftPadding:CGFloat = 10
        let footerTopPadding:CGFloat = 5
        let viewHeight:CGFloat = self.footerViewHeight - footerTopPadding * 2
        
        let footerButton = UIButton(type: .ContactAdd)
        footerButton.frame = CGRectMake(footerLeftPadding, footerTopPadding, viewHeight, viewHeight)
        view.addSubview(footerButton)
        
        let footerLabelLeftPadding:CGFloat = 10
        let footerlabel:UILabel = UILabel()
        
        let labelBeginX:CGFloat = footerLeftPadding + viewHeight + footerLabelLeftPadding
        footerlabel.frame = CGRectMake(labelBeginX, footerTopPadding, view.frame.width - labelBeginX, viewHeight)
        footerlabel.textColor = UIColor.blackColor()
        footerlabel.font = UIFont.systemFontOfSize(16)
        footerlabel.text = "新增地址"
        
        footerView.addSubview(view)
        footerView.addSubview(footerlabel)
    }
    
    //MARKS: 设置tableViewHeader距离上边的空白
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CELL_HEADER_HEIGHT
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    //MARKS: 返回分组数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return SECTION_COUNT
    }
    
    //MARKS: 返回每组行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell\(indexPath.section)\(indexPath.row)")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell\(indexPath.section)\(indexPath.row)")
        }
        
        return cell!
    }
    
    
}

class MyAddressInfo {
    var name:String//名字
    var phone:String//手机号码
    var area:String//选择区域
    var address:String//详细地址
    var yb:String//邮编
    
    init(name:String,phone:String,area:String,address:String,yb:String){
        self.name = name
        self.phone = phone
        self.area = area
        self.address = address
        self.yb = yb
    }
}
