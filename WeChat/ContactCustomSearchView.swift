//
//  ContactCustomSearchView.swift
//  WeChat
//
//  Created by Smile on 16/1/18.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义search视图,用于当用户开始输入数据的时候显示,以及显示搜索结果
class ContactCustomSearchView: UIViewController,UISearchBarDelegate {
    
    //MARKS: Properties
    let searchBarHeight:CGFloat = 40
    let searchBarBottomPadding:CGFloat = 40
    let arcWidthHeight:CGFloat = 80
    let arcNum:CGFloat = 3
    let arcFillColor:UIColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    var topPadding:CGFloat?
    var index:Int = -1
    let arcBottomPadding:CGFloat = 20
    let labelWidth:CGFloat = 45
    let labelHeight:CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        initFrame()
    }
    
    func initFrame(){
        //设置背景颜色
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "touming-bg")!)
        self.view.backgroundColor = UIColor.whiteColor()
        getStatusHeight()
        createSearchBar()
        createThreeArc()
    }
    
    //MARKS: 获取状态栏高度
    func getStatusHeight(){
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        topPadding  = statusBarFrame.height
    }
    
    //MARKS: 创建搜索框
    func createSearchBar(){
        let searchBar = UISearchBar(frame: CGRectMake(0, topPadding!, UIScreen.mainScreen().bounds.width, searchBarHeight))
        searchBar.translucent = true
        searchBar.placeholder = "搜索"
        searchBar.barStyle = .Default
        searchBar.showsCancelButton = true
        searchBar.showsScopeBar = false
        searchBar.barStyle = UIBarStyle.Default
        searchBar.searchBarStyle = UISearchBarStyle.Default
        searchBar.showsBookmarkButton = false
        searchBar.showsSearchResultsButton = false
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        
        //获取键盘
        searchBar.becomeFirstResponder()
    }
    
    //MARKS: 画三个圆
    func createThreeArc(){
        //计算圆之间的距离
        let arcPadding = (UIScreen.mainScreen().bounds.width - arcWidthHeight * arcNum) / (arcNum + 1)
        let originY = topPadding! + searchBarHeight + searchBarBottomPadding
        
        //计算第一个圆的位置
        let arcBegin1X:CGFloat = arcPadding
        let arcFrame1:CGRect = CGRectMake(arcBegin1X, originY, arcWidthHeight, arcWidthHeight)
        let arc1 = ContactSearchArcView(frame: arcFrame1, color: arcFillColor, image: UIImage(named: "arc-1")!)
        self.view.addSubview(arc1)
        
        //计算第二个圆的位置
        let arcBegin2X:CGFloat = arcPadding + arcWidthHeight + arcPadding
        let arcFrame2:CGRect = CGRectMake(arcBegin2X, originY, arcWidthHeight, arcWidthHeight)
        let arc2 = ContactSearchArcView(frame: arcFrame2, color: arcFillColor, image: UIImage(named: "arc-2")!)
        self.view.addSubview(arc2)
        
        //计算第三个圆的位置
        let arcBegin3X:CGFloat = UIScreen.mainScreen().bounds.width - arcWidthHeight - arcPadding
        let arcFrame3:CGRect = CGRectMake(arcBegin3X, originY, arcWidthHeight, arcWidthHeight)
        let arc3 = ContactSearchArcView(frame: arcFrame3, color: arcFillColor, image: UIImage(named: "arc-3")!)
        self.view.addSubview(arc3)
        
        let label1BeginX = (arcFrame1.width - labelWidth) / 2 + arcFrame1.origin.x
        let label2BeginX = (arcFrame2.width - (labelWidth - 15)) / 2 + arcFrame2.origin.x
        let label3BeginX = (arcFrame3.width - labelWidth) / 2 + arcFrame3.origin.x
        //MARKS: 添加圆底部文字
        let label1 = createLabel(CGRectMake(label1BeginX, arcFrame1.origin.y + arcFrame1.height + arcBottomPadding, labelWidth, labelHeight),string: "朋友圈")
        self.view.addSubview(label1)
        
        let label2 = createLabel(CGRectMake(label2BeginX, arcFrame2.origin.y + arcFrame2.height + arcBottomPadding, labelWidth - 15, labelHeight),string: "文章")
        self.view.addSubview(label2)
        
        let label3 = createLabel(CGRectMake(label3BeginX, arcFrame3.origin.y + arcFrame3.height + arcBottomPadding, labelWidth, labelHeight),string: "公众号")
        self.view.addSubview(label3)
    }
    
    func createLabel(frame:CGRect,string:String) -> UILabel{
        let label = UILabel(frame: frame)
        label.text = string
        label.font = UIFont(name: "AlNile", size: 14)
        return label
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
       dismissViewControllerAnimated(false) { () -> Void in
        if self.index >= 0 {
            let rootController = UIApplication.sharedApplication().delegate!.window?!.rootViewController as! UITabBarController
            rootController.selectedIndex = self.index
        }
       }
    }
    
}
