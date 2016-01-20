//
//  ContactViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/8.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//联系人页面,这里应该使用UITableViewController
class ContactViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,WeChatPropDelegate {

    //@IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var totalCount = 0
    //MARKS: 重写协议的属性
    var CELL_HEIGHT:CGFloat {
        get {
            return 54
        }
        
        set {
            self.CELL_HEIGHT = newValue
        }
    }
    
    var CELL_HEADER_HEIGHT:CGFloat {
        get {
            return 25
        }
        
        set {
            self.CELL_HEADER_HEIGHT = newValue
        }
    }
    
    var CELL_FOOTER_HEIGHT:CGFloat {
        get {
            return 0
        }
        
        set {
            self.CELL_FOOTER_HEIGHT = newValue
        }
    }
    
    
    var searchBar:UISearchBar?
    
    var sessions = [ContactSession]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARKS: Init Frame
        initFrame()
        //let refreshView = WeChatRefreshView(scrollView: tableView)
        //refreshView.delegate = self
        //self.tableView.addSubview(refreshView)
    }
    
    func refresh(refreshView: WeChatRefreshView) {
        delay(4) {
            refreshView.endRefresh()
        }
    }
    
    func delay(seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }
    
    //MARKS: Init Data
    func initContactData(){
        let contactModel = ContactModel()
        sessions = contactModel.contactSesion
        totalCount = contactModel.contacts.count
    }
    
    //MARKS: 禁止横屏
    /*override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }*/
    
    func initFrame(){
        //tableView = UITableView(frame: UIScreen.mainScreen().bounds,style:UITableViewStyle.Grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //MARKS: register table view cell
        //tableView.registerClass(ContactTableViewCell.self, forCellReuseIdentifier: "ContactTableViewCell")
        tableView.scrollEnabled = true
        tableView.showsVerticalScrollIndicator = true
        
        //self.view.addSubview(self.tableView!)
        //self.automaticallyAdjustsScrollViewInsets = false
        //MARKS: remove blank at bottom
        self.edgesForExtendedLayout = .Bottom
        
        //MARKS: 设置导航行背景及字体颜色
        WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
        
        //改变索引的颜色
        //tableView.sectionIndexColor  = UIColor.grayColor()
        initContactData()
        initSearchBar()
        initTableIndex()
        addFooter()
    }
    
    //MARKS: Init SearchBar And Add Header View
    func initSearchBar(){
        //tableView.frame = UIScreen.mainScreen().bounds
        tableView.frame.size = self.view.frame.size
        tableView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        let headerView:UIView = UIView(frame: CGRectMake(0,0,tableView.frame.size.width,40))
        searchBar = UISearchBar(frame: CGRectMake(0,0,tableView.frame.size.width,40))
        
        //设置透明
        searchBar!.placeholder = "搜索"
        searchBar!.translucent = true
        searchBar!.barStyle = .Default
        searchBar!.showsCancelButton = false
        searchBar!.showsScopeBar = false
        //searchBar.barTintColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        //searchBar.backgroundImage = UIImage(named: "search-bg")
        searchBar!.barStyle = UIBarStyle.Default
        searchBar!.searchBarStyle = UISearchBarStyle.Default
        searchBar!.showsBookmarkButton = false
        searchBar!.showsSearchResultsButton = false
        searchBar!.delegate = self
        
        headerView.addSubview(searchBar!)
        tableView.tableHeaderView = headerView
    }
    
    //MARKS:当焦点在输入框的时候
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        let customView = ContactCustomSearchView()
        customView.index = 1
        customView.sessions = self.sessions
        self.presentViewController(customView, animated: false) { () -> Void in
            
        }
        return false
    }
    
    //MARKS: Init tableview index
    func initTableIndex(){
        let width:CGFloat = 20
        let height:CGFloat = 200
        
        let tableviewIndex = TableViewIndex(frame: CGRectMake(tableView.frame.width - width,UIScreen.mainScreen().bounds.height / 2 - height,width,UIScreen.mainScreen().bounds.height),tableView: tableView!,datas: sessions)
        self.view.addSubview(tableviewIndex)
        
    }
    
    //MARKS: Add Footer View
    func addFooter(){
        let footerView:UIView = UIView(frame: CGRectMake(0,0,tableView.frame.size.width,40))
        let footerlabel:UILabel = UILabel(frame: footerView.bounds)
        footerlabel.textColor = UIColor.grayColor()
        //footerlabel.backgroundColor = UIColor.clearColor()
        footerlabel.font = UIFont.systemFontOfSize(16)
        footerlabel.text = "共\(totalCount)位联系人"
        footerlabel.textAlignment = .Center
        footerView.addSubview(footerlabel)
        footerView.backgroundColor = UIColor.whiteColor()
        tableView.tableFooterView = footerView
    }
    
    /****************************** tableView ***********************************/
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return CELL_HEIGHT
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CELL_HEADER_HEIGHT
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CELL_FOOTER_HEIGHT
    }
    
    //MARKS: 返回分组数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sessions.count
    }
    
    //MARKS: 返回每组行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let session = sessions[section] as ContactSession
        return session.contacts.count
    }
    
    //MARKS: 返回每行的单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactTableViewCell", forIndexPath: indexPath) as! ContactTableViewCell
        
        //MARKS: Get group sesssion
        let session = sessions[indexPath.section]
        let contact = session.contacts[indexPath.row]
        
        //set data
        cell.nameLabel.text = contact.name
        cell.photoImageView.image = contact.photo
        
        //MARKS: 设置分割线到最右边
        //cell.separatorInset = UIEdgeInsetsZero
        //cell.selectionStyle = .Blue
        
        //MARKS:因为cell长度超出竖屏范围,故重新设置其长度
        cell.resize((searchBar?.frame.width)!)
        return cell
    }
    
    //重新设置开始加载section的cell长度
    override func viewDidAppear(animated: Bool) {
        let sections = tableView.numberOfSections
        for(var i = 0; i < sections; i++){
            let rows = tableView.numberOfRowsInSection(i)
            for(var j = 0;j < rows;j++){
                let indexPath = NSIndexPath(forRow: j, inSection: i)
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                if cell == nil {
                    break;
                }
                
                (cell as! ContactTableViewCell).resize((searchBar?.frame.width)!)
            }
        }
        
    }
    
    //MARKS: 返回每组头标题名称
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sessions[section].key
    }
    
    //MARKS: 开启tableview编辑模式
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    //MARKS: 自定义向右滑动菜单
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let remarkAction = UITableViewRowAction(style: .Normal, title: "备注") { (action:UITableViewRowAction, index:NSIndexPath) -> Void in
            let session = self.sessions[index.section]
            let contact = session.contacts[indexPath.row]
            
            //根据storyboard获取controller
            let sb = UIStoryboard(name:"Contact-Detail", bundle: nil)
            let remarkTagController = sb.instantiateViewControllerWithIdentifier("RemarkTagController") as! RemarkTagViewController
            
            remarkTagController.remarkText = contact.name
            self.navigationController?.pushViewController(remarkTagController, animated: true)
            
            //让cell可以自动回到默认状态，所以需要退出编辑模式
            tableView.editing = false
        }
        
        return [remarkAction]
    }
    
    //MARKS :跳转到下一个页面传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowResourceDetail" {
             if let indexPath = self.tableView.indexPathForSelectedRow{
                let destinationController = segue.destinationViewController as! ResourceDetailViewController
                let session = sessions[indexPath.section]
                let contact = session.contacts[indexPath.row]
                destinationController.indexPath = indexPath
                destinationController.parentController = self
                destinationController.photoImage = contact.photo
                destinationController.nameText = contact.name
                destinationController.weChatNumberText = "微信号:  test00\(indexPath.row + 1)"
                destinationController.photoNumberText = contact.phone
                //MARKS: 跳转视图后取消tableviewcell选中事件
                self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
            }
            
        }
    }
    
    /******************************orignal index ***********************************/
    //MARKS: 实现索引数据源代理方法
    /*func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return UILocalizedIndexedCollation.currentCollation().sectionIndexTitles
    }*/
    
    //MARKS: 响应点击索引时的委托方法
    /*func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        var index:Int = 0
        for i in UILocalizedIndexedCollation.currentCollation().sectionTitles {
            //判断索引值和组名称相等,返回坐标
            if i == title {
                return index
            }
            
            index++
        }
        
        return 0
    }*/
}
