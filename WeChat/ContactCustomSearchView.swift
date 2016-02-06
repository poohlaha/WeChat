//
//  ContactCustomSearchView.swift
//  WeChat
//
//  Created by Smile on 16/1/18.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义search视图,用于当用户开始输入数据的时候显示,以及显示搜索结果
class ContactCustomSearchView: UIViewController,UITableViewDelegate,UITableViewDataSource,WeChatSearchBarDelegate {
    
    //MARKS: Properties
    let searchBarHeight:CGFloat = 40
    let searchBarBottomPadding:CGFloat = 40
    let arcWidthHeight:CGFloat = 80
    let arcNum:CGFloat = 3
    let arcFillColor:UIColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    var topPadding:CGFloat?
    
    let arcBottomPadding:CGFloat = 20
    let labelWidth:CGFloat = 45
    let labelHeight:CGFloat = 20
    var tableView:UITableView?
    var customSearchBar:WeChatSearchBar!
    var customView:UIView?
    var frame:CGRect?
    var textField:UITextField!
    var delegate:WeChatSearchBarDelegate?
    
    var sessions = [ContactSession]()
    var index:Int = -1
    
    let tableCellOneHeight:CGFloat = 45
    let tabelCellOneTextHeight:CGFloat = 15
    let tableCellOneTopPadding:CGFloat = 20
    let tableCellOneBottomPadding:CGFloat = 10
    let tableCellHeight:CGFloat = 54
    let tableCellImage:CGFloat = 44
    let tableCellPadding:CGFloat = 5
    let selectedTextColor:UIColor = UIColor(red: 0/255, green: 102/255, blue: 51/255, alpha: 1)//搜索结果颜色
    
    let leftPadding:CGFloat = 15
    let photoRightPadding:CGFloat = 10
    let fontName = "AlNile"
    var data = [Contact]()
    var navigationHeight:CGFloat = 0
    var searchLabelView:WeChatSearchLabelView?
    var statusHeight:CGFloat = 0
    var iscreateThreeArc:Bool = true
    var isCreateSpeakImage:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        initFrame()
    }
    
    func initFrame(){
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.statusHeight = statusBarFrame.height
        
        self.navigationController?.navigationBar.hidden = true
        self.navigationHeight = (self.navigationController?.navigationBar.frame.height)!
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "touming-bg")!)
        self.view.backgroundColor = UIColor.whiteColor()
        getStatusHeight()
        //createSearchBar()
        createCustomSearchBar()
        self.frame = CGRectMake(0, customSearchBar.frame.origin.y + customSearchBar.frame.height, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - searchBarHeight - topPadding!)
        self.edgesForExtendedLayout = .None

        addTableView()
        
        if iscreateThreeArc {
            createThreeArc()
        }
        
    }
    
    
    func addTableView(){
        self.tableView = UITableView(frame: self.frame!)
        self.tableView?.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.scrollEnabled = true
        self.tableView?.showsVerticalScrollIndicator = true
        self.tableView?.separatorStyle = .None
        //self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(self.tableView!)
        self.view.bringSubviewToFront(self.tableView!)
        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CustomTableCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        //hideNavigationBar()
        self.navigationController?.navigationBar.hidden = true
        self.navigationController?.tabBarController!.tabBar.hidden = true
    }
    
    //MARKS: 隐藏导航条动画
    func hideNavigationBar(){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.navigationController?.navigationBar.frame = CGRectMake(0,UIApplication.sharedApplication().statusBarFrame.height,(self.navigationController?.navigationBar.frame.width)!,0)
            }) { (Bool) -> Void in
                self.navigationController?.navigationBar.hidden = true
                self.navigationController?.navigationBar.frame.size = CGSize(width: (self.navigationController?.navigationBar.frame.width)!,height: self.navigationHeight)
        }
    }
    
    //MARKS: 获取状态栏高度
    func getStatusHeight(){
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        topPadding  = statusBarFrame.height
    }
    
    //MARKS: 创建自定义searchBar
    func createCustomSearchBar(){
        customSearchBar = WeChatSearchBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, searchBarHeight + topPadding!), placeholder: "搜索", cancelBtnText: "取消", cancelBtnColor: UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1),isCreateSpeakImage:isCreateSpeakImage)
        self.view.addSubview(customSearchBar)
        
        self.textField = self.customSearchBar.textSearchView.textField
        self.customSearchBar.delegate = self
        self.customSearchBar.textSearchView.delegate = self
        self.textField.becomeFirstResponder()//获取键盘
    }
    
    //MARKS: 滚动的时候取消键盘
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.textField.resignFirstResponder()
    }

    //MARKS: 画三个圆
    func createThreeArc(){
        customView = UIView(frame: self.frame!)
        customView!.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        //计算圆之间的距离
        let arcPadding = (UIScreen.mainScreen().bounds.width - arcWidthHeight * arcNum) / (arcNum + 1)
        let originY = topPadding! + searchBarHeight + searchBarBottomPadding
        
        //计算第一个圆的位置
        let arcBegin1X:CGFloat = arcPadding
        let arcFrame1:CGRect = CGRectMake(arcBegin1X, originY, arcWidthHeight, arcWidthHeight)
        let arc1 = ContactSearchArcView(frame: arcFrame1, color: arcFillColor, image: UIImage(named: "arc-1")!)
        customView!.addSubview(arc1)
        
        //计算第二个圆的位置
        let arcBegin2X:CGFloat = arcPadding + arcWidthHeight + arcPadding
        let arcFrame2:CGRect = CGRectMake(arcBegin2X, originY, arcWidthHeight, arcWidthHeight)
        let arc2 = ContactSearchArcView(frame: arcFrame2, color: arcFillColor, image: UIImage(named: "arc-2")!)
        customView!.addSubview(arc2)
        
        //计算第三个圆的位置
        let arcBegin3X:CGFloat = UIScreen.mainScreen().bounds.width - arcWidthHeight - arcPadding
        let arcFrame3:CGRect = CGRectMake(arcBegin3X, originY, arcWidthHeight, arcWidthHeight)
        let arc3 = ContactSearchArcView(frame: arcFrame3, color: arcFillColor, image: UIImage(named: "arc-3")!)
        customView!.addSubview(arc3)
        
        let label1BeginX = (arcFrame1.width - labelWidth) / 2 + arcFrame1.origin.x
        let label2BeginX = (arcFrame2.width - (labelWidth - 15)) / 2 + arcFrame2.origin.x
        let label3BeginX = (arcFrame3.width - labelWidth) / 2 + arcFrame3.origin.x
        //MARKS: 添加圆底部文字
        let label1 = createLabel(CGRectMake(label1BeginX, arcFrame1.origin.y + arcFrame1.height + arcBottomPadding, labelWidth, labelHeight),string: "朋友圈")
        customView!.addSubview(label1)
        
        let label2 = createLabel(CGRectMake(label2BeginX, arcFrame2.origin.y + arcFrame2.height + arcBottomPadding, labelWidth - 15, labelHeight),string: "文章")
        customView!.addSubview(label2)
        
        let label3 = createLabel(CGRectMake(label3BeginX, arcFrame3.origin.y + arcFrame3.height + arcBottomPadding, labelWidth, labelHeight),string: "公众号")
        customView!.addSubview(label3)
        self.view.addSubview(customView!)
    }
    
    func createLabel(frame:CGRect,string:String) -> UILabel{
        let label = UILabel(frame: frame)
        label.text = string
        label.font = UIFont(name: self.fontName, size: 14)
        return label
    }
    
    func createLabel(frame:CGRect,string:String,color:UIColor,fontName:String,fontSize:CGFloat,isAllowNext:Bool,char:String) -> UILabel{
        let label = UILabel(frame: frame)
        label.textAlignment = .Left
        label.font = UIFont(name: fontName, size: fontSize)
        label.textColor = color
        if isAllowNext {
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.ByTruncatingTail//有省略号
        }
        if !char.isEmpty {
            let str = NSMutableAttributedString(attributedString: NSAttributedString(string: string))
            var range:NSRange?
            
            //查找字符串位置
            if judgeIsEnglish(char){
                //获取每个字的第一个字母
                for(var i = 0;i < string.characters.count;i++){
                    let _char = NSString(string:string).substringWithRange(NSMakeRange(i,1))
                    let firstChar = getFirstCharByCharacter(_char)
                    if firstChar.uppercaseString == char.uppercaseString {
                        range = NSRange(location: i,length: 1)
                        let range1 = NSRange(location: 0,length: str.length)
                        str.addAttribute(NSForegroundColorAttributeName, value: self.selectedTextColor, range: range!)
                        str.addAttribute(NSFontAttributeName, value: UIFont(name: fontName, size: fontSize)!, range: range1)
                    }
                }
            } else {
                let _str = NSString(string: string)
                range = _str.rangeOfString(char)
                str.addAttribute(NSForegroundColorAttributeName, value: self.selectedTextColor, range: range!)
                str.addAttribute(NSFontAttributeName, value: UIFont(name: fontName, size: fontSize)!, range: NSRange(location: 0,length: str.length))
            }
            
            
            label.attributedText = str
        } else {
            label.text = string
        }
        
        return label
    }
    
    //创建Photo
    func createPhotoView(frame:CGRect,image:UIImage,bounds:CGFloat) -> UIImageView{
        let photoView = UIImageView(frame: frame)
        photoView.image = image
        if bounds > 0 {
            photoView.layer.masksToBounds = true
            photoView.layer.cornerRadius = bounds
        }
        return photoView
    }
    
    //MARKS: 取消事件
    func cancelClick() {
        self.navigationController?.popViewControllerAnimated(false)
        if self.index >= 0 {
            let rootController = UIApplication.sharedApplication().delegate!.window?!.rootViewController as! UITabBarController
            rootController.selectedIndex = self.index
        }
        
        if self.delegate != nil {
            delegate?.cancelClick?()
        }
    }

    func textFieldChange() {
        let selectedRange = self.textField.markedTextRange
        if selectedRange == nil || selectedRange!.empty {
            self.data = [Contact]()
            if textField.text!.isEmpty {
                customView!.hidden = false
            } else {
                //如果是英文,则根据key搜索
                if judgeIsEnglish(textField.text!) {
                    getContainsDataByEnglish()
                } else {
                    getContainsData()
                }
                
                self.tableView?.reloadData()
                customView!.hidden = true
            }
        }
    }
    
    //判断输入的是否是英文
    func judgeIsEnglish(str:String) -> Bool{
        var isEnglish:Bool = true
        for char in str.utf8 {
            if (char > 64 && char < 91) || (char > 96 && char < 123) {
                
            }else{
                isEnglish = false
                break
            }
        }
        
        return isEnglish
    }
    
    //MARKS: 设置背景色
    func getBackgroundColor() -> UIColor {
        return UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    }
    
    //MARKS: 设置背景色,用于tableviewfooter一致
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = getBackgroundColor()
        return view
    }
    
    //MARKS: 去掉tableview底部空白
    func createFooterForTableView(){
        let view = UIView()
        view.backgroundColor = getBackgroundColor()
        tableView!.tableFooterView = view
    }
    
    //MARKS: 设置tableViewCell高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return tableCellOneHeight
        }
        
        return tableCellHeight
    }
    
    //MARKS: tableView选中事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //set data
        let contact = data[indexPath.row - 1]
        let weChatChatViewController = WeChatChatViewController()
        weChatChatViewController.nagTitle = contact.name
        
        //取消选中状态
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: false)
        self.navigationController!.pushViewController(weChatChatViewController, animated: true)
    }
    
    
    //设置数据
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        /*var cell = tableView.dequeueReusableCellWithIdentifier("Cell\(indexPath.section)\(indexPath.row)")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell\(indexPath.section)\(indexPath.row)")
        }*/
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTableCell",forIndexPath:indexPath) as UITableViewCell
        
        //清除旧数据
        if cell.subviews.count > 0 {
            for subView in cell.subviews {
                subView.removeFromSuperview()
            }
        }
        
        if cell.layer.sublayers?.count > 0 {
            for sublayer in cell.layer.sublayers! {
                sublayer.removeFromSuperlayer()
            }
        }
        
        //画底部线条
        let shape = WeChatDrawView().drawLine(beginPointX: leftPadding, beginPointY: cell.frame.height, endPointX: UIScreen.mainScreen().bounds.width, endPointY: cell.frame.height,color:arcFillColor)
        cell.layer.addSublayer(shape)
        
        if indexPath.row == 0  && self.data.count > 0{
            let label = createLabel(CGRectMake(leftPadding, tableCellOneTopPadding, UIScreen.mainScreen().bounds.width - leftPadding, tabelCellOneTextHeight), string: "联系人", color: UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1), fontName: self.fontName, fontSize: 14, isAllowNext: false,char:"")
            cell.addSubview(label)
            cell.selectionStyle = .None
            return cell
        }
        
        //MARKS: Get group sesssion
        let contact = data[indexPath.row - 1]
        let photoImageView = createPhotoView(CGRectMake(leftPadding, tableCellPadding, tableCellImage, tableCellImage), image: contact.photo!,bounds: 4)
        cell.addSubview(photoImageView)
        
        let textLabel = createLabel(CGRectMake(photoImageView.frame.origin.x + photoRightPadding + photoImageView.frame.width, (photoImageView.frame.height)/2, UIScreen.mainScreen().bounds.width - photoImageView.frame.origin.x - photoRightPadding, labelHeight), string: contact.name, color: UIColor.darkTextColor(), fontName: self.fontName, fontSize: 17, isAllowNext: false,char:textField.text!)
        cell.addSubview(textLabel)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if searchBar!.text!.isEmpty {
            return 0
        }*/
        
        if textField.text!.isEmpty {
            return 0
        }
        
        if self.data.count == 0 {
            return 0
        }

        return self.data.count + 1
    }
    
    //MARKS:计算包含数据
    func getContainsData(){
        let str = textField.text
        for contactSession in sessions {
            for contact in contactSession.contacts{
                if contact.name.containsString(str!){
                    self.data.append(contact)
                }
            }
        }
    }
    
    //MARKS: 计算英文数据
    func getContainsDataByEnglish(){
        let str = textField.text
        for contactSession in sessions {
            let key = contactSession.key
            if key.uppercaseString == str?.uppercaseString {
                for contact in contactSession.contacts{
                    self.data.append(contact)
                }
            } else {
                for contact in contactSession.contacts{
                    let name = contact.name
                    for(var i = 0;i < name.characters.count;i++){
                        let _char = NSString(string:name).substringWithRange(NSMakeRange(i,1))
                        let firstChar = getFirstCharByCharacter(_char)
                        if firstChar.uppercaseString == str?.uppercaseString {
                            self.data.append(contact)
                            break;
                        }
                    }
                }
                
            }
        }
    }
    
    //获取第一个字母
    func getFirstCharByCharacter(char:String) -> String{
        let englishName = Normal().getEnglistByName(String(char)) as String
        let firstChar = englishName.substringToIndex(englishName.startIndex.advancedBy(1))
        return firstChar
    }
}
