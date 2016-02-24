//
//  LastCellCustomView.swift
//  WeChat
//
//  Created by Smile on 16/1/17.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//Cell最后一行画线条
class LastCellCustomView: UIView {

    var isLayedOut:Bool = false
    var height:CGFloat = 5//总高度
    var rightPadding:CGFloat = 30//右侧空白
    var padding:CGFloat = 5//中间空白
    var color:UIColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isLayedOut {
            drawLast()
        }
        
    }
    
    //最后一行添加底部线条
    func drawLast(){
        //计算线条长度
        var width = self.frame.width
        width -= rightPadding
        
        //点的位置
        let pointX:CGFloat = width / 2
        let leftWidth = pointX - padding
        //let rightWidth = width - (pointX + padding)
        let pointY = self.frame.height - height
        
        //画直线
        let line1Shape = WeChatDrawView().drawLine(beginPointX: 0, beginPointY: pointY, endPointX: leftWidth, endPointY:pointY,color:color)
        self.layer.addSublayer(line1Shape)
        
        let shape = WeChatDrawView().drawArc(CGPointMake(pointX,self.frame.height - height),radius:2,color:color)
        self.layer.addSublayer(shape)
        
        let line2Shape = WeChatDrawView().drawLine(beginPointX: pointX + padding, beginPointY: pointY, endPointX: width, endPointY:pointY,color:color)
        self.layer.addSublayer(line2Shape)
    }
    
}
