//
//  MyAddressViewController.swift
//  WeChat
//
//  Created by Smile on 16/3/21.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//我的地址
class MyAddressViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AddressViewDelegate {
    
    var tableView:UITableView!
    
    var footerView:UIView!
    let footerViewHeight:CGFloat = 40
    let SECTION_COUNT:Int = 1
    
    let CELL_HEADER_HEIGHT:CGFloat = 20
    let CELL_HEIGHT:CGFloat = 55
    
    var addresses:[MyAddressInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTableView()
        createTableViewFooter()
        //initData()
    }
    
    func initData(){
        let address = MyAddressInfo(name: "张三", phone: "13100000000", area: "安徽省 芜湖市 三山区", address: "北京市丰台区", yb: "240000")
        addresses.append(address)
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
    
    //MAKRS: 创建AddressViewController
    func createAddressViewController(){
        if addressViewController == nil {
            addressViewController = AddressViewController()
            addressViewController?.hidesBottomBarWhenPushed = true
            addressViewController?.addressViewDelegate = self
        }
        
        addressViewController?.myAddressInfo = nil
    }
    
    func tableFooterTap(gestrue: WeChatUITapGestureRecognizer){
        let view = gestrue.view
        view?.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        createAddressViewController()
        
        self.presentViewController(addressViewController!, animated: true) { () -> Void in
            view?.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func addButtonClick(){
        self.footerView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        createAddressViewController()
        
        self.presentViewController(addressViewController!, animated: true) { () -> Void in
            self.footerView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    let leftPadding:CGFloat = 10
    let topPadding:CGFloat = 5
    
    func createViewForFooter(){
        let view = UIView(frame:self.footerView.frame)
        
        let viewHeight:CGFloat = self.footerViewHeight - topPadding * 2
        
        let footerButton = UIButton(type: .ContactAdd)
        footerButton.frame = CGRectMake(leftPadding, topPadding, viewHeight, viewHeight)
        footerButton.addTarget(self, action: "addButtonClick", forControlEvents: .TouchUpInside)
        view.addSubview(footerButton)
        
        let footerLabelLeftPadding:CGFloat = 10
        let footerlabel:UILabel = UILabel()
        
        let labelBeginX:CGFloat = leftPadding + viewHeight + footerLabelLeftPadding
        footerlabel.frame = CGRectMake(labelBeginX, topPadding, view.frame.width - labelBeginX, viewHeight)
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
        return CELL_HEIGHT
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    //MARKS: 返回分组数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return SECTION_COUNT
    }
    
    //MARKS: 返回每组行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    let infoBtnWidth:CGFloat = 30
    let infoBtnHeight:CGFloat = 30
    let cellLeftPadding:CGFloat = 15
    let infoRightPadding:CGFloat = 15
    let cellWidth:CGFloat = UIScreen.mainScreen().bounds.width
    let nameLabelHeight:CGFloat = 20
    let addressHeight:CGFloat = 12
    let addressTopPadding:CGFloat = 3
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell\(indexPath.section)\(indexPath.row)")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell\(indexPath.section)\(indexPath.row)")
        }
        
        let myAddressInfo = self.addresses[indexPath.row]
        
        let width:CGFloat = cellWidth - infoBtnWidth - cellLeftPadding - infoRightPadding
        
        let nameFont = UIFont(name: "AlNile", size: 18)
        let addressFont = UIFont(name: "AlNile", size: 14)
        let cellTopPadding:CGFloat = (self.CELL_HEIGHT - nameLabelHeight - addressTopPadding - addressHeight) / 2
        
        //创建收货人
        let nameLabel = createLabel(CGRectMake(cellLeftPadding, cellTopPadding + 3, width, nameLabelHeight), string: myAddressInfo.name, color: UIColor.blackColor(), font: nameFont!)
        nameLabel.contentMode = .BottomLeft
        cell?.addSubview(nameLabel)
        
        //创建地址
        let addressLabel = createLabel(CGRectMake(cellLeftPadding, self.CELL_HEIGHT - cellTopPadding - addressHeight + 3,width, addressHeight), string: myAddressInfo.address, color: UIColor.lightGrayColor(), font: addressFont!)
        cell?.addSubview(addressLabel)
        
        //创建info按钮
        let infoBeiginX:CGFloat = self.cellWidth - infoRightPadding - infoBtnWidth
        let infoPaddding:CGFloat = (self.CELL_HEIGHT - infoBtnHeight) / 2
        
        let infoButton = UIButton(type: .InfoLight)
        infoButton.frame = CGRectMake(infoBeiginX, infoPaddding, infoBtnWidth, infoBtnHeight)
        infoButton.addTarget(self, action: "addInfoButtonClick:", forControlEvents: .TouchUpInside)
        infoButton.tag = indexPath.row
        cell?.addSubview(infoButton)
        
        cell?.selectionStyle = .None
        return cell!
    }
    
    
    //MARKS: 获取label高度
    func getLabelHeight(width:CGFloat,str:String,font:UIFont) -> CGFloat{
        let options : NSStringDrawingOptions = [.UsesLineFragmentOrigin,.UsesFontLeading]
        let boundingRect = str.boundingRectWithSize(CGSizeMake(width, 0), options: options, attributes: [NSFontAttributeName:font], context: nil)
        return boundingRect.size.height
    }

    //MAKRS: info按钮点击事件
    func addInfoButtonClick(button:UIButton){
        let updateAddressController = AddressViewController()
        updateAddressController.myAddressInfo = self.addresses[button.tag]
        updateAddressController.addressViewDelegate = self
        self.presentViewController(updateAddressController, animated: true, completion: nil)
    }
    
    //MARKS: 保存按钮点击后刷新table
    func saveButtonClick() {
        initData()
        self.tableView.reloadData()
    }
    
    func updateButtonClick() {
        self.tableView.reloadData()
    }
    
    func createLabel(frame:CGRect,string:String,color:UIColor,font:UIFont) -> UILabel{
        let label = UILabel(frame: frame)
        label.font = font
        label.textColor = color
        label.numberOfLines = 1
        label.text = string
        label.lineBreakMode = .ByTruncatingTail
        return label
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
