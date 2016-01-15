//
//  WeChatTableViewDelegate.swift
//  WeChat
//
//  Created by Smile on 16/1/11.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

@objc protocol WeChatPropDelegate {
    optional var CELL_HEIGHT:CGFloat {get set}
    optional var CELL_HEADER_HEIGHT:CGFloat{get set}
    optional var CELL_FOOTER_HEIGHT:CGFloat{get set}
}


class WeChatTableViewNormalController:UITableViewController,WeChatPropDelegate {
    
    //MARKS: 重写协议的属性
    var CELL_HEADER_HEIGHT:CGFloat {
        get {
            return 20
        }
        
        set {
            self.CELL_HEADER_HEIGHT = newValue
        }
    }
    
    var CELL_FOOTER_HEIGHT:CGFloat {
        get {
            return 1
        }
        
        set {
            self.CELL_FOOTER_HEIGHT = newValue
        }
    }
    
    //MARKS: 获取随机数
    func getRandom(min:UInt32,max:UInt32) -> UInt32 {
        let min:UInt32 = min
        let max:UInt32 = max
        let num = arc4random_uniform(max - min) + min
        return num
    }
    
    //MARKS: 初始化tableview一些属性
    func initTableView(){
        tableView.scrollEnabled = false
        tableView.backgroundColor = getBackgroundColor()
    }
    
    //MARKS: 设置背景色
    func getBackgroundColor() -> UIColor {
        return UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    }
    
    //MARKS: 取消tableview cell选中状态
    func setCellStyleNone(x:Int,y:Int,callback:(cell:UITableViewCell) -> ()) -> UITableViewCell{
        var _cell:UITableViewCell = UITableViewCell()
        for(var i = 0;i < tableView.numberOfSections; i++){
            for(var j = 0;j < tableView.numberOfRowsInSection(i);j++){
                let indexPath = NSIndexPath(forRow: j, inSection: i)
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.selectionStyle = .None
                
                if i == x && j == y {
                    callback(cell: cell!)
                    _cell = cell!
                }
            }
        }
        
        return _cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CELL_HEADER_HEIGHT
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CELL_FOOTER_HEIGHT
    }
}

/*
 * MARKS: 自定义tableViewController,用于去掉底部空白
 */
class WeChatTableFooterBlankController:WeChatTableViewNormalController {
    
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