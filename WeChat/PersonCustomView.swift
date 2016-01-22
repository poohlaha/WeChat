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
    var bgImageView:UIImageView?
    var photos:[Photo]?
    
    init(frame: CGRect,tableView:UITableView,color:UIColor?) {
        super.init(frame: frame)
        self.tableView = tableView
        if color == nil {
            self.color = UIColor.whiteColor()
        }else{
            self.color = color
        }
        
        self.bgColor = UIColor(red: 135, green: 206, blue: 255, alpha: 1)
        self.backgroundColor = self.color
        self.userInteractionEnabled = true
        self.bgImageView = UIImageView(image: UIImage(named: "custom-bg"))
        bgImageView!.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.addSubview(self.bgImageView!)
        self.sendSubviewToBack(self.bgImageView!)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.bgImageView?.removeFromSuperview()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.bgImageView?.removeFromSuperview()
    }*/
}

