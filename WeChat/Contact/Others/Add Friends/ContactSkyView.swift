//
//  ContactSkyViewController.swift
//  WeChat
//
//  Created by Smile on 16/2/6.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//扫描雷达
class ContactSkyView: WeChatDrawView {
    
    var exitBtn:UIButton!
    var btnTopPadding:CGFloat = 10
    var statusHeight:CGFloat = 0
    var btnLeftPadding:CGFloat = 20
    var btnLabelWidth:CGFloat = 40
    var btnLabelHeight:CGFloat = 15
    var leftPadding:CGFloat = 5
    var topPadding:CGFloat = 10
    let fontName:String = "AlNile"
    let fontSize:CGFloat = 14
    var width:CGFloat = 0
    var height:CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        statusHeight = UIApplication.sharedApplication().statusBarFrame.height
        self.backgroundColor = UIColor(patternImage: UIImage(named: "sky-bg")!)
        self.width = UIScreen.mainScreen().bounds.width
        self.height = UIScreen.mainScreen().bounds.height
        
        createExitButton()
        drawArcs()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARKS: 创建退出按钮
    func createExitButton(){
        self.exitBtn = UIButton(type: .Custom)
        self.exitBtn.backgroundColor = UIColor.clearColor()
        
        self.exitBtn.layer.masksToBounds = true
        self.exitBtn.layer.cornerRadius = 5
        self.exitBtn.layer.borderWidth = 0.5
        self.exitBtn.setBackgroundImage(UIImage(named: "sky-exit"), forState: .Normal)
        
        self.exitBtn.setTitle("退出", forState: .Normal)
        self.exitBtn.titleLabel!.font = UIFont(name: self.fontName, size: self.fontSize)
        self.exitBtn.titleLabel!.textAlignment = .Center
        
        self.exitBtn.frame = CGRectMake(btnLeftPadding, statusHeight + btnTopPadding, btnLabelWidth + leftPadding * 2, btnLabelHeight + topPadding + 5)
        
        self.exitBtn.contentEdgeInsets = UIEdgeInsetsMake(3,0, 0, 0);
        
        self.addSubview(self.exitBtn)
    }
    
    func drawArcs(){
        let point:CGPoint = CGPointMake(width / 2,height / 2)//中心点
        self.addSubview(HeaderArcView(frame: CGRectMake(point.x - width / 6, point.y - width / 6, width / 3, width / 3), image: UIImage(named: "my-header")!,strokeColor:UIColor.whiteColor()))
        
        //WeChatDrawView().drawArc(point, radius: width / 6,strokeColor:UIColor.whiteColor(),fillColor: UIColor.blueColor(),shadowOpacity: 1,shadowOffset: CGSizeMake(3, 3),shadowRadius: 5,shadowColor: UIColor.whiteColor())
        //drawArc(point, radius: width / 6,fillColor:UIColor.clearColor(),strokeColor: UIColor.whiteColor(),shadowOpacity: 0.5,shadowOffset: CGSizeMake(5, 5),shadowRadius: 10,shadowColor: UIColor.whiteColor())
        
        //drawArc(point, radius: width / 6)
        drawArc(point, radius: width * 2 / 6)
        drawArc(point, radius: width * 11 / 20)
        drawArc(point, radius: height * 7 / 16)
    }
    
    func drawArc(point:CGPoint,radius:CGFloat){
        let path = UIBezierPath()
        path.addArcWithCenter(point, radius: radius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        
        let shape = CAShapeLayer()
        shape.path = path.CGPath
        shape.fillColor = UIColor.clearColor().CGColor// 闭环填充的颜色
        shape.strokeColor = UIColor(red: 161/255, green: 161/255, blue: 161/255, alpha: 1).CGColor// 边缘线的颜色
        shape.strokeEnd = 1.0
        shape.lineWidth = 1
        path.closePath()
        self.layer.addSublayer(shape)
    }
   
}


//自定义头像
class HeaderArcView:WeChatDrawView {
    
    //MARKS: Properties
    var isLayedOut:Bool = false
    var image:UIImage?
    let imageWidth:CGFloat = 40
    let imageHeight:CGFloat = 40
    var strokeColor:UIColor?
    var imageView:UIImageView!
    
    init(frame: CGRect,image:UIImage,strokeColor:UIColor?) {
        super.init(frame:frame)
        self.image = image
        self.userInteractionEnabled = true
        if strokeColor != nil {
            self.strokeColor = strokeColor
        } else {
            self.strokeColor = UIColor.clearColor()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayedOut {
            self.imageView = UIImageView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
            imageView.image = image
            //setImageViewLayer()
            self.addSubview(imageView)
        }
    }
    
    func create(){
        self.clipsToBounds = true
        //self.backgroundColor = UIColor.clearColor()
        self.layer.shadowColor = UIColor.whiteColor().CGColor
        self.layer.shadowOffset = CGSizeMake(15,15)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 10
        //self.layer.shadowPath = UIBezierPath(roundedRect: self.frame, cornerRadius: 100).CGPath
    }
    
    func setImageViewLayer(){
        imageView.layer.shadowColor = UIColor.redColor().CGColor
        imageView.layer.shadowOffset = CGSizeMake(0,0);
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowRadius = 3
        
        let path = UIBezierPath()
        let width:CGFloat = imageView.bounds.size.width
        let height:CGFloat = imageView.bounds.size.height
        let x:CGFloat = imageView.bounds.origin.x
        let y:CGFloat = imageView.bounds.origin.y
        let addWH:CGFloat = 10
        
        let topLeft      = imageView.bounds.origin
        let topMiddle = CGPointMake( x + (width / 2),y - addWH)
        let topRight     = CGPointMake(x + width,y)
        
        let rightMiddle:CGPoint = CGPointMake(x + width + addWH,y + (height / 2))
        
        let bottomRight:CGPoint  = CGPointMake(x + width,y + height)
        let bottomMiddle:CGPoint = CGPointMake(x + (width / 2),y + height + addWH)
        let bottomLeft:CGPoint   = CGPointMake(x,y + height)
        
        let leftMiddle:CGPoint = CGPointMake(x - addWH,y + (height / 2))
        
        path.moveToPoint(topLeft)
        //添加四个二元曲线
        path.addQuadCurveToPoint(topRight, controlPoint: topMiddle)
        path.addQuadCurveToPoint(bottomRight, controlPoint: rightMiddle)
        path.addQuadCurveToPoint(bottomLeft, controlPoint: bottomMiddle)
        path.addQuadCurveToPoint(topLeft, controlPoint: leftMiddle)
        
        //设置阴影路径
        imageView.layer.shadowPath = path.CGPath;
    }
    
    //重新绘制形状
    override func drawRect(rect: CGRect) {
        //let path = UIBezierPath(roundedRect: self.frame, cornerRadius: self.frame.size.width / 2)
        //let shape = drawArc(path,point: CGPointMake(frame.size.width / 2, frame.size.height / 2), radius: frame.size.width / 2,strokeColor:self.strokeColor!,fillColor: UIColor.whiteColor(),shadowOpacity: 0.7,shadowOffset: CGSizeMake(3, 3),shadowRadius: 5,shadowColor: UIColor.whiteColor())
        
        //let shape = drawArc(CGPointMake(frame.size.width / 2, frame.size.height / 2), radius: frame.size.width / 2,strokeColor:self.strokeColor!,fillColor: UIColor.whiteColor(),shadowOpacity: 0.7,shadowOffset: CGSizeMake(13, 13),shadowRadius: 15,shadowColor: UIColor.whiteColor())
        
        let shape = drawArc(CGPointMake(frame.size.width / 2, frame.size.height / 2), radius: frame.size.width / 2,color:UIColor.whiteColor())
        //layer的mask，顾名思义，是种位掩蔽，在shapeLayer的填充区域中，alpha值不为零的部分，self会被绘制；alpha值为零的部分，self不会被绘制
        self.layer.mask = shape
        //self.layer.masksToBounds = true
        //self.layer.cornerRadius = self.frame.size.width / 2
        //self.layer.borderWidth = 3
        //self.layer.borderColor = UIColor.greenColor().CGColor
        
        /*
        let cfx = UIGraphicsGetCurrentContext()//获取绘制上下文
        CGContextSaveGState(cfx)//保存上下文状态
        
        let textShadowOffset = CGSizeMake(10, 10)//阴影区域
        CGContextSetShadow(cfx, textShadowOffset, 20)//设置上下文阴影
        let textColorSpace = CGColorSpaceCreateDeviceRGB()//设置颜色类型
        
        let textColorValues:[CGFloat] = [251,51,102,1.0]
        let textColor = CGColorCreate(textColorSpace, textColorValues)
        CGContextSetShadowWithColor(cfx, textShadowOffset, 20, textColor)//为上下文设置阴影颜色,大小
        CGContextRestoreGState(cfx)*/
        
        
    }
    
}
