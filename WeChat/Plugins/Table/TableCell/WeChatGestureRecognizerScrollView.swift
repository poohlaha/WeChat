//
//  WeChatScrollView.swift
//  WeChat
//
//  Created by Smile on 16/2/24.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义手势ScrollView
class WeChatGestureRecognizerScrollView: UIScrollView,UIGestureRecognizerDelegate {

    //MARKS: 手势开始
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panGestureRecognizer {
            let gesture = gestureRecognizer as! UIPanGestureRecognizer
            let translation = gesture.translationInView(gestureRecognizer.view)//返回在横坐标上、纵坐标上拖动了多少像素
            return fabs(translation.y) <= fabs(translation.x)//处理double类型的取绝对值
        } else {
            return true
        }
    }
    
    
    //MARKS: 禁止在某一点发生Gesture recognizers
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKindOfClass(UIPanGestureRecognizer.self) {
            let gesture = gestureRecognizer as! UIPanGestureRecognizer
            let velocity = gesture.velocityInView(gestureRecognizer.view).y//指定坐标系统中pan gesture拖动的速度
            return fabs(velocity) <= 0.20
        }
        
        return true
    }
}
