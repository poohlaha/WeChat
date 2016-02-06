//
//  ContactAddFriendsTableViewController.swift
//  WeChat
//
//  Created by Smile on 16/2/6.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//添加朋友页面
class ContactAddFriendsTableViewController: WeChatTableViewNormalController,WeChatSearchBarDelegate {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var myWeChatNumLabel: UILabel!
    @IBOutlet weak var twoDimeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFrame()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    
    func initFrame(){
        createFooterForTableView()
        tableView.separatorStyle = .None
        self.navigationController?.tabBarController!.tabBar.hidden = true
        
        //设置第二个tableView Cell背景色和tableView一样
        let indexPath = NSIndexPath(forRow: 1, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.backgroundColor = getBackgroundColor()
        
        self.navigationItem.title = "添加朋友"
        
        tableView.backgroundColor = getBackgroundColor()
        
        //画分割线
        drawLastLine()

        searchView.addGestureRecognizer(WeChatUITapGestureRecognizer(target:self,action: "searchViewTap:"))
    }
    
    
    //MARKS:画分割线
    func drawLastLine(){
        for(var j = 0;j < tableView.numberOfRowsInSection(0);j++){
            if j == 1 {
                continue
            }
            
            let indexPath = NSIndexPath(forRow: j, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.selectionStyle = .None
            if cell == nil {
                continue
            }
            
            if j == 0 || j == 2 {
                cell!.layer.addSublayer(WeChatDrawView().drawLineAtLast(0,height: 0))
                if j == 0 {
                    cell!.layer.addSublayer(WeChatDrawView().drawLineAtLast(0,height: cell!.frame.height))
                } else {
                    cell!.layer.addSublayer(WeChatDrawView().drawLineAtLast(20,height: cell!.frame.height))
                }
                
            } else {
                if j == (tableView.numberOfRowsInSection(0) - 1) {
                    cell!.layer.addSublayer(WeChatDrawView().drawLineAtLast(0,height: cell!.frame.height))
                }else {
                    cell!.layer.addSublayer(WeChatDrawView().drawLineAtLast(20,height: cell!.frame.height))
                }
            }
            
        }
    }
    
    //MARKS:searchView点击事件
    func searchViewTap(view:WeChatUITapGestureRecognizer){
        let customView = ContactCustomSearchView()
        customView.index = 1
        customView.sessions = ContactModel().contactSesion
        customView.delegate = self
        customView.iscreateThreeArc = false
        customView.isCreateSpeakImage = false
        self.navigationController?.pushViewController(customView, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARKS: 设置背景色,用于tableviewfooter一致
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //let _section = tableView.headerViewForSection(section)
        let view = UIView()
        view.backgroundColor = getBackgroundColor()
        return view
    }
    
    //MARKS: 去掉tableview底部空白
    func createFooterForTableView(){
        let view = UIView()
        view.backgroundColor = getBackgroundColor()
        tableView.tableFooterView = view
    }
}
