//
//  ContactViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/8.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    //@IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let CELL_HEIGHT:CGFloat = 54
    let CELL_HEADER_HEIGHT:CGFloat = 25
    let CELL_FOOTER_HEIGHT:CGFloat = 0
    var totalCount = 0
    
    var sessions = [ContactSession]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARKS: Init Frame
        initFrame()
    }

    //MARKS: Init Data
    func initContactData(){
        let contactModel = ContactModel()
        sessions = contactModel.contactSesion
        totalCount = contactModel.contacts.count
    }
    
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
        
        //改变索引的颜色
        tableView.sectionIndexColor  = UIColor.grayColor()
        initContactData()
        initSearchBar()
        addFooter()
    }
    
    //MARKS: Init SearchBar And Add Header View
    func initSearchBar(){
        tableView.frame = UIScreen.mainScreen().bounds
        print(tableView.frame.height)
        tableView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        let headerView:UIView = UIView(frame: CGRectMake(0,0,tableView.frame.size.width,40))
        let searchBar = UISearchBar(frame: CGRectMake(0,0,tableView.frame.size.width,40))
        
        //设置透明
        searchBar.placeholder = "搜索"
        searchBar.translucent = true
        searchBar.barStyle = .Default
        searchBar.showsCancelButton = false
        searchBar.showsScopeBar = false
        //searchBar.barTintColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        //searchBar.backgroundImage = UIImage(named: "search-bg")
        searchBar.barStyle = UIBarStyle.Default
        searchBar.searchBarStyle = UISearchBarStyle.Default
        searchBar.showsBookmarkButton = false
        searchBar.showsSearchResultsButton = false
        searchBar.delegate = self
        
        headerView.addSubview(searchBar)
        tableView.tableHeaderView = headerView
        //let searchBar = SearchBarViewController()
        //tableView.tableHeaderView = searchBar.view
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
        
         //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        //MARKS: Get group sesssion
        let session = sessions[indexPath.section]
        let contact = session.contacts[indexPath.row]
        /*let row = indexPath.row
        let section = indexPath.section
        print(row)
        print(section)
        print(tableView.numberOfSections)*/
        
        //set data
        cell.nameLabel.text = contact.name
        cell.photoImageView.image = contact.photo
        
        //MARKS: 设置分割线到最右边
        cell.separatorInset = UIEdgeInsetsZero
        cell.selectionStyle = .Blue
        return cell
    }
    
    //MARKS: 返回每组头标题名称
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sessions[section].key
    }
    
    /****************************** index ***********************************/
    //MARKS: 实现索引数据源代理方法
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return UILocalizedIndexedCollation.currentCollation().sectionIndexTitles
    }
    
    //MARKS: 响应点击索引时的委托方法
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        var index:Int = 0
        for i in UILocalizedIndexedCollation.currentCollation().sectionTitles {
            //判断索引值和组名称相等,返回坐标
            if i == title {
                return index
            }
            
            index++
        }
        
        return 0
    }
}
