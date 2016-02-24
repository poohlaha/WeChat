//
//  WeChatTabBarBadge.swift
//  WeChat
//
//  Created by Smile on 16/2/5.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//扩展UITabBar,自定义badge
extension UITabBar {
    
    //MARKS: 显示小红点
    func showBadgeOnItemIndex(index:Int) {
        self.removeBadgeOnItemIndex(index)
        //新建小红点
        let badgeView = UIView()
        badgeView.tag = 888 + index;
        badgeView.layer.cornerRadius = 5;//圆形
        badgeView.backgroundColor = UIColor.redColor()//颜色：红色
        
        let tabFrame = self.frame;
        
        //确定小红点的位置
        let percentX:CGFloat = (CGFloat(index) + 0.6) / CGFloat(self.items!.count)
        let x:CGFloat = CGFloat(ceilf(Float(percentX * tabFrame.size.width)))
        let y:CGFloat = CGFloat(ceilf(Float(0.1 * tabFrame.size.height)))
        badgeView.frame = CGRectMake(x, y, 10, 10)//圆形大小为10
        self.addSubview(badgeView)
    }
    
    //MARKS: 隐藏小红点
    func hideBadgeOnItemIndex(index:Int) {
        self.removeBadgeOnItemIndex(index)
    }
    
    //MARKS :移除小红点
    func removeBadgeOnItemIndex(index:Int) {
        //按照tag值进行移除
        for subView in self.subviews {
            if (subView.tag == 888 + index) {
                subView.removeFromSuperview()
            }
        }
    }
}
