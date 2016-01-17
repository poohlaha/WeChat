//
//  PersonViewController.swift
//  WeChat
//
//  Created by Smile on 16/1/14.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//个人信息页面
//需要重新定义视图,把控件包含进去
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
    let bottomPadding:CGFloat = 30//底部空白
    let leftWidth:CGFloat = 100//左边宽度
    let topPadding:CGFloat = 10//距上边空白
    
    let dateHeight:CGFloat = 25
    let placeHeight:CGFloat = 25
    let titleHeight:CGFloat = 20
    let contentHeight:CGFloat = 40
    
    let lastCellBottomPadding:CGFloat = 50//最后view距离线条高度
    let lastDrawHeight:CGFloat = 5//最后线条高度
    
    
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
        //去掉scrollview自动设置
        //self.automaticallyAdjustsScrollViewInsets = false
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
                personInfo = PersonInfo(date: "十二月",day:"\(i+1)", place: "上海・张江高科技园区", infos: [info])
                personInfos.append(personInfo)
            } else if i % 3 == 2 {//图片、内容和标题
                let photo = Photo(photoImage: UIImage(named: "contact2"), width: 40, height: 40)
                let content = Content(content: "我，已经选择了你，你叫我怎么放弃...我不是碰不到更好的，而是因为已经有了你，我不想再碰到更好的；")
                let title = Title(title: "[得意]说得很有道理")
                let info = Info(title: title, photo: photo, content: content)
                personInfo = PersonInfo(date: "十二月",day:"\(i+1)", infos: [info])
                personInfos.append(personInfo)
            } else if i % 3 == 0 {//内容
                let content = Content(content: "我，已经选择了你，你叫我怎么放弃...我不是碰不到更好的，而是因为已经有了你，我不想再碰到更好的；")
                let info = Info(content: content)
                personInfo = PersonInfo(date: "十二月",day:"\(i+1)", place: "上海・张江高科技园区", infos: [info])
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
    
    //创建Label
    func createLabel(frame:CGRect,string:String,color:UIColor,fontSize:CGFloat,isAllowNext:Bool) -> UILabel{
        let label = UILabel(frame: frame)
        label.textAlignment = .Left
        label.font = UIFont(name: "AlNile", size: fontSize)
        label.textColor = color
        label.text = string
        if isAllowNext {
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.ByTruncatingTail//有省略号
        }
        return label
    }
    
    //创建Photo
    func createPhotoView(frame:CGRect,image:UIImage) -> UIImageView{
        let photoView = UIImageView(frame: frame)
        photoView.image = image
        return photoView
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonInfoCell", forIndexPath: indexPath) as! PersonInfoCell
        
        //隐藏所有控件
        cell.titleLabel.hidden = true
        cell.photoImageView.hidden = true
        cell.contentLabel.hidden = true
        
        let personInfo = personInfos[indexPath.row]
        if !personInfo.date.isEmpty{
            cell.dateLabel.text = personInfo.date
            //cell.dateLabel.font = UIFont(name: "AlNile", size: 20)
        }else{
            cell.dateLabel.hidden = true
        }
        
        if !personInfo.day.isEmpty{
            cell.dayLabel.text = personInfo.day
            //cell.dayLabel.font = UIFont(name: "AlNile-bold", size: 30)
            //cell.dayLabel.frame = CGRectMake(0, 20, 50, 20)
        }else{
            cell.dayLabel.hidden = true
        }
        
        if !personInfo.place.isEmpty {
            cell.placeLabel.text = personInfo.place
        }else{
            cell.placeLabel.hidden = true
        }
        
        var cellHeight = cell.frame.height
        //最后一行添加线条
        if indexPath.row == (personInfos.count - 1) {
            cellHeight -= lastCellBottomPadding * 2
        }else{
            cellHeight -= bottomPadding
        }
        
        for info in personInfo.infos {
            let photo = info.photo
            let title = info.title
            let content = info.content
            
            if title != nil && photo != nil {//当有标题和图片和内容,图片为小图
                //创建UIView,包含所有控件
                let bgColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
                let controlView = PersonCustomView(frame: CGRectMake(leftPadding + leftWidth, titleTopPadding, UIScreen.mainScreen().bounds.width - (leftPadding + leftWidth) - rightPadding, cellHeight), tableView: self.tableView, color: bgColor)
                
                let titleLabel = createLabel(CGRectMake(photoLeftPadding, titleTopPadding, controlView.frame.width, titleHeight), string: (title?.title)!, color: UIColor.blackColor(), fontSize: 14,isAllowNext: false)
                let photoImage = createPhotoView(CGRectMake(photoLeftPadding, titleHeight + titleBottomPadding, (photo?.width)!, (photo?.height)!), image: (photo?.photoImage)!)
                let contentLabel = createLabel(CGRectMake(photoImage.frame.origin.x + photoImage.frame.width + photoRightPadding,contentTopPadding + titleHeight + titleBottomPadding, controlView.frame.width - (photo?.width)! - photoLeftPadding - photoRightPadding - contentRightPadding,contentHeight), string: (content?.content)!, color: UIColor.lightGrayColor(), fontSize: 14,isAllowNext: true)
                
                controlView.backgroundColor = bgColor
                controlView.addSubview(titleLabel)
                controlView.addSubview(photoImage)
                controlView.addSubview(contentLabel)
                cell.addSubview(controlView)
            } else if title == nil && photo != nil {//当没有标题,只有图片或图片和内容
                //创建UIView,包含所有控件
                let bgColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
                let controlView = PersonCustomView(frame: CGRectMake(leftPadding + leftWidth, titleTopPadding, UIScreen.mainScreen().bounds.width - (leftPadding + leftWidth) - rightPadding, cellHeight), tableView: self.tableView, color: bgColor)
                
                var height:CGFloat = 0
                var padding:CGFloat = titleTopPadding
                let leftHeight = getLeftHeight(personInfo)
                if leftHeight > (contentHeight + contentTopPadding + contentBottomPadding) {
                    height += leftHeight
                    //重新计算padding
                    padding = (controlView.frame.height - photo!.height) / 2 - photoBottomPadding
                }else{
                    height += photo!.height + padding + photoBottomPadding
                }
                
                let photoImage = createPhotoView(CGRectMake(photoLeftPadding, padding, (photo?.width)!, (photo?.height)!), image: (photo?.photoImage)!)
                let contentLabel = createLabel(CGRectMake(photoImage.frame.origin.x + photoImage.frame.width + photoRightPadding,contentTopPadding + titleTopPadding, controlView.frame.width - (photo?.width)! - photoLeftPadding - photoRightPadding - contentRightPadding,contentHeight), string: (content?.content)!, color: UIColor.lightGrayColor(), fontSize: 14,isAllowNext: true)
                controlView.backgroundColor = bgColor
                controlView.addSubview(photoImage)
                controlView.addSubview(contentLabel)
                cell.addSubview(controlView)
            } else if title == nil && photo == nil && content != nil{//当只有内容
                //创建UIView,包含所有控件
                let bgColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
                let controlView = PersonCustomView(frame: CGRectMake(leftPadding + leftWidth, titleTopPadding, UIScreen.mainScreen().bounds.width - (leftPadding + leftWidth) - rightPadding, cellHeight), tableView: self.tableView, color: bgColor)
                
                var height:CGFloat = 0
                var padding:CGFloat = titleTopPadding
                let leftHeight = getLeftHeight(personInfo)
                if leftHeight > (contentHeight + contentTopPadding + contentBottomPadding) {
                    height += leftHeight
                    //重新计算padding
                    padding = (controlView.frame.height - contentHeight) / 2
                }else{
                    height += contentHeight + padding + contentBottomPadding
                }
                
                let contentLabel = createLabel(CGRectMake(photoLeftPadding,padding, controlView.frame.width - photoLeftPadding - contentRightPadding,contentHeight), string: (content?.content)!, color: UIColor.lightGrayColor(), fontSize: 14,isAllowNext: true)
                controlView.backgroundColor = bgColor
                controlView.addSubview(contentLabel)
                cell.addSubview(controlView)
            } else {
                
            }
        }
        
        //最后一行添加线条
        if indexPath.row == (personInfos.count - 1) {
            cell.addSubview(LastCellCustomView(frame: CGRectMake(leftWidth + rightPadding, cellHeight + lastCellBottomPadding, cell.frame.width - leftWidth,lastDrawHeight)))
        }
        
        //取消cell选中样式
        cell.selectionStyle = .None
        return cell
    }

    //MARKS: View点击效果
    func controlViewTap(gestrue: UITapGestureRecognizer){
        //去掉所有cell的选中事件
        for(var i = 0;i < tableView.numberOfSections; i++){
            for(var j = 0;j < tableView.numberOfRowsInSection(i);j++){
                let indexPath = NSIndexPath(forRow: j, inSection: i)
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                for(var k = 0;k < cell?.subviews.count; k++){
                    let sub = cell?.subviews[k]
                    if sub == nil {
                        continue
                    }
                    
                    if sub!.isKindOfClass(UIView){
                        sub?.backgroundColor =  UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
                    }
                }
            }
        }
        
        let gestureView = gestrue.view
        gestureView?.backgroundColor = UIColor.blueColor()
    }
   
    
    //MARKS:根据内容重新计算高度
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let personInfo = personInfos[indexPath.row]
        
        var height = getViewHeight(personInfo)
        //最后一行添加线条
        if indexPath.row == (personInfos.count - 1) {
            height += lastCellBottomPadding * 2
            return height
        }
        
        return height + bottomPadding
    }

    //获取高度
    func getViewHeight(personInfo:PersonInfo) -> CGFloat{
        var height:CGFloat = 0
        for info in personInfo.infos {
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
                let leftHeight = getLeftHeight(personInfo)
                
                if leftHeight > (photo!.height + titleBottomPadding + photoBottomPadding) {
                    height += leftHeight
                }else{
                    height += photo!.height + titleBottomPadding + photoBottomPadding
                }
                
            } else if title == nil && photo == nil && content != nil{//当只有内容
                //只有内容的时候要判断是不是大于左边的高度,如果大于以及为主,如果小于以左边为主
                let leftHeight = getLeftHeight(personInfo)
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
    
    func getLeftHeight(personInfo:PersonInfo) -> CGFloat{
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
        
        return leftHeight
    }
    
}
