//
//  SliderPanelViewController.swift
//  WeChat
//
//  Created by Smile on 16/2/17.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//左右菜单
class SliderPanelViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let topViewHeight:CGFloat = 200//上半部分高度
    var leftPadding:CGFloat = 20//topView视图左边距
    var rightPadding:CGFloat = 10//topView视图右边距
    let topRightDimeWidth:CGFloat = 20//二维码宽度
    
    var nagvHeight:CGFloat = 44//导航条高度
    var statusFrame:CGFloat = 0
    var top:CGFloat = 0
    var width:CGFloat = 0//导航条宽度
    
    var topView:UIView!
    var topHeight:CGFloat = 100
    var topImage:CGFloat = 50
    let topViewTopPadding:CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFrame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initFrame(){
        statusFrame = UIApplication.sharedApplication().statusBarFrame.height
        top = statusFrame + nagvHeight
        
        width = self.view.frame.width - 80
        
        createBackground()
        createHeader()
        createTableView()
        createBottomView()
    }
    
    //MARKS: 填充背景
    func createBackground(){
        //顶部有20的边距
        let topTopView = UIImageView()
        topTopView.frame = CGRectMake(0, 0, self.view.frame.width, topViewTopPadding)
        topTopView.image = UIImage(named: "slider-top-bg")
        self.view.addSubview(topTopView)
        
        let bgImageView = UIImageView()
        bgImageView.frame = CGRectMake(0, topViewTopPadding, self.view.frame.width, self.view.frame.height)
        
        //拉伸图片底部
        var image = UIImage(named: "slider-bg")
        //image?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, bgImageView.frame.width, 650))
        image = image?.resizableImageWithCapInsets(UIEdgeInsetsMake(topViewHeight, 0, 0,0), resizingMode: .Stretch)
        bgImageView.image = image
        
        self.view.addSubview(bgImageView)
        self.view.sendSubviewToBack(bgImageView)
    }
    
    //MARKS: 创建topView
    func createHeader(){
        topView = UIView()
        topView.frame = CGRectMake(leftPadding, top, width - leftPadding - rightPadding, topHeight)
        //topView.layer.borderWidth = 1
        
        let imageView = UIImageView(image: UIImage(named: "my-header"))
        imageView.frame = CGRectMake(0, 0, topImage, topImage)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
        topView.addSubview(imageView)
        
        //添加昵称
        let labelTopPadding:CGFloat = 5
        let label = UILabel()
        let labelHeight:CGFloat = 18
        let labelWidth:CGFloat = topView.frame.width - imageView.frame.width - topRightDimeWidth - 10
        label.frame = CGRectMake(imageView.frame.width + 10, labelTopPadding, labelWidth, labelHeight)
        label.text = "谁愿、许诺我一生"
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByTruncatingTail//有省略号
        label.font = UIFont(name: "AlNile-Bold", size: 20)
        topView.addSubview(label)
        
        //添加昵称下面的等级
        let dengJiView = UIView()
        let dengJiBeginY:CGFloat = labelTopPadding + labelHeight + labelTopPadding
        let dengJiHeight:CGFloat = topImage - dengJiBeginY - labelTopPadding
        dengJiView.frame = CGRectMake(label.frame.origin.x, dengJiBeginY, label.frame.width,dengJiHeight)
        
        //VIP等级
        let dView = UIImageView()
        let dViewPadding:CGFloat = 2
        let dViewWidth:CGFloat = 33
        dView.frame = CGRectMake(0, dViewPadding, dViewWidth, dengJiView.frame.height - dViewPadding * 2)
        
        let dImageView2Width:CGFloat = 8
        let dImageView1 = UIImageView()
        let dImageView1Image = UIImage(named: "slider-vip")
        dImageView1.frame = CGRectMake(0, 0, dView.frame.width, dView.frame.height)
        
        //dImageView1Image = dImageView1Image!.resizableImageWithCapInsets(UIEdgeInsetsMake(0, dImageView1.frame.width - 9, 0,0), resizingMode: .Stretch)
        dImageView1.image = dImageView1Image
        
        let dView2 = UIView()
        dView2.frame = CGRectMake(dImageView1.frame.width - 4, dImageView1.frame.origin.y, dImageView2Width + 3, dImageView1.frame.height)
        dView2.backgroundColor = UIColor.redColor()
        
        let dImageView2 = UIImageView()
        dImageView2.image = UIImage(named: "slider-vip-6")
        dImageView2.frame = CGRectMake(0, 3, 8, 7.5)
        dView2.addSubview(dImageView2)
        
        dView.addSubview(dImageView1)
        dView.addSubview(dView2)
        dengJiView.addSubview(dView)
        
        //个人等级
        let pDengJiView = UIView()
        let pDengJiBeginX:CGFloat = dView2.frame.origin.x + dView2.frame.width + 5
        let pDengJiWidth:CGFloat = dengJiView.frame.width - dImageView1.frame.width - dView2.frame.width - 5
        pDengJiView.frame = CGRectMake(pDengJiBeginX, dImageView1.frame.origin.y, pDengJiWidth, dengJiView.frame.height)
        
        let pTotalCount:Int = 6
        let pOneImageViewPadding:CGFloat = 2
        let pOneImageViewWidth = (pDengJiWidth - CGFloat(pTotalCount - 1) * pOneImageViewPadding) / CGFloat(pTotalCount)
        
        var beginX:CGFloat = pOneImageViewPadding
        for(var i = 0;i < pTotalCount;i++){
            let imageView = UIImageView()
            if i < 3 {
                imageView.image = UIImage(named: "usersummary_icon_lv_sun")
            } else if i < pTotalCount - 1 {
                imageView.image = UIImage(named: "usersummary_icon_lv_moon")
            } else {//last one
                imageView.image = UIImage(named: "usersummary_icon_lv_more")
            }
            
            imageView.frame = CGRectMake(beginX, 0, pOneImageViewWidth, pDengJiView.frame.height)
            
            if i != (pTotalCount - 1){
                beginX += (pOneImageViewWidth + pOneImageViewPadding)
            }
            
            pDengJiView.addSubview(imageView)
        }
        
        dengJiView.addSubview(pDengJiView)
        topView.addSubview(dengJiView)
        
        //添加二维码
        let twoDimeView = UIImageView()
        twoDimeView.frame = CGRectMake(topView.frame.width - topRightDimeWidth, 0, topRightDimeWidth, topRightDimeWidth)
        twoDimeView.image = UIImage(named: "slider-twoDime-normal")
        topView.addSubview(twoDimeView)
        
        //添加textlabel begin
        let labelBeginView = UIView()
        labelBeginView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.x + topImage + 7, 20, 20)
        labelBeginView.layer.masksToBounds = true
        labelBeginView.layer.cornerRadius = labelBeginView.frame.width / 2
        labelBeginView.backgroundColor = UIColor(patternImage: UIImage(named: "slider-label-begin-bg")!)
        
        let labelBeginImageView = UIImageView()
        labelBeginImageView.image = UIImage(named: "slider-label-begin")
        labelBeginImageView.frame = labelBeginView.bounds
        labelBeginView.addSubview(labelBeginImageView)
        topView.addSubview(labelBeginView)
        
        //添加textLabel
        let textLabel = UILabel()
        let textLabelWidth:CGFloat = topView.frame.width - labelBeginView.frame.width - 10 - twoDimeView.frame.width / 2
        textLabel.frame = CGRectMake(labelBeginView.frame.origin.x + labelBeginView.frame.width + 10, labelBeginView.frame.origin.y + 3,textLabelWidth, labelBeginView.frame.height)
        textLabel.text = "<<梦如、人生>>我用尽所有力气,才发现被感动的只有我自己..."
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .ByTruncatingTail
        textLabel.font = UIFont(name: "ArialMT", size: 15)
        textLabel.textColor = UIColor.darkGrayColor()
        topView.addSubview(textLabel)
        
        self.view.addSubview(topView)
    }

    var tableView:UITableView!
    var bottomViewHeight:CGFloat = 80
    let tableViewTopPadding:CGFloat = 20
    var tableViewDatas:[SliderTableData] = [SliderTableData]()
    let CELL_HEIGHT:CGFloat = 40
    var bottomView:UIView!
    
    //MARKS: 创建tableViewData数据
    func createTableViewData(){
        var sliderTableData1 = SliderTableData()
        sliderTableData1.text = "我的QQ会员"
        sliderTableData1.image = UIImage(named: "slider-qqVip")
        
        var sliderTableData2 = SliderTableData()
        sliderTableData2.text = "QQ钱包"
        sliderTableData2.image = UIImage(named: "slider-qqMoney")
        
        var sliderTableData3 = SliderTableData()
        sliderTableData3.text = "个性装扮"
        sliderTableData3.image = UIImage(named: "slider-zhuangban")
        
        var sliderTableData4 = SliderTableData()
        sliderTableData4.text = "我的收藏"
        sliderTableData4.image = UIImage(named: "slider-soucang")
        
        var sliderTableData5 = SliderTableData()
        sliderTableData5.text = "我的相册"
        sliderTableData5.image = UIImage(named: "slider-myPhoto")
        
        var sliderTableData6 = SliderTableData()
        sliderTableData6.text = "我的文件"
        sliderTableData6.image = UIImage(named: "slider-myFile")
        
        tableViewDatas.append(sliderTableData1)
        tableViewDatas.append(sliderTableData2)
        tableViewDatas.append(sliderTableData3)
        tableViewDatas.append(sliderTableData4)
        tableViewDatas.append(sliderTableData5)
        tableViewDatas.append(sliderTableData6)
    }
    
    //创建底部View
    func createBottomView(){
        bottomView = UIView()
        bottomView.frame = CGRectMake(leftPadding, self.view.frame.height - bottomViewHeight, topView.frame.width, bottomViewHeight)
        
        let imageHeight:CGFloat = 20
        let labelPadding:CGFloat = 2
        let labelHeight:CGFloat = 15
        let bottomPadding:CGFloat = 10
        let oneViewWidth:CGFloat = bottomView.frame.width / 3
        let view1 = UIView()
        view1.frame = CGRectMake(0, bottomView.frame.height - bottomPadding - imageHeight, oneViewWidth, imageHeight)
        
        let imageWidthMax:CGFloat = 20
        let width1:CGFloat = view1.frame.width / 3
        let imageWidth:CGFloat =  width1 > imageWidthMax ? imageWidthMax : width1
        
        //图片
        let imageView1 = UIImageView()
        imageView1.frame = CGRectMake(0, 0, imageWidth, imageHeight)
        imageView1.image = UIImage(named: "slider-setting")
        view1.addSubview(imageView1)
        
        //设置
        let label1 = UILabel()
        label1.frame = CGRectMake(imageView1.frame.width + labelPadding, (view1.frame.height - labelHeight) / 2, view1.frame.width - imageWidth, labelHeight)
        label1.textColor = UIColor.whiteColor()
        label1.text = "设置"
        label1.font = UIFont(name: "ArialMT", size: 14)
        view1.addSubview(label1)
        bottomView.addSubview(view1)
        
        let view2 = UIView()
        view2.frame = CGRectMake(view1.frame.width, view1.frame.origin.y, view1.frame.width, view1.frame.height)
        
        //图片
        let imageView2 = UIImageView()
        imageView2.frame = CGRectMake(0, 0, imageWidth, imageHeight)
        imageView2.image = UIImage(named: "slider-night")
        view2.addSubview(imageView2)
        
        //夜间
        let label2 = UILabel()
        label2.frame = CGRectMake(imageView2.frame.width + labelPadding, (view2.frame.height - labelHeight) / 2, view2.frame.width - imageWidth, labelHeight)
        label2.textColor = UIColor.whiteColor()
        label2.text = "夜间"
        label2.font = UIFont(name: "ArialMT", size: 14)
        view2.addSubview(label2)
        bottomView.addSubview(view2)
        
        let view3 = UIView()
        view3.frame = CGRectMake(view1.frame.width + view2.frame.width, 0, view2.frame.width, bottomView.frame.height - bottomPadding)
        
        //上海
        let label3 = UILabel()
        label3.frame = CGRectMake(0, view2.frame.origin.y, view2.frame.width - labelPadding * 2, view2.frame.height)
        label3.textColor = UIColor.whiteColor()
        label3.text = "上海"
        label3.textAlignment = .Right
        label3.font = UIFont(name: "ArialMT", size: 14)
        view3.addSubview(label3)
        
        let view3_imageWidth:CGFloat = 40 > oneViewWidth ? oneViewWidth: 40
        
        let view3_imageView = UIImageView()
        view3_imageView.frame = CGRectMake(view3.frame.width - view3_imageWidth, 0, view3_imageWidth, view3.frame.height - label3.frame.height)
        view3_imageView.image = UIImage(named: "slider-weather")
        view3.addSubview(view3_imageView)
        
        bottomView.addSubview(view3)
        self.view.addSubview(bottomView)
    }
    
    //MARKS: 创建tableView
    func createTableView(){
        tableView = UITableView()
        let tableViewHeight:CGFloat = self.view.frame.height - (topViewHeight + tableViewTopPadding) - bottomViewHeight
        tableView.frame = CGRectMake(leftPadding, topViewHeight + tableViewTopPadding, topView.frame.width, tableViewHeight)
        
        //清除tableview透明,为设置cell透明作铺垫
        self.tableView.backgroundColor = UIColor.clearColor()
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //获取数据
        createTableViewData()
        
        self.view.addSubview(tableView)
    }
    
    //MARKS: section个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDatas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell\(indexPath.section)\(indexPath.row)")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell\(indexPath.section)\(indexPath.row)")
        }
        
        //清除旧数据
        for subView in (cell?.subviews)! {
            subView.removeFromSuperview()
        }
        
        let sliderTableData = tableViewDatas[indexPath.row]
        
        let imageView = UIImageView()
        imageView.image = sliderTableData.image
        imageView.frame = CGRectMake(0, 5, sliderTableData.width, sliderTableData.height)
        cell?.addSubview(imageView)
        
        let textLabelPadding:CGFloat = 10
        let textLabelWidth:CGFloat = cell!.frame.width - imageView.frame.width - textLabelPadding - textLabelPadding
        let textLabelHeight:CGFloat = 20
        
        let textLabel = UILabel()
        textLabel.font = UIFont(name: "AlNile", size: 18)
        textLabel.text = sliderTableData.text
        textLabel.textColor = UIColor.whiteColor()
        textLabel.frame = CGRectMake(imageView.frame.width + 10, (cell!.frame.height - textLabelHeight) / 2 + 2, textLabelWidth, textLabelHeight)
        cell?.addSubview(textLabel)
        
        //设置cell透明
        cell!.backgroundColor = UIColor.clearColor()
        cell!.contentView.backgroundColor = UIColor.clearColor()
        
        //设置cell的选中样式
        let view = UIView(frame: cell!.frame)
        view.backgroundColor = UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 0.3)
        cell?.selectedBackgroundView = view
        
        return cell!
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return CELL_HEIGHT
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

struct SliderTableData {
    var image:UIImage?
    var text:String = ""
    let width:CGFloat = 30
    let height:CGFloat = 30
}
