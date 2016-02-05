//
//  WeChatTableViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/5.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

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
class WeChatTableViewController: UITableViewController,WeChatSearchBarDelegate {
    
    //MARKS: Properties
    var chats = [WeChat]()
    let CELL_HEIGHT:CGFloat = 71
    var searchLabelView:WeChatSearchLabelView?
    var searchView:UIView!
    var customSearchBar:WeChatSearchBar!
    let headerHeight:CGFloat = 40
    let searchHeight:CGFloat = 40
    var sessions = [ContactSession]()
    var topHeight:CGFloat = 0
    var lastPosition:CGPoint = CGPointZero

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessions = ContactModel().contactSesion
        topHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.sharedApplication().statusBarFrame.height
        self.lastPosition = CGPointMake(0, -topHeight)
        /*self.tabBarItem.image = UIImage(named: "contact")?.imageWithRenderingMode(.AlwaysOriginal)
        self.tabBarItem.title = "消息"
        self.tabBarItem.selectedImage = UIImage(named: "contact-touch")?.imageWithRenderingMode(.AlwaysOriginal)*/
        //MARKS: 增加启动时间
        NSThread.sleepForTimeInterval(1.0)
        loadSampleDatas()
        //MARKS: 设置导航行背景及字体颜色
        WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
        self.navigationController?.tabBarController!.tabBar.hidden = false
    }
    
    func loadSampleDatas(){
        for i in 0 ..< 20 {
            if i % 2 == 0 {
                let content = "http://www.apple.com/cn/iphone-6s/technology/"
                let photo = UIImage(named: "image1")!
                let chat = WeChat(title: "银行信用卡中心", content: content, photo: photo)!
                chats.append(chat)
            } else {
                let content = "HI 尊贵哒VIP会员小伙伴,终于等到你了!欢就别走,有事没事来聊天呀~"
                let photo = UIImage(named: "image2")!
                let chat = WeChat(title: "WeChat运动指南", content: content, photo: photo)!
                chats.append(chat)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.tabBarController!.tabBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARKS: 创建header搜索框,用tableHeaderView包起来,当向上滚动到顶部时出现
    func createHeaderView(){
        self.customSearchBar = WeChatSearchBar(frame: CGRectMake(0, 0, tableView.frame.size.width, searchHeight), placeholder: "搜索", cancelBtnText: nil, cancelBtnColor: nil)
        //self.searchView = self.customSearchBar.createSearchView(CGRectMake(0, -self.customSearchBar.frame.height, UIScreen.mainScreen().bounds.width, self.customSearchBar.frame.height),bgColor: self.customSearchBar.backgroundColor)
        self.searchView = self.customSearchBar.createSearchView(CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, self.customSearchBar.frame.height),bgColor: self.customSearchBar.backgroundColor)
        self.searchLabelView = self.customSearchBar.searchLabelView
        searchLabelView!.addGestureRecognizer(WeChatUITapGestureRecognizer(target:self,action: "searchLabelViewTap:"))
        //self.view.addSubview(self.searchView)
        
        let headerView:UIView = UIView()
        headerView.frame = CGRectMake(0,-self.customSearchBar.frame.height,tableView.frame.size.width,self.customSearchBar.frame.height)
        headerView.addSubview(self.searchView)
        tableView.tableHeaderView = headerView
    }
    
    //MARKS: 滚动条事件
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        /*if !self.isUserDrag {
            return
        }*/
        
        let position:CGPoint = scrollView.contentOffset
        print(position.y)
        
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
    
    //MARKS: searchBar触摸事件
    func searchLabelViewTap(searchView:WeChatUITapGestureRecognizer){
        let customView = ContactCustomSearchView()
        customView.index = 0
        customView.sessions = sessions
        customView.delegate = self
        self.navigationController?.pushViewController(customView, animated: false)
    }
    
    //MARKS:取消事件,需要设置scrollView位置
    func cancelClick() {
        
    }
    
    //MARKS: 画底部线条
    func drawLineAtLast(beginX:CGFloat,height:CGFloat) -> CAShapeLayer{
        return WeChatDrawView().drawLine(beginPointX: beginX, beginPointY: height, endPointX: UIScreen.mainScreen().bounds.width, endPointY: height,color:UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1))
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chats.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatTableViewCell", forIndexPath: indexPath) as! WeChatTableViewCell
        
        //set data
        let chat = chats[indexPath.row]
        cell.photoView.image = chat.photo
        cell.title.text = chat.title
        cell.content.text = chat.content
        cell.time.text = chat.time
        cell.title.lineBreakMode = .ByTruncatingTail
        return cell
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
