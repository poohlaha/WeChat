//
//  SocialDetailViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/11.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//社交资料页面
class SocialDetailViewController: WeChatTableFooterBlankController {

    @IBOutlet weak var personal: UILabel!
    @IBOutlet weak var source: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFrame()
    }
    
    func initFrame(){
        initTableView()
        
        //MARKS: 去掉tableview底部空白
        createFooterForTableView()
    }
    
    //MARKS: 重新设置tableviewcell高度
    override func viewDidLayoutSubviews() {
        initData()
    }
    
    //MARKS: Init Data
    func initData(){
        //自动换行
        personal.numberOfLines = 0
        personal.lineBreakMode = NSLineBreakMode.ByWordWrapping
        personal.text = "我用尽所有力气去爱你,却发现被感动的只有我自己..."
        source.text = "通过扫一扫添加"
        
        let cell1 = setCellStyleNone(0, y: 0,callback: { (cell) -> (Void) in
            cell.frame.size = CGSize(width: cell.frame.size.width, height: 60)
        })
        
        setCellStyleNone(0, y: 1,callback: { (cell) -> (Void) in
            cell.frame.origin = CGPoint(x: 0,y: cell1.frame.origin.y + cell1.frame.size.height)
        })
    
    }
    
    func addNumberTextClick(){
        
    }
    
    /*
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Remove seperator inset
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // Explictly set your cell's layout margins
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsMake(20, 0, 0, 0);
        }
        
    }*/
    
    /*
    override func viewDidLayoutSubviews() {
        tableView.separatorInset = UIEdgeInsetsMake(20,0,0,0)
        tableView.layoutMargins = UIEdgeInsetsMake(20,0,0,0)
    }*/
    
}
