//
//  CustomAlertView.swift
//  WeChat
//
//  Created by Smile on 16/2/5.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//弹出视图
class AlertView {
    
    var imageName:String?
    var image:UIImage?
    var string:String!
    
    init(string:String){
        self.string = string
    }
    
    init(imageName:String?,string:String!){
        if imageName != nil {
            self.imageName = imageName
        }
        self.string = string
        create()
    }
    
    init(image:UIImage?,string:String!){
        if image != nil {
            self.image = image
        }
        self.string = string
    }
    
    func create(){
        if self.imageName != nil {
            self.image = UIImage(named: imageName!)
        }
    }
}

//自定义弹出框,带箭头
class CustomAlertView: UIView {

    var isLayedOut:Bool = false
    
    var alertViews = [AlertView]()
    var bgColor:UIColor?
    var textColor:UIColor?
    var fontName:String?
    var fontSize:CGFloat?
    var controlFrame:CGRect!
    
    let topPadding:CGFloat = 7//箭头高度
    let leftPadding:CGFloat = 5//剪头宽度的一半
    
    let imageWidth:CGFloat = 30
    let imageHeight:CGFloat = 30
    
    let imagePadding:CGFloat = 10//图片左右空白
    let innerPadding:CGFloat = 10//上下空白
    var isCreateImage:Bool = false
    
    var oneHeight:CGFloat = 0//每一个view的高度
    var totalHeight:CGFloat = 0//框架总高度
    let linePadding:CGFloat = 15//线条左右空白
    let corner:CGFloat = 5//圆角
    
    init(frame: CGRect,controlFrame:CGRect,bgColor:UIColor?,
        textColor:UIColor?,fontName:String?,fontSize:CGFloat?,alertViews:[AlertView]) {
        
        oneHeight = innerPadding * 2 + imageHeight
        totalHeight = oneHeight * CGFloat(alertViews.count)
        super.init(frame: CGRectMake(frame.origin.x, frame.origin.y, frame.width, totalHeight + topPadding))
        
        if bgColor != nil {
            self.bgColor = bgColor
        }
        
        if textColor != nil {
            self.textColor = textColor
        }
        
        if fontName != nil {
            self.fontName = fontName
        }
        
        if fontSize != nil {
            self.fontSize = fontSize
        }
        
        self.alertViews = alertViews
        self.controlFrame = controlFrame
        
        initFrame()
    }
    
    func initFrame(){
        if self.bgColor == nil {
            self.bgColor = UIColor.darkGrayColor()
        }
        
        if self.textColor == nil {
            self.textColor = UIColor.whiteColor()
        }
        
        if self.fontName == nil {
            self.fontName = "AlNile"
        }
        
        if self.fontSize == nil {
            self.fontSize = 16
        }
        
        let alertView = alertViews[0]
        if alertView.image != nil {
            self.isCreateImage = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARKS: 重新绘制View
    override func drawRect(rect: CGRect) {
       self.layer.mask = drawView()
    }
    
    func drawView() -> CAShapeLayer{
        let path = UIBezierPath()
       //path.addArcWithCenter(point, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        
        path.moveToPoint(CGPointMake(0, topPadding))
        
        let topBeginX:CGFloat = self.controlFrame.origin.x + (self.controlFrame.width / 2)
        
        //左上角圆角
        path.addArcWithCenter(CGPoint(x: corner, y: corner + topPadding), radius: corner , startAngle: CGFloat(M_PI) , endAngle:  CGFloat(3 * M_PI / 2), clockwise: true)
        
        path.addLineToPoint(CGPointMake(topBeginX, topPadding))// -
        path.addLineToPoint(CGPointMake(topBeginX + leftPadding, 0))// /
        path.addLineToPoint(CGPointMake(topBeginX + leftPadding * 2, topPadding))// \
        
        path.addLineToPoint(CGPointMake(self.frame.width - corner, topPadding))// -
        
        //右下角圆角
        path.addArcWithCenter(CGPoint(x: self.frame.width - corner, y: corner + topPadding), radius: corner , startAngle: CGFloat(M_PI/2) , endAngle:  0 , clockwise: true)
        
        path.addLineToPoint(CGPointMake(self.frame.width, self.frame.height - corner))// |
        
        //右下角圆角
        path.addArcWithCenter(CGPoint(x: self.frame.width - corner, y: self.frame.height - corner), radius: corner , startAngle: 0 , endAngle:  CGFloat(M_PI/2), clockwise: true)
        
        path.addLineToPoint(CGPointMake(corner, self.frame.height))// -
        
        //左下角圆角
        path.addArcWithCenter(CGPoint(x: corner, y: self.frame.height - corner), radius: corner , startAngle: CGFloat(2 * M_PI / 3) , endAngle:  CGFloat(M_PI), clockwise: true)
        
        path.addLineToPoint(CGPointMake(0, topPadding + corner)) // |
        
        let shape = CAShapeLayer()
        shape.path = path.CGPath
        shape.fillColor = self.bgColor?.CGColor//填充颜色
        shape.lineWidth = 1
        path.closePath()
        return shape
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isLayedOut {
            self.backgroundColor = self.bgColor
            self.alpha = 0.95
            
            if self.alertViews.count > 0 {
                createView()
            }
            
            self.isLayedOut = true
        }
    }
    
    
    func createView(){
        var beginY:CGFloat = topPadding
        for(var i = 0;i < alertViews.count;i++){
            let alertView = alertViews[i]
            
            var imageView:UIImageView?
            if isCreateImage {
                imageView = UIImageView(frame: CGRectMake(imagePadding, innerPadding, imageWidth, imageHeight))
                imageView?.image = alertView.image
            }
            
            let label = UILabel()
            if imageView != nil {
                let beginX:CGFloat = imageView!.frame.origin.x + imageWidth + imagePadding
                let width:CGFloat = self.frame.width - beginX - imagePadding
                label.frame = CGRectMake(beginX, imageView!.frame.origin.y + 3, width , imageHeight)
            } else {
                let width:CGFloat = self.frame.width - imagePadding * 2
                label.frame = CGRectMake(imagePadding, innerPadding + 3, width , imageHeight)
            }
            
            label.text = alertView.string
            label.font = UIFont(name: self.fontName!, size: self.fontSize!)
            label.textColor = self.textColor
            
            let view = UIView()
            view.frame = CGRectMake(0, beginY, self.frame.width, oneHeight)
            if imageView != nil {
                view.addSubview(imageView!)
            }
            view.addSubview(label)
            
            beginY += oneHeight
            if i != (alertViews.count - 1) {
                let shape = WeChatDrawView().drawLine(beginPointX: linePadding, beginPointY: beginY, endPointX: self.frame.width - linePadding, endPointY: beginY,color:UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1))
                shape.lineWidth = 0.2
                self.layer.addSublayer(shape)
            }
            
            self.addSubview(view)
        }
        
    }
}
