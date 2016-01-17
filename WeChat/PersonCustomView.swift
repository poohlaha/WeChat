//
//  PersonCustomView.swift
//  WeChat
//
//  Created by Smile on 16/1/16.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//个人信息自定义View
class PersonCustomView: UIView {

    var tableView:UITableView?
    var color:UIColor?
    var bgColor:UIColor?
    
    init(frame: CGRect,tableView:UITableView,color:UIColor?) {
        super.init(frame: frame)
        self.tableView = tableView
        self.color = color
        self.bgColor = UIColor(red: 135, green: 206, blue: 255, alpha: 1)
        
        self.backgroundColor = self.color
        self.userInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "viewTap:"))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARKS: Tap事件
    func viewTap(gestrue: UITapGestureRecognizer){
        //去掉所有cell的选中事件
        for(var i = 0;i < self.tableView!.numberOfSections; i++){
            for(var j = 0;j < self.tableView!.numberOfRowsInSection(i);j++){
                let indexPath = NSIndexPath(forRow: j, inSection: i)
                let cell = self.tableView!.cellForRowAtIndexPath(indexPath)
                for(var k = 0;k < cell?.subviews.count; k++){
                    let sub = cell?.subviews[k]
                    if sub == nil {
                        continue
                    }
                    
                    if sub!.isKindOfClass(PersonCustomView){
                        sub?.backgroundColor =  self.color
                    }
                }
            }
        }
        
        let gestureView = gestrue.view
        gestureView?.backgroundColor = UIColor(patternImage: UIImage(named: "custom-bg")!)
    }
}
