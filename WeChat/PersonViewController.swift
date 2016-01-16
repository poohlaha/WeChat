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
    let paddingRight:CGFloat = 15//右边距
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
    let dateRightPadding:CGFloat = 5
    let placeBottomPadding:CGFloat = 5
    
    let leftPadding:CGFloat = 10//左边空白
    let rightPadding:CGFloat = 10//右边空白
    let leftWidth:CGFloat = 100//左边宽度
    let topPadding:CGFloat = 10//距上边空白
    
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
        for i in 0 ..< 3 {
            var personInfo:PersonInfo = PersonInfo()
            if i % 3 == 1 {//图片和内容
                let photo = Photo(photoImage: UIImage(named: "contact1"))
                let content = Content(content: "我，已经选择了你，你叫我怎么放弃...我不是碰不到更好的，而是因为已经有了你，我不想再碰到更好的；")
                let info = Info(photo: photo, content: content)
                personInfo = PersonInfo(date: "2\(i)十二月", place: "上海・张江高科技园区", infos: [info])
                personInfos.append(personInfo)
            } else if i % 3 == 2 {//图片、内容和标题
                let photo = Photo(photoImage: UIImage(named: "contact2"), width: 40, height: 40)
                let content = Content(content: "我，已经选择了你，你叫我怎么放弃...我不是碰不到更好的，而是因为已经有了你，我不想再碰到更好的；")
                let title = Title(title: "[得意]说得很有道理")
                let info = Info(title: title, photo: photo, content: content)
                personInfo = PersonInfo(date: "2\(i)十二月", infos: [info])
                personInfos.append(personInfo)
            } else if i % 3 == 0 {//内容
                let content = Content(content: "我，已经选择了你，你叫我怎么放弃...我不是碰不到更好的，而是因为已经有了你，我不想再碰到更好的；")
                let info = Info(content: content)
                personInfo = PersonInfo(date: "2\(i)十二月", place: "上海・张江高科技园区", infos: [info])
                personInfos.append(personInfo)
            }
            
            
        }
    }
    
    //初始化tableHeaderView
    func initTableHeaderView(){
        //头像小图
        let upHeight:CGFloat = 20//向上提升高度
        let headerImageX = UIScreen.mainScreen().bounds.width - headerImageWidth - paddingRight
        let headerImageY = headerBgHeight - headerImageHeight / 2 - upHeight

        let spacePadding:CGFloat = 5
        let headerImageView = UIImageView(frame: CGRect(x: headerImageX, y: headerImageY, width: headerImageWidth, height: headerImageHeight))
        headerImageView.image = headerImage
        
        let imageFrame = CGRect(x: headerImageX - spacePadding, y: headerImageY - spacePadding, width: headerImageWidth + spacePadding , height: headerImageHeight + spacePadding)
        
        let personView = PersonImageView(frame: imageFrame, image: headerImage!)
        
       
        
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
        headerView.addSubview(personView)
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
        if !personInfo.date.isEmpty{
            cell.dateLabel.text = personInfo.date
        }else{
            cell.dateLabel.hidden = true
        }
        
        if !personInfo.place.isEmpty {
            cell.placeLabel.text = personInfo.place
        }else{
            cell.placeLabel.hidden = true
        }
        
        let info = personInfo.infos[0]
        
        if info.content != nil {
            cell.contentLabel.text = info.content?.content
        }else{
            cell.contentLabel.hidden = true
        }
        
        //重新定义小图片大小
        if info.title != nil && info.photo != nil {
            cell.photoImageView.hidden = true
            let originX = leftPadding + leftWidth
            let originY = titleTopPadding + titleHeight + titleBottomPadding
            let imageView = UIImageView(frame: CGRect(x: originX, y: originY, width: info.photo!.width, height: info.photo!.height))
            imageView.image = info.photo?.photoImage
            cell.addSubview(imageView)
            /*cell.photoImageView.image = info.photo?.photoImage
            cell.photoImageView.frame.size = CGSize(width: info.photo!.width, height: info.photo!.height)*/
            
        } else {
            if info.photo != nil {
                cell.photoImageView.image = info.photo?.photoImage
            }else{
                cell.photoImageView.hidden = true
            }
        }
        
       
        if info.title != nil {
            cell.titleLabel.text = info.title?.title
        }else{
            cell.titleLabel.hidden = true
        }
        
        
        //重新设置选中开始的坐标点
        let frame = CGRectMake(leftPadding + leftWidth, cell.frame.origin.y, UIScreen.mainScreen().bounds.width - (leftPadding + leftWidth) - rightPadding, cell.bounds.height)
        cell.selectedBackgroundView = UIView(frame: frame)
        cell.selectedBackgroundView!.backgroundColor = UIColor.grayColor()
        return cell
    }
    
    //MARKS:根据内容重新计算高度
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //let cell = tableView.dequeueReusableCellWithIdentifier("PersonInfoCell", forIndexPath: indexPath) as! PersonInfoCell
        
        let personInfo = personInfos[indexPath.row]
        var height:CGFloat = 0
        for var info in personInfo.infos {
            let photo = info.photo
            let title = info.title
            let content = info.content
            if title != nil && photo != nil {//当有标题和图片和内容,图片为小图
                height += titleTopPadding
                height += titleHeight
                height += titleBottomPadding
                
                height += (photo?.height)!
                height += photoBottomPadding
            } else if title == nil && photo != nil {//当没有标题,只有图片或图片和内容
                var leftHeight:CGFloat = 0
                if !personInfo.date.isEmpty && !personInfo.place.isEmpty{
                    leftHeight += dateTopPadding
                    leftHeight += dateHeight
                    leftHeight += dateBottomPadding
                    leftHeight += placeHeight
                    leftHeight += placeBottomPadding
                }else if !personInfo.date.isEmpty && personInfo.place.isEmpty{
                    leftHeight += dateTopPadding
                    leftHeight += dateHeight
                    leftHeight += dateBottomPadding
                }
                
                if leftHeight > (photoHeight + titleBottomPadding + photoBottomPadding) {
                    height += leftHeight
                }else{
                    height += photoHeight + titleBottomPadding + photoBottomPadding
                }
                
            } else if title == nil && photo == nil && content != nil{//当只有内容
                //只有内容的时候要判断是不是大于左边的高度,如果大于以及为主,如果小于以左边为主
                var leftHeight:CGFloat = 0
                
                if !personInfo.date.isEmpty && !personInfo.place.isEmpty{
                    leftHeight += dateTopPadding
                    leftHeight += dateHeight
                    leftHeight += dateBottomPadding
                    leftHeight += placeHeight
                    leftHeight += placeBottomPadding
                }else if !personInfo.date.isEmpty && personInfo.place.isEmpty{
                    leftHeight += dateTopPadding
                    leftHeight += dateHeight
                    leftHeight += dateBottomPadding
                }
                
                if leftHeight > (contentHeight + contentTopPadding + contentBottomPadding) {
                     height += leftHeight
                }else{
                    height += contentHeight + contentTopPadding + contentBottomPadding
                }
                
            } else {
                continue
            }
        }
        
        return height
    }

    
}
