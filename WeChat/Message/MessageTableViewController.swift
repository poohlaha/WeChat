//
//  WeChatTableViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/5.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit
import CoreLocation

// extension String
extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = self.startIndex.advancedBy(r.endIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
}

//消息页面
class MessageTableViewController: WeChatCustomTableViewController,WeChatSearchBarDelegate,WeChatCustomTableViewControllerDelete,CLLocationManagerDelegate {
    
    //MARKS: Properties
    var chats = [Message]()
    let CELL_HEIGHT:CGFloat = 71
    var searchLabelView:WeChatSearchLabelView?
    var searchView:UIView!
    var customSearchBar:WeChatSearchBar!
    let headerHeight:CGFloat = 40
    let searchHeight:CGFloat = 40
    var topHeight:CGFloat = 0
    var lastPosition:CGPoint = CGPointZero
    var alertViews:[AlertView] = [AlertView]()
    
    //MARKS: 自定义弹出框属性
    let customAlertWidth:CGFloat = 150
    let customAlertHeight:CGFloat = 180
    let customAlertRightPadding:CGFloat = 5
    let customAlertTopPadding:CGFloat = 5
    
    var isCustomAlertViewShow:Bool = false
    var customAlerView:CustomAlertView?
    
    //MARKS: 导航条右侧+按钮事件
    @IBAction func addMessageItems(sender: UIBarButtonItem) {
        if !isCustomAlertViewShow {
            createCustomAlertView()
            isCustomAlertViewShow = true
        } else {
            removeCustomAlertView()
            isCustomAlertViewShow = false
        }
    }
    
    //MARKS: 移除customAlertView
    func removeCustomAlertView(){
        let controller = self.parentViewController
        for subView in (controller?.parentViewController!.view.subviews)!{
            if subView.isKindOfClass(CustomAlertView) {
                subView.removeFromSuperview()
            }
        }
        
        isCustomAlertViewShow = false
    }
    
    //MARKS: 创建customAlertView
    func createCustomAlertView(){
        let frame = CGRectMake(self.view.frame.width - customAlertRightPadding - customAlertWidth, topHeight + customAlertTopPadding, customAlertWidth, customAlertHeight)
        
        //计算controlFrame在customAlertView中的坐标
        let imageWH:CGFloat = 20
        let imagePadding:CGFloat = 15
        let controlBeginX:CGFloat = frame.width - imageWH - imagePadding
        let controlBeginY:CGFloat = topHeight + 5
        let controlFrame = CGRectMake(controlBeginX, controlBeginY, imageWH, imageWH)
        
        if self.customAlerView == nil {
           //self.customAlerView = CustomAlertView(frame: frame, controlFrame: controlFrame, bgColor: UIColor(patternImage: UIImage(named: "alertView-bg")!), textColor: nil, fontName: nil, fontSize: 16, alertViews: self.alertViews)
            self.customAlerView = CustomAlertView(frame: frame, controlFrame: controlFrame, bgColor: nil, textColor: nil, fontName: nil, fontSize: 16, alertViews: self.alertViews)
        }
        
        let controller = self.parentViewController
        controller?.parentViewController!.view.addSubview(self.customAlerView!)
    }
    
    //MARKS: 创建弹出框
    func createAlertViews(){
        if self.alertViews.count == 0 {
            let alertView1 = AlertView(imageName: "alertView-group", string: "发起群聊",flag: 0)
            let alertView2 = AlertView(imageName: "alertView-addFriend", string: "添加朋友",flag: 1)
            let alertView3 = AlertView(imageName: "alertView-scan", string: "扫一扫",flag: 2)
            let alertView4 = AlertView(imageName: "alertView-money", string: "收付款",flag: 3)
            self.alertViews.append(alertView1)
            self.alertViews.append(alertView2)
            self.alertViews.append(alertView3)
            self.alertViews.append(alertView4)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.sharedApplication().statusBarFrame.height
        self.lastPosition = CGPointMake(0, -topHeight)
        //MARKS: 增加启动时间
        NSThread.sleepForTimeInterval(1.0)
        loadSampleDatas()
        //MARKS: 设置导航行背景及字体颜色
        WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
        
        self.delegate = self
        //创建导航条左侧图片
        createBarItem(true)
        createAlertViews()
        locationManager.delegate = self
    }
    
    //MARKS: 移除alertView
    func leftBarItemClick() {
         self.removeCustomAlertView()
    }
    
    //MARKS: 当视图消失的时候移除customAlertView
    override func viewWillDisappear(animated: Bool) {
        self.removeCustomAlertView()
        //去掉手势
        addOrRemoveRecognizer(false)
    }
    
    func loadSampleDatas(){
        for i in 0 ..< 20 {
            if i % 2 == 0 {
                let content = "http://www.apple.com/cn/iphone-6s/technology/"
                let photo = UIImage(named: "image1")!
                let chat = Message(title: "银行信用卡中心", content: content, photo: photo)!
                chats.append(chat)
            } else {
                let content = "HI 尊贵哒VIP会员小伙伴,终于等到你了!欢就别走,有事没事来聊天呀~"
                let photo = UIImage(named: "image2")!
                let chat = Message(title: "WeChat运动指南", content: content, photo: photo)!
                chats.append(chat)
            }
        }
    }
    
    //MARKS: 添加获取权限对话框
    //.NotDetermined 表示用户还未对该应用的定位权限做出选择
    /*在 info.plist里加入定位描述（Value值为空也可以）：
         NSLocationWhenInUseDescription ：允许在前台获取GPS的描述
         NSLocationAlwaysUsageDescription ：允许在后台获取GPS的描述
   */
    
    let locationManager = CLLocationManager()
    
    override func viewWillAppear(animated: Bool) {
        //self.navigationController?.tabBarController!.tabBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
        //添加手势
        addOrRemoveRecognizer(true)
        if !NSUserDefaults.standardUserDefaults().boolForKey("everLaunched") {
            if CLLocationManager.locationServicesEnabled() {
                
                locationManager.desiredAccuracy = kCLLocationAccuracyBest//控制定位精度,越高耗电量越大
                locationManager.distanceFilter = 100//控制定位服务更新频率。单位是“米”
                locationManager.startUpdatingLocation()
                if CLLocationManager.authorizationStatus() == .NotDetermined {
                if locationManager.respondsToSelector("requestAlwaysAuthorization") {
                    locationManager.requestWhenInUseAuthorization()//用户使用的时候才用到定位
                }
                }
            }else {
                let alert = UIAlertController(title: "打开定位开关", message:"定位服务未开启,请进入系统设置>隐私>定位服务中打开开关,并允许WeChat使用定位服务", preferredStyle: .Alert)
                let tempAction = UIAlertAction(title: "取消", style: .Cancel) { (action) in
                }
                let callAction = UIAlertAction(title: "立即设置", style: .Default) { (action) in
                    let url = NSURL.init(string: UIApplicationOpenSettingsURLString)
                    if(UIApplication.sharedApplication().canOpenURL(url!)) {
                        UIApplication.sharedApplication().openURL(url!)
                    }
                }
                alert.addAction(tempAction)
                alert.addAction(callAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARKS: 创建header搜索框,用tableHeaderView包起来,当向上滚动到顶部时出现
    func createHeaderView(){
        self.customSearchBar = WeChatSearchBar(frame: CGRectMake(0, 0, tableView.frame.size.width, searchHeight), placeholder: "搜索", cancelBtnText: nil, cancelBtnColor: nil,isCreateSpeakImage:true)
        //self.searchView = self.customSearchBar.createSearchView(CGRectMake(0, -self.customSearchBar.frame.height, UIScreen.mainScreen().bounds.width, self.customSearchBar.frame.height),bgColor: self.customSearchBar.backgroundColor)
        self.searchView = self.customSearchBar.createSearchView(CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, self.customSearchBar.frame.height),bgColor: self.customSearchBar.backgroundColor)
        self.searchLabelView = self.customSearchBar.searchLabelView
        searchLabelView!.addGestureRecognizer(WeChatUITapGestureRecognizer(target:self,action: "searchLabelViewTap:"))
        //self.view.addSubview(self.searchView)
        
        let headerView:UIView = UIView()
        headerView.layer.addSublayer(WeChatDrawView().drawLineAtLast(0,height: self.searchView.frame.height))
        headerView.frame = CGRectMake(0,-self.customSearchBar.frame.height,tableView.frame.size.width,self.customSearchBar.frame.height)
        headerView.addSubview(self.searchView)
        tableView.tableHeaderView = headerView
    }
    
    
    //MARKS: 滚动条事件,移除customAlertView
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if !self.isUserDrag {
            return
        }
        
        self.removeCustomAlertView()
        let position:CGPoint = scrollView.contentOffset
        
        let newY = scrollView.contentOffset.y
        if(self.startY - newY > 0) {//向上滚动
            if position.y < lastPosition.y {
                //lastPosition = CGPointMake(position.x, -(searchHeight + topHeight))
                //scrollView.setContentOffset(lastPosition, animated: true)
                //self.view.frame.origin = CGPointMake(self.view.frame.origin.x,searchHeight)
                self.createHeaderView()
            }
        } else if self.startY - newY < 0{//向下滚动
            if position.y > lastPosition.y {
                /*if self.view.frame.origin.y > 0 {
                    self.view.frame.origin = CGPointMake(self.view.frame.origin.x,0)
                }*/
            }
            
        }
        
        self.startY = scrollView.contentOffset.y
    }
    
    var startY:CGFloat = 0
    var isUserDrag:Bool = false
    
    //MARKS: 即将开始滚动
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.isUserDrag = true
        self.startY = scrollView.contentOffset.y
    }
    
    //MARKS: 滚动结束
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.isUserDrag = false
    }
    
    //MARKS: searchBar触摸事件,移除customAlertView
    func searchLabelViewTap(searchView:WeChatUITapGestureRecognizer){
        self.removeCustomAlertView()
        let customView = ContactCustomSearchView()
        customView.index = 0
        customView.sessions = ContactModel().contactSesion
        customView.delegate = self
        self.navigationController?.pushViewController(customView, animated: false)
    }
    
    //MARKS:取消事件,需要设置scrollView位置
    func cancelClick() {
        
    }
  
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chats.count
    }

    //MARKS: 添加TableViewCell弹簧效果
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatTableViewCell", forIndexPath: indexPath) as! MessageTableViewCell
        
        //set data
        let chat = chats[indexPath.row]
        cell.photoView.image = chat.photo
        cell.title.text = chat.title
        cell.content.text = chat.content
        cell.time.text = chat.time
        cell.title.lineBreakMode = .ByTruncatingTail
        
        cell.photoView.layer.masksToBounds = true
        cell.photoView.layer.cornerRadius = imageWidth / 2
        return cell
    }
    
    var paddingLeft:CGFloat = 15
    var imageWidth:CGFloat = 55
    var imageHeight:CGFloat = 55
    var topOrBottomPadding:CGFloat = 8
    
    var titleTopPaddingFormImage:CGFloat = 5
    var photoRightPadding:CGFloat = 10
    
    var timeWidth:CGFloat = 60
    var timeLeftPadding:CGFloat = 10
    var titleLabelHeight:CGFloat = 0
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = WeChatTableViewCell(style: .Default, reuseIdentifier: "Cell\(indexPath.section)\(indexPath.row)")
        
        //set data
        let chat = chats[indexPath.row]
        
        let photoView = createPhotoView(CGRectMake(paddingLeft, topOrBottomPadding, imageWidth, imageHeight), image: chat.photo!,bounds: imageWidth / 2)
        
        photoView.tag = 1000
        cell.addSubview(photoView)
        
        titleLabelHeight = imageHeight / 2
        
        let title = createLabel(CGRectMake(photoView.frame.origin.x + photoRightPadding + photoView.frame.width, photoView.frame.origin.y + topOrBottomPadding, UIScreen.mainScreen().bounds.width - photoView.frame.origin.x - imageWidth - photoRightPadding, titleLabelHeight), string: chat.title, color: UIColor.blackColor(), fontName: "AlNile", fontSize: 17)
        title.tag = 1001
        title.lineBreakMode = .ByTruncatingTail
        cell.addSubview(title)
        
        let time = createLabel(CGRectMake(UIScreen.mainScreen().bounds.width - timeWidth, title.frame.origin.y, timeWidth, title.frame.height), string: chat.time, color: UIColor.lightGrayColor() ,fontName: "AlNile", fontSize: 12)
        time.tag = 1002
        cell.addSubview(time)
        
        let content = createLabel(CGRectMake(title.frame.origin.x, title.frame.origin.y + title.frame.height, UIScreen.mainScreen().bounds.width - photoView.frame.origin.x - imageWidth - photoRightPadding - timeWidth / 2, imageHeight - titleTopPaddingFormImage * 2 - title.frame.height), string: chat.content, color: UIColor.lightGrayColor(), fontName: "AlNile", fontSize: 14)
        content.tag = 1003
        cell.addSubview(content)
        
        cell.toggleView(CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.width, cell.frame.height),
            subViewTags:[1000,1001,1002,1003])
        
        return cell
    }*/
    
    func createLabel(frame:CGRect,string:String,color:UIColor,fontName:String,fontSize:CGFloat) -> UILabel{
        let label = UILabel(frame: frame)
        label.textAlignment = .Left
        label.font = UIFont(name: fontName, size: fontSize)
        label.textColor = color
        label.numberOfLines = 1
        label.text = string
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
    
    //MARKS: 设置每列高度
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CELL_HEIGHT
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    //MARKS: 从右向左滑动
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
       
    }
    
    //MARKS: set custom editing buttons
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let cancelUnfllowAction = UITableViewRowAction(style: .Normal, title: "取消关注") { (action:UITableViewRowAction, index:NSIndexPath) -> Void in
            
            let chat = self.chats[indexPath.row]
            /*let cancelMenu = UIAlertController(title: nil, message: "取消关注“\(chat.title)”后将不再收到其下发的消息", preferredStyle:UIAlertControllerStyle.ActionSheet)
            
            let cancelAction = UIAlertAction(title: "不再关注", style: UIAlertActionStyle.Destructive, handler: nil)
            let alsoAction = UIAlertAction(title: "仍然关注", style: UIAlertActionStyle.Cancel, handler: nil)
            
            cancelMenu.addAction(cancelAction)
            cancelMenu.addAction(alsoAction)
            self.presentViewController(cancelMenu, animated: true, completion: nil)*/
            
            let controller = self.parentViewController
            
            let weChatAlert = WeChatBottomAlert(frame: CGRectMake(0,-1,UIScreen.mainScreen().bounds.width,0),titles: ["取消关注“\(chat.title)”后将不再收到其下发的消息","不再关注","仍然关注"],colors:[UIColor.grayColor(),UIColor.redColor(),UIColor.blackColor()],fontSize: 0)
            //self.view.addSubview(weChatAlert)
            controller?.parentViewController!.view.addSubview(weChatAlert)
            
            //let windows = UIApplication.sharedApplication().windows
            self.view.bringSubviewToFront(weChatAlert)
        }
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "删除") { (action:UITableViewRowAction, index:NSIndexPath) -> Void in
            self.chats.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        //from right to left
        return [deleteAction,cancelUnfllowAction]
    }
    
    //MARKS: tableViewCell选中事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //set data
        let chat = chats[indexPath.row]
        let weChatChatViewController = WeChatChatViewController()
        weChatChatViewController.nagTitle = chat.title
        weChatChatViewController.hidesBottomBarWhenPushed = true//隐藏底部tabbar
        
        //取消选中状态
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: false)
        
        self.navigationController?.pushViewController(weChatChatViewController, animated: true)
        
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
