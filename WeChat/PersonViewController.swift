//
//  PersonViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/14.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//个人信息页面
class PersonViewController: WeChatTableViewNormalController {

    //MARKS:Properties
    var navigationTitle:String?//导航标题
    var headerImage:UIImage?//小头像
    let headerImageWidth:CGFloat = 80//小头像宽度
    let headerImageHeight:CGFloat = 80//小头像高度
    let headerLabelHeight:CGFloat = 20//小头像下文字高度
    let headerLabelWidth:CGFloat = 250//小头像下文字宽度
    let paddingLeft:CGFloat = 10//左边距
    let paddingRight:CGFloat = 10//右边距
    let paddingTop:CGFloat = 10//上边距
    let paddingBottom:CGFloat = 10//下边距
    
    let titleTopPadding:CGFloat = 10//标题上边空白
    let titleBottomPadding:CGFloat = 10//标题下边空白
    let photoLeftPadding:CGFloat = 5//图片左边空白
    let photoRightPadding:CGFloat = 5//图片右边空白
    let photoBottomPadding:CGFloat = 5//图片下边空白
    let contentRightPadding:CGFloat = 10//内容右边空白
    let contentTopPadding:CGFloat = 5
    let contentBottomPadding:CGFloat = 5
    let dateBottomPadding:CGFloat = 5
    let dateTopPadding:CGFloat = 10
    
    let dateHeight:CGFloat = 25
    let placeHeight:CGFloat = 25
    let titleHeight:CGFloat = 20
    let photoHeight:CGFloat = 50
    let contentHeight:CGFloat = 40
    
    
    
    var personInfos:[PersonInfo] = [PersonInfo]()
    let headerBgHeight:CGFloat = 300//背景大图高度
    
    //重写属性,去掉tableview header
    override var CELL_HEADER_HEIGHT:CGFloat {
        get {
            return 0
        }
        
        set {
            self.CELL_HEADER_HEIGHT = newValue
        }
    }
    
    override var CELL_FOOTER_HEIGHT:CGFloat {
        get {
            return 0
        }
        
        set {
            self.CELL_FOOTER_HEIGHT = newValue
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFrame()
        //tableView.registerClass(PersonInfoCell.self, forCellReuseIdentifier: "InfoCell")
    }
    
    //MARKS: 初始化
    func initFrame(){
        //设置标题
        navigationItem.title = navigationTitle
        
        //MARKS: 设置导航行背景及字体颜色
        WeChatNavigation().setNavigationBarProperties((self.navigationController?.navigationBar)!)
        
        //去掉tableview分割线
        tableView.separatorStyle = .None
        tableView.scrollEnabled = true
        tableView.showsVerticalScrollIndicator = true
        initTableHeaderView()
        initData()
    }
    
    //MARKS: 初始化数据
    func initData(){
        for i in 0 ..< 10 {
            let info = Info(photoImage:UIImage(named: "contact3"),content: "我，已经选择了你，你叫我怎么放弃...我不是碰不到更好的，而是因为已经有了你，我不想再碰到更好的；")
            let personInfo = PersonInfo(date: "2\(i)十二月", place: "上海・张江高科技园区", infos: [info])
            personInfos.append(personInfo)
        }
    }
    
    //初始化tableHeaderView
    func initTableHeaderView(){
        
        //头像小图
        let upHeight:CGFloat = 20//向上提升高度
        let headerImageX = UIScreen.mainScreen().bounds.width - headerImageWidth - paddingRight
        let headerImageY = headerBgHeight - headerImageHeight / 2 - upHeight
        let headerImageView = UIImageView(frame: CGRect(x: headerImageX, y: headerImageY, width: headerImageWidth, height: headerImageHeight))
        headerImageView.image = headerImage
        
        //背景大图,需要向上提升
        let bgUpHeight:CGFloat = 50//向上提升空白数
        let bgImageView = UIImageView(frame: CGRect(x: 0, y: -bgUpHeight, width: UIScreen.mainScreen().bounds.width, height: headerBgHeight + bgUpHeight))
        bgImageView.image = UIImage(named: "info-bg\(getRandom(1,max: 10))")
        
        //小头像边上文字
        let photoLabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width - headerImageWidth - headerLabelWidth - paddingRight * 3, headerBgHeight - paddingBottom * 3, headerLabelWidth, headerLabelHeight))
        photoLabel.textAlignment = .Right
        photoLabel.font = UIFont(name: "AlNile-Bold", size: 20)
        photoLabel.textColor = UIColor.whiteColor()
        photoLabel.text = navigationTitle
        
        var label:UILabel?
        let spaceUpLabel = paddingTop + paddingBottom//文字上面空白
        //添加Label,获取随机数:
        let random = getRandom(1, max: 4)
        if random % 2 == 0 {
            label = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width - headerLabelWidth - paddingRight, headerBgHeight + headerImageHeight / 2 + spaceUpLabel - upHeight, headerLabelWidth, headerLabelHeight))
            label!.textAlignment = .Right
            label!.font = UIFont(name: "AlNile", size: 14)
            label!.textColor = UIColor(red: 143/255, green: 143/255, blue: 143/255, alpha: 1)
            label!.text = "如果还可以重来,我将用一生去呵护你..."
            
        }
        
        //以CGRectZero作为frame初始化UIView为了去掉其底部线条
        //计算headerView高度
        var headerViewHeight:CGFloat = 0
        if label != nil {
            headerViewHeight += label!.frame.origin.y
        }else{
            headerViewHeight += (headerBgHeight + (headerImageHeight / 2 - upHeight))
        }
        
        headerViewHeight += 40 //底部留40的空白
        //let headerView:UIView = UIView(frame: CGRectZero)
        let headerView = UIView(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.width,headerViewHeight))
        headerView.backgroundColor = UIColor.clearColor()
        headerView.addSubview(bgImageView)
        headerView.addSubview(headerImageView)
        headerView.addSubview(photoLabel)
        if label != nil {
            headerView.addSubview(label!)
        }
       
        
        
        
        tableView.tableHeaderView = headerView
    }
    
    //MARKS: 返回cell行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personInfos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonInfoCell", forIndexPath: indexPath) as! PersonInfoCell
        
        let personInfo = personInfos[indexPath.row]
        //set data
        cell.dateLabel.text = personInfo.date
        cell.placeLabel.text = personInfo.place
        cell.contentLabel.text = personInfo.infos[0].content
        cell.photoImageView.image = personInfo.infos[0].photoImage
        
        cell.titleLabel.hidden = true
        
        //重新计算cell调度
        //cell.resizeHeight(250)
        return cell
    }
    
    //MARKS:根据内容重新计算高度
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //let cell = tableView.dequeueReusableCellWithIdentifier("PersonInfoCell", forIndexPath: indexPath) as! PersonInfoCell
        
        let personInfo = personInfos[indexPath.row]
        var height:CGFloat = 0
        for var info in personInfo.infos {
            
            if !info.title.isEmpty && info.photoImage != nil {//当有标题和图片
                height += titleTopPadding
                //height += cell.titleLabel.frame.height
                height += titleHeight
                height += titleBottomPadding
                
                //height += cell.photoImageView.frame.height
                height += photoHeight
                height += photoBottomPadding
            } else if info.title.isEmpty && info.photoImage != nil {//当没有标题,只有图片
                var leftHeight:CGFloat = 0
                if !personInfo.date.isEmpty {
                    //leftHeight += cell.dateLabel.frame.height
                    leftHeight += dateHeight
                }
                
                if !personInfo.place.isEmpty {
                    //leftHeight += cell.placeLabel.frame.height
                    leftHeight += placeHeight
                }
                
                if leftHeight > (photoHeight + titleBottomPadding + photoBottomPadding + dateTopPadding) {
                    height += leftHeight
                }else{
                    height += photoHeight + titleBottomPadding + photoBottomPadding + dateTopPadding
                }
            } else if info.title.isEmpty && info.photoImage == nil && !info.content.isEmpty{//当只有内容
                //只有内容的时候要判断是不是大于左边的高度,如果大于以及为主,如果小于以左边为主
                var leftHeight:CGFloat = 0
                if !personInfo.date.isEmpty {
                    //leftHeight += cell.dateLabel.frame.height
                    leftHeight += dateHeight
                }
                
                if !personInfo.place.isEmpty {
                    //leftHeight += cell.placeLabel.frame.height
                    leftHeight += placeHeight
                }
                
                if leftHeight > (contentHeight + contentTopPadding + contentBottomPadding + dateTopPadding) {
                     height += leftHeight
                }else{
                    height += contentHeight + contentTopPadding + contentBottomPadding + dateTopPadding
                }
                
                /*if leftHeight > cell.contentLabel.frame.height {
                    height += leftHeight
                } else {
                    height += cell.contentLabel.frame.height
                }*/
                
            } else {
                continue
            }
        }
        
        return height
    }

    
}
