//
//  RemarkTagViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/12.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//备注信息页面
class RemarkTagViewController: WeChatTableViewNormalController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

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
        //layer.borderWidth = 1
        layer.addSublayer(drawDashLine(CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 15 * 2, photoView.frame.height)))
        
        //在图片上添加文字
        let textWidth:CGFloat = 142
        let textHeight:CGFloat = 20
        let x = (UIScreen.mainScreen().bounds.width - textWidth) / 2 - 15
        let y = (photoView.bounds.height - textHeight) / 2
        layer.addSublayer(createText(16,string:"添加名片或相关图片",
            frame:CGRectMake(x,y,textWidth,textHeight)))
    }
    
    //绘制虚线
    func drawDashLine(rect:CGRect) -> CAShapeLayer{
        let shape = CAShapeLayer()
        shape.path = UIBezierPath(rect: rect).CGPath
        shape.lineDashPattern = [7]
        shape.lineJoin = kCALineJoinBevel
        shape.strokeColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).CGColor
        shape.fillColor = UIColor.clearColor().CGColor
        shape.lineWidth = 1
        return shape
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
    
    //MARKS: 创建图片上的文字
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
    
    /*************************** SELECT IMAGE *****************************/
    //MARKS: 添加图片
    @IBAction func addImagePhoto(sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    
    // MARKS: 取消的时候默认选中第1个TabBar
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true) { () -> Void in
            self.setDefaultTabBarIndex()
        }
    }
    
    //MARKS: 获取选中图片,默认选中第1个TabBar
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Set photoImageView to display the selected image.
        photoView.image = selectedImage
        //移除文本和边框
        photoView.layer.sublayers = []
        // Dismiss the picker.
        picker.dismissViewControllerAnimated(true) { () -> Void in
            self.setDefaultTabBarIndex()
        }

    }
    
    //MARKS: 默认选中第1个TabBar
    func setDefaultTabBarIndex(){
        let rootController = UIApplication.sharedApplication().delegate!.window?!.rootViewController as! UITabBarController
        rootController.selectedIndex = 1
    }
}
