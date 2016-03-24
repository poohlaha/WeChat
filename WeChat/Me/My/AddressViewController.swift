//
//  AddAddressViewController.swift
//  WeChat
//
//  Created by Smile on 16/3/22.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//添加或修改Address页面
class AddressViewController: UIViewController,WeChatCustomNavigationHeaderDelegate,
        UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,AddressPickerViewDelegate{
    
    var navigation:WeChatCustomNavigationHeaderView!
    var navigationHeight:CGFloat = 44
    let fontName:String = "AlNile"
    
    var tableView: UITableView!
    var font:UIFont!
    
    let SECTION_COUNT:Int = 1
    
    var data:[MyAddress] = []
    
    var CELL_HEADER_HEIGHT:CGFloat = 20
    var addressPickerView:AddressPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.font = UIFont(name: self.fontName, size: 15)
        
        initNavigationBar()
        initTableView()
        initData()
        createPicker()
    }
    
    //MARKS:  创建城市三级联动
    func createPicker(){
        if self.addressPickerView == nil {
            let height:CGFloat = UIScreen.mainScreen().bounds.height * 2 / 5
            self.addressPickerView = AddressPickerView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height - height, UIScreen.mainScreen().bounds.width, height))
            self.addressPickerView?.pickViewDelegate = self
        }
    }
    
    //MARKS: 初始化tableView
    func initTableView(){
        tableView = UITableView(frame: CGRectMake(0, self.navigationHeight, self.view.frame.width, self.view.frame.height), style: UITableViewStyle.Grouped)
        self.tableView.showsVerticalScrollIndicator = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    //MARKS: 初始化数据
    func initData(){
        let name = MyAddress(nameLabel: "收货人", textPlaceholder: "名字",tag:1000)
        let phone = MyAddress(nameLabel: "手机号码", textPlaceholder: "11位手机号",tag:1001)
        let area = MyAddress(nameLabel: "选择地区", textPlaceholder: "地区信息",tag: 1002)
        let address = MyAddress(nameLabel: "详细地址", textPlaceholder: "街道门牌信息",tag:1003)
        let yb = MyAddress(nameLabel: "邮政编码", textPlaceholder: "邮政编码",tag:1004)
        data.append(name)
        data.append(phone)
        data.append(area)
        data.append(address)
        data.append(yb)
    }
    
    //MARKS: 自己定义导航条
    func initNavigationBar(){
        //获取状态栏
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.navigationHeight += statusBarFrame.height
        self.navigation = WeChatCustomNavigationHeaderView(frame: CGRectMake(0, 0,UIScreen.mainScreen().bounds.width, navigationHeight), backImage: nil, backTitle: "取消", centerLabel: "修改地址\nWeChat安全支付", rightButtonText: "保存", rightButtonImage: nil, backgroundColor: nil, leftLabelColor: nil, rightLabelColor: UIColor.greenColor())
        self.view.addSubview(self.navigation)
        self.view.bringSubviewToFront(self.navigation)
        self.navigation.delegate = self
    }
    
    //MARKS: 左侧点击事件
    func leftBarClick() {
        let alertController = UIAlertController(title: "确定要放弃此次编辑", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.rightBarClick()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //MARKS: 右侧点击事件
    func rightBarClick() {
        for textField in textFields {
            textField.resignFirstResponder()
        }
        self.textView?.resignFirstResponder()
        self.areaTextField?.resignFirstResponder()
        self.dismissViewControllerAnimated(true) { () -> Void in
            UtilTools().weChatTabBarController.selectedIndex = 3
        }
    }
    
    //MARKS: 返回分组数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return SECTION_COUNT
    }
    
    //MARKS: 返回每组行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CELL_HEADER_HEIGHT
    }
    
    let CELL_HEIGHT:CGFloat = 44

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return CELL_HEIGHT + 20
        }
        
        return CELL_HEIGHT
    }
    
    let leftOrRightPadding:CGFloat = 15
    var topOrBottomPadding:CGFloat = 0
    let labelWidth:CGFloat = 70
    let labelRightPadding:CGFloat = 10
    var textView:PlaceholderTextView?
    
    var areaTextField:UITextField?
    
    var textFields:[UITextField] = []
    
    //MARKS: 返回每行的单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell\(indexPath.section)\(indexPath.row)")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell\(indexPath.section)\(indexPath.row)")
        }
        
        let myAddress = data[indexPath.row]
        
        let labelHeight:CGFloat = getLabelHeight(labelWidth,str: myAddress.nameLabel)
        topOrBottomPadding = (cell!.frame.height - labelHeight) / 2
        
        let label = createLabel(
            CGRectMake(leftOrRightPadding, topOrBottomPadding + 2, labelWidth, labelHeight),
            string: myAddress.nameLabel,
            color: UIColor.blackColor()
        )
        cell?.addSubview(label)
        
        let textFieldBeginX:CGFloat = leftOrRightPadding + labelWidth + labelRightPadding
        let textFieldWidth:CGFloat = self.view.frame.width - textFieldBeginX - leftOrRightPadding
        
        if indexPath.row == 3 {
            self.textView = createTextView(CGRectMake(textFieldBeginX, 5, textFieldWidth, cell!.frame.height - (5 * 2)), placeholder: myAddress.nameLabel)
            
            cell?.addSubview(textView!)
        }else{
            let textField = createTextField(
                CGRectMake(textFieldBeginX, 5, textFieldWidth, cell!.frame.height - (5 * 2)),
                placeholder: myAddress.textPlaceholder
            )
            
            cell?.addSubview(textField)
            
            //给选择地区添加监听事件
            if indexPath.row == 2 {
                self.areaTextField = textField
                self.areaTextField?.clearButtonMode = .WhileEditing
                self.areaTextField?.inputView = addressPickerView//设置城市三级联动
            }else{
                textFields.append(textField)
            }
        }
        
        cell?.selectionStyle = .None
        
        return cell!
    }
    
    func cancelClick() {
        self.addressPickerView?.removeFromSuperview()
        self.areaTextField?.resignFirstResponder()
    }
    
    func doneClick() {
        self.addressPickerView?.removeFromSuperview()
        self.areaTextField?.text = self.addressPickerView?.getSelectedData()
        self.areaTextField?.resignFirstResponder()
    }
    
    //MARKS: Label高度自适应
    func createLabel(frame:CGRect,string:String,color:UIColor) -> UILabel{
        let label = UILabel(frame: frame)
        label.font = self.font
        label.textColor = color
        label.numberOfLines = 1
        label.text = string
        return label
    }
    
    //MARKS: 获取Label高度
    func getLabelHeight(width:CGFloat,str:String) -> CGFloat{
        let options : NSStringDrawingOptions = [.UsesLineFragmentOrigin,.UsesFontLeading]
        let boundingRect = str.boundingRectWithSize(CGSizeMake(width, 0), options: options, attributes: [NSFontAttributeName:self.font], context: nil)
        return boundingRect.size.height
    }
    
    //MARKS: 创建textField
    func createTextField(frame:CGRect,placeholder:String) -> UITextField{
        let textField = UITextField(frame: frame)
        textField.frame = frame
        textField.placeholder = placeholder
        textField.font = UIFont(name: "AlNile", size: 16)
        textField.contentMode = .Center
        textField.borderStyle = .None
        return textField
    }
    
    //MARKS:创建textView
    func createTextView(frame:CGRect,placeholder:String) -> PlaceholderTextView{
        let textView = PlaceholderTextView(frame: frame,placeholder: placeholder,color: nil,font: nil)
        textView.layer.borderWidth = 0.5  //边框粗细
        textView.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).CGColor //边框颜色
        textView.editable = true//是否可编辑
        textView.selectable = true//是否可选
        textView.dataDetectorTypes = .None//给文字中的电话号码和网址自动加链接,这里不需要添加
        textView.returnKeyType = .Send
        textView.font = UIFont(name: "AlNile", size: 16)
        //设置不可以滚动
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.autoresizingMask = .FlexibleHeight
        //不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为false，否则会出现光标乱滚动的情况
        //textView.scrollEnabled = false//此属性可能导致textView无法换行
        textView.scrollsToTop = false
        textView.delegate = self
        textView.placeholderLocation = PlaceholderLocation.Top
        textView.layer.borderWidth = 0 //去看边框
        return textView
    }
    
    //MARSK: 去掉回车,限制UITextView的行数
    /*func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let labelHeight:CGFloat = getLabelHeight(self.textView!.frame.width,str:self.textView!.text + text)
        let numLine:Int = Int(ceil(labelHeight / getOneCharHeight(textView.frame.width)))
        if numLine > 2 {
            self.textView!.text = (self.textView!.text as NSString).substringToIndex(self.textView!.text.characters.count)
            return false
        }
        
        return true
    }*/
    
    func getOneCharHeight(width:CGFloat) ->CGFloat{
        return getLabelHeight(width,str:"我")
    }
    
    
    //MARKS: 当空字符的时候重绘placeholder
    func textViewDidChange(textView: UITextView) {
        if self.textView!.text?.characters.count > 40 {
            var text = NSString(string: self.textView!.text!)
            let range = NSRange(location: 0,length: 40)
            text = text.substringWithRange(range)
            self.textView!.text = text as String
        }
    }
    

    
}

class MyAddress {
    var nameLabel:String
    var textPlaceholder:String
    
    init(nameLabel:String,textPlaceholder:String,tag:Int){
        self.nameLabel = nameLabel
        self.textPlaceholder = textPlaceholder
    }
}
