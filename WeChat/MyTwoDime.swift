//
//  MyTwoDime.swift
//  WeChat
//
//  Created by Smile on 16/2/15.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class MyTwoDime: UIView {
    
    var bgColor:UIColor?
    
    let leftPadding:CGFloat = 15
    let twoDimeViewHeight:CGFloat = 450
    var twoDimeViewWidth:CGFloat = 0
    var beginY:CGFloat = 0

    init(frame: CGRect,bgColor:UIColor?) {
        super.init(frame: frame)
        
        if bgColor != nil {
            self.bgColor = bgColor
        } else {
            self.bgColor = UIColor(patternImage: UIImage(named: "bg")!)
        }
        
        self.twoDimeViewWidth = self.frame.width - leftPadding * 2
        self.beginY = (self.frame.height - twoDimeViewHeight) / 2
        initFrame()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initFrame(){
        let view = UIView()
        view.frame = CGRectMake(leftPadding, beginY, twoDimeViewWidth, twoDimeViewHeight)
        view.backgroundColor = UIColor.whiteColor()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "my-wechat")
        let padding:CGFloat = 20
        twoImageView.frame = CGRectMake(padding, padding, view.frame.width - padding * 2, view.frame.height - padding * 2)
        view.addSubview(twoImageView)
        
        //设置背景
        self.backgroundColor = self.bgColor
        self.addSubview(view)
    }
}
