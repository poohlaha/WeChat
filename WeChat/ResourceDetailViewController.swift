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
    
    
    var nameText:String?
    var photoImage:UIImage?
    var weChatNumberText:String?
    var indexPath:NSIndexPath?
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
        
        let weChatPhotoView = WeChatContactPhotoView(frame: CGRectMake(90, 7, UIScreen.mainScreen().bounds.width - 90, personLabel.frame.height), images: images)
        cell?.addSubview(weChatPhotoView)
    }
    
    func initFrame(){
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...",style: UIBarButtonItemStyle.Plain, target: self, action: "moreBtnClick")
        
        initTableView()
        //MARKS: 去掉tableview底部空白
        createFooterForTableView()
    }
    
    func initData(){
        self.photoView.image = photoImage
        self.name.text = nameText
        self.weChatNumber.text = weChatNumberText
    }
    
    //右侧...点击事件
    func moreBtnClick(){
        print("more click...")
    }
    
    //MARKS: 取消tableview cell选中状态,使用尾部闭包
    override func viewWillAppear(animated: Bool) {
        setCellStyleNone(3,y: 0,callback: { (cell:UITableViewCell) -> Void in
            cell.selectionStyle = .None
            cell.backgroundColor = UIColor.clearColor()
            cell.backgroundColor = self.getBackgroundColor()
            //MARKS: 去掉最后一行cell的分割线
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
        })
        
    }
    
    //MARKS: 页面跳转,参数传递
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "socialInfo" {//跳转到社交资料页面
            //let socialDetailController = segue.destinationViewController as! SocialDetailViewController
            
        } else if segue.identifier == "markInfo"{//跳转到备注信息页面
            let remarkTagController = segue.destinationViewController as! RemarkTagViewController
            remarkTagController.remarkText = self.name.text
        }
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
