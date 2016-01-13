//
//  DrawView.swift
//  WeChat
//
//  Created by Smile on 16/1/11.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    let lineWidth:CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawRect(rect: CGRect) {
        drawLine(rect.origin.x,y: rect.origin.y,width: rect.size.width)
        //drawLine(rect.origin.x,y: rect.origin.y + rect.size.height,width: rect.size.width)
    }
    
    func drawLine(x:CGFloat,y:CGFloat,width:CGFloat){
        let context:CGContextRef = UIGraphicsGetCurrentContext()!;//获取画笔上下文
        CGContextSetAllowsAntialiasing(context, true) //抗锯齿设置
        CGContextSetLineWidth(context, lineWidth) //设置画笔宽度
        CGContextMoveToPoint(context, x, y);
        CGContextAddLineToPoint(context, x, width);
        CGContextStrokePath(context)
    }
}
