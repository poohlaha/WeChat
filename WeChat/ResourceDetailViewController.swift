//
//  ResourceDetailViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/10.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//详细资料页面
class ResourceDetailViewController: WeChatTableFooterBlankController{
    
    //MARKS: Properties
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var weChatNumber: UILabel!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    //MARKS; 发消息按钮事件
    @IBAction func sendMessage(sender: UIButton) {
        let weChatChatViewController = WeChatChatViewController()
        weChatChatViewController.nagTitle = self.nameText
        self.navigationController?.pushViewController(weChatChatViewController, animated: true)
    }
    
    var nameText:String?
    var photoImage:UIImage?
    var weChatNumberText:String?
    var indexPath:NSIndexPath?
    var photoNumberText:String?
    var parentController:ContactViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFrame()
        initData()
        initImages()
    }
    
    //MARKS: 初始化图片控件
    func initImages(){
        var images:[UIImage] = [UIImage]()
        images.append(UIImage(named: "contact2")!)
        images.append(UIImage(named: "contact3")!)
        images.append(UIImage(named: "contact1")!)
        images.append(UIImage(named: "contact2")!)
        
       let indexPath = NSIndexPath(forRow: 1, inSection: 2)
       let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let weChatPhotoView = WeChatContactPhotoView(frame: CGRectMake(90, 0, UIScreen.mainScreen().bounds.width - 90 - 30, cell!.frame.height), images: images)
        cell?.addSubview(weChatPhotoView)
        self.navigationController?.tabBarController!.tabBar.hidden = true
    }
    
    func initFrame(){
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        //设置右侧按钮文字为三个点
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "● ● ●", style: UIBarButtonItemStyle.Plain, target: self, action: "moreBtnClick")
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:UIFont(name: "Arial-BoldMT", size: 10)!], forState: UIControlState.Normal)
        
        initTableView()
        //MARKS: 去掉tableview底部空白
        createFooterForTableView()
        //添加点击事件
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "phoneClick:")
        phoneNumber.userInteractionEnabled = true
        phoneNumber.addGestureRecognizer(tap)
    }
    
    //MARKS: 电话拨号功能,短信是sms,telprompt弹出确认对话框
    func phoneClick(gestrue: UITapGestureRecognizer){
        //let url = NSURL(string: "tel://\(photoNumberText!)")
        let url = NSURL(string: "telprompt://\(photoNumberText!)")
        if UIApplication.sharedApplication().canOpenURL(url!){
            UIApplication.sharedApplication().openURL(url!)
        }
        
    }
    
    func initData(){
        self.photoView.image = photoImage
        self.name.text = nameText
        self.weChatNumber.text = weChatNumberText
        self.phoneNumber.text = photoNumberText
       // self.photoNumberText = photoNumberText!.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.phoneNumber.textColor = UIColor(red: 51/255, green: 153/255, blue: 204/255, alpha: 1)
    }

    
    //右侧...点击事件
    func moreBtnClick(){
        print("more click...")
    }
    
    //MARKS: 取消tableview cell选中状态,使用尾部闭包
    override func viewWillAppear(animated: Bool) {
        setCellStyleNone()
        self.navigationController?.tabBarController!.tabBar.hidden = true
    }
    
    func setCellStyleNone(){
        for(var i = 0;i < tableView.numberOfSections; i++){
            for(var j = 0;j < tableView.numberOfRowsInSection(i);j++){
                
                let indexPath = NSIndexPath(forRow: j, inSection: i)
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                
                if tableView.numberOfRowsInSection(i) == 1 && i != 3 {
                    //画线条
                    let shape = WeChatDrawView().drawLine(beginPointX: 0, beginPointY: 0, endPointX: UIScreen.mainScreen().bounds.width, endPointY: 0,color:UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1))
                    cell!.layer.addSublayer(shape)
                }
                
                if (j == 0 || j == (tableView.numberOfRowsInSection(i) - 1)) && i != 3{
                    var beginY:CGFloat = 0
                    if j == (tableView.numberOfRowsInSection(i) - 1) {
                        beginY = cell!.frame.height
                    }
                    
                    //画线条
                    let shape = WeChatDrawView().drawLine(beginPointX: 0, beginPointY: beginY, endPointX: UIScreen.mainScreen().bounds.width, endPointY: beginY,color:UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1))
                    cell!.layer.addSublayer(shape)
                }
               
               
                if (i == 1 && j == 0) || (i == 2 && j == 1) || (i == 2 && j == 2){
                    continue
                }
                
                cell?.selectionStyle = .None
                
                if i == 3 && j == 0 {
                    cell!.backgroundColor = UIColor.clearColor()
                    cell!.backgroundColor = self.getBackgroundColor()
                    //MARKS: 去掉最后一行cell的分割线
                    cell!.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell!.bounds.size.width);
                }
            }
        }

    }
    
    //MARKS: 页面跳转,参数传递
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "socialInfo" {//跳转到社交资料页面
            //let socialDetailController = segue.destinationViewController as! SocialDetailViewController
        } else if segue.identifier == "markInfo"{//跳转到备注信息页面
            let remarkTagController = segue.destinationViewController as! RemarkTagViewController
            remarkTagController.remarkText = self.name.text
        }else if segue.identifier == "personInfo" {
            let persionInfoController = segue.destinationViewController as! PersonViewController
            persionInfoController.navigationTitle = self.name.text
            persionInfoController.headerImage = self.photoView.image
        }
        
        //取消选中状态
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: false)
    }
    
    //MARKS: 去掉tableview随scrollview滚动的黏性
    /*override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y <= CELL_HEADER_HEIGHT && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= CELL_HEADER_HEIGHT) {
            scrollView.contentInset = UIEdgeInsetsMake(-CELL_HEADER_HEIGHT, 0, 0, 0);
        }
    }*/
    
    /*
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let drawView = DrawView(frame: CGRectMake(0,cell.frame.origin.y,self.view.bounds.width,self.view.bounds.height))
            self.view.addSubview(drawView)
        }

    }
    
    //画直线
    func drawCellBorder(y:CGFloat){
        let context:CGContextRef = UIGraphicsGetCurrentContext()!;//获取画笔上下文
        CGContextSetAllowsAntialiasing(context, true) //抗锯齿设置
        CGContextSetLineWidth(context, 5) //设置画笔宽度
        CGContextMoveToPoint(context, 0, y);
        CGContextAddLineToPoint(context, 0, self.view.bounds.width);
        CGContextStrokePath(context)
    }*/
}
