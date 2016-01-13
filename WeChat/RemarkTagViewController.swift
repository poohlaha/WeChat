//
//  RemarkTagViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/12.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//备注信息页面
class RemarkTagViewController: WeChatTableViewNormalController {

    @IBOutlet weak var remark: UITextField!
    @IBOutlet weak var addPhoneBtn: UIButton!
    @IBOutlet weak var moreRemarks: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    
    var remarkText:String?
    
    override var CELL_HEADER_HEIGHT:CGFloat {
        get {
            return 40
        }
        
        set {
            self.CELL_HEADER_HEIGHT = newValue
        }
        
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        initFrame()
    }
    
    
    func initFrame(){
        //initTableView()
        initImageView()
        setCellStyleNone(0, y: 0) { (cell) -> () in }
        self.remark.text = remarkText!
        
        //addPhoneBtn.addTarget(self, action: "addTableViewCellRow", forControlEvents: .TouchUpInside)
    }
    
    func initImageView(){
        let layer = photoView.layer
        layer.borderColor = UIColor.grayColor().CGColor
        layer.borderWidth = 1
        //在图片上添加文字
        let textWidth:CGFloat = 142
        let textHeight:CGFloat = 20
        let x = (UIScreen.mainScreen().bounds.width - textWidth) / 2 - 15
        let y = (photoView.bounds.height - textHeight) / 2
        layer.addSublayer(createText(16,string:"添加名片或相关图片",
            frame:CGRectMake(x,y,textWidth,textHeight)))
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CELL_HEADER_HEIGHT
    }
    
    //MARKS: 动态添加cell行
    func addTableViewCellRow(){
        let indexPath = tableView.indexPathForSelectedRow
        let newIndexPath = NSIndexPath(forRow: indexPath!.row, inSection: 2)
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Top)
        self.tableView.endUpdates()
    }
    
    func createText(size:CGFloat,string:String,frame:CGRect) -> CATextLayer{
        let textLayer = CATextLayer()
        textLayer.font = CTFontCreateWithName("AlNile",size,nil)
        textLayer.fontSize = size
        textLayer.frame = frame
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.mainScreen().scale
        textLayer.foregroundColor  = UIColor(red: 143/255, green: 143/255, blue: 143/255, alpha: 1).CGColor
        
        //textLayer.foregroundColor = UIColor.grayColor().CGColor
        textLayer.string = string
        return textLayer
    }
    
    //tableview cell点击事件
    /*
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            self.tableView.endUpdates()
        }
    }*/
}
