//
//  ContactSearchArcView.swift
//  WeChat
//
//  Created by Smile on 16/1/18.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义圆view
class ContactSearchArcView: WeChatDrawView {
    
    //MARKS: Properties
    var isLayedOut:Bool = false
    var bgColor:UIColor?
    var image:UIImage?
    let imageWidth:CGFloat = 40
    let imageHeight:CGFloat = 40

    init(frame: CGRect,color bgColor:UIColor,image:UIImage) {
        super.init(frame:frame)
        self.bgColor = bgColor
        self.image = image
        self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = self.bgColor
        if !isLayedOut {
            //计算padding
            let paddingX = (self.frame.width - imageWidth) / 2
            let paddingY = (self.frame.height - imageHeight) / 2
            let imageView = UIImageView(frame: CGRectMake(paddingX, paddingY, imageWidth, imageHeight))
            imageView.image = image
            self.addSubview(imageView)
        }
    }
    
    //重新绘制视图
    /*
    override func drawRect(rect: CGRect) {
        let context:CGContextRef = UIGraphicsGetCurrentContext()!//获取画笔上下文
        CGContextSetAllowsAntialiasing(context, true)//抗锯齿设置
        CGContextSetLineWidth(context, 5)
        CGContextSetFillColorWithColor(context, UIColor.blueColor().CGColor)
        //CGContextAddEllipseInRect(context, frame)//画圆
        
        //x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
        CGContextAddArc(context, frame.size.width / 2, frame.size.height / 2, frame.size.width / 2, 0, 360, 0)//添加一个圆
        //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
        CGContextDrawPath(context, .Fill); //绘制路径加填充
        //CGContextStrokePath(context)//关闭路径
    }*/
    
    //重新绘制形状
    override func drawRect(rect: CGRect) {
       let shape = drawArc(CGPointMake(frame.size.width / 2, frame.size.height / 2), radius: frame.size.width / 2, color: self.bgColor!)
        //layer的mask，顾名思义，是种位掩蔽，在shapeLayer的填充区域中，alpha值不为零的部分，self会被绘制；alpha值为零的部分，self不会被绘制
        self.layer.mask = shape
    }
    
}
