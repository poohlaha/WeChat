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
        //tableView.separatorStyle = .None
        tableView.scrollEnabled = true
        tableView.showsVerticalScrollIndicator = true
        initTableHeaderView()
        initData()
    }
    
    //MARKS: 初始化数据
    func initData(){
        let info = Info(content: "我，已经选择了你，你叫我怎么放弃...\n我不是碰不到更好的，而是因为已经有了你，我不想再碰到更好的；")
        let personInfo = PersonInfo(date: "23十二月", place: "上海・张江高科技园区", infos: [info])
        //personInfos.append(personInfo)
    }
    
    //初始化tableHeaderView
    func initTableHeaderView(){
        //以CGRectZero作为frame初始化UIView为了去掉其底部线条
        let headerView:UIView = UIView(frame: CGRectZero)
        //headerView.frame = CGRectMake(0,0,UIScreen.mainScreen().bounds.width,headerHeight)
        headerView.backgroundColor = UIColor.clearColor()
        
        //头像小图
        let headerImageX = UIScreen.mainScreen().bounds.width - headerImageWidth - paddingRight
        let headerImageY = headerBgHeight - headerImageHeight / 2 - 20
        
        //背景大图
        let bgImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: headerBgHeight))
        bgImageView.image = UIImage(named: "info-bg\(getRandom(1,max: 10))")
        headerView.addSubview(bgImageView)
        
        
        let headerImageView = UIImageView(frame: CGRect(x: headerImageX, y: headerImageY, width: headerImageWidth, height: headerImageHeight))
        headerImageView.image = headerImage
        headerView.addSubview(headerImageView)
        
        //小头像边上文字
        let photoLabel = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width - headerImageWidth - headerLabelWidth - paddingRight * 3, headerBgHeight - paddingBottom * 3, headerLabelWidth, headerLabelHeight))
        photoLabel.textAlignment = .Right
        photoLabel.font = UIFont(name: "AlNile-Bold", size: 20)
        photoLabel.textColor = UIColor.whiteColor()
        photoLabel.text = navigationTitle
        headerView.addSubview(photoLabel)
        
        
        //添加Label,获取随机数:
        let random = getRandom(1, max: 4)
        if random % 2 == 0 {
            let label = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width - headerLabelWidth - paddingRight, headerBgHeight + headerImageHeight / 2 + paddingTop + paddingBottom - 20, headerLabelWidth, headerLabelHeight))
            label.textAlignment = .Right
            label.font = UIFont(name: "AlNile", size: 14)
            label.textColor = UIColor(red: 143/255, green: 143/255, blue: 143/255, alpha: 1)
            label.text = "如果还可以重来,我将用一生去呵护你..."
           headerView.addSubview(label)
        }
        
        tableView.tableHeaderView = headerView
    }
    
    //MARKS: 返回cell行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personInfos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonInfoCell", forIndexPath: indexPath) as! PersonInfoCell
        
        //set data
        cell.dateLabel.text = personInfos[0].date
        cell.placeLabel.text = personInfos[0].place
        cell.contentLabel.text = personInfos[0].infos[0].content
        
        return cell
    }
}
