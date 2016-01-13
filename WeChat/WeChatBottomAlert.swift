//
//  WeChatBottomAlert.swift
//  WeChat
//
//  Created by Smile on 16/1/12.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class WeChatBottomAlert: WeChatDrawView {
    
    //MARKS: Properties
    var isLayedOut:Bool = false//是否初始化view
    var fontSize:CGFloat = 12//默认字体大小
    var labelHeight:CGFloat = 25//默认标签高度
    var titles = [String]()
    let paddintLeft:CGFloat = 30//padding-left
    let paddintTop:CGFloat = 15//padding-top
    let titleFontName:String = "Avenir-Light"//默认标题字体名称
    let fontName:String = "Cochin-Bold "//加粗字体
    let rectHeight:CGFloat = 5;//矩形高度
    var oneBlockHeight:CGFloat = 0//一块区域的高度
    var oneBlockWidth:CGFloat = 0//一块区域的宽度
    var otherSize:CGFloat = 18
    var originX:CGFloat = 0//开始绘制x坐标
    var originY:CGFloat = 0//开始绘制y坐标

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect,titles:[String],fontSize:CGFloat) {
        //MARKS: 初始化数据
        if fontSize > 0 {
            self.fontSize = fontSize
        }
        
        self.titles = titles
        
        oneBlockHeight = labelHeight + paddintTop * 2
        oneBlockWidth = frame.size.width - paddintLeft * 2
        
        //MARKS: 获取Alert总高度
        var totalHeight:CGFloat = 0
        for(var i = 0;i < titles.count;i++){
            totalHeight += oneBlockHeight
        }
        
        totalHeight += 5
        
        var y:CGFloat = 0
        if frame.origin.y < 0 {
            if frame.size.height <= 0 {
                y = UIScreen.mainScreen().bounds.height - totalHeight
            }
        }else{
            y = frame.origin.y
        }
        
        originX = frame.origin.x
        originY = y
        
        //super.init(frame: CGRectMake(frame.origin.x, y, frame.size.width, totalHeight))
        
        //初始化整个屏幕
        super.init(frame: UIScreen.mainScreen().bounds)
    
        //设置背景
        self.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        //self.alpha = 0.8
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //let shapeLayer = self.setUp()
        if !isLayedOut {
            //shapeLayer.frame.origin = CGPointZero
            //shapeLayer.frame.size = self.layer.frame.size
            
            if titles.count <= 1 {
                return
            }
            
            var _originY:CGFloat = originY
            var size:CGFloat = fontSize
            for(var i = 0;i < titles.count;i++){
                if i == 0 {
                    size = fontSize
                } else {
                    size = otherSize
                }
                if i != (titles.count - 1) {
                    var color:UIColor
                    var fontName:String = titleFontName
                    if i == 0 {
                        color = UIColor.grayColor()
                        fontName = titleFontName
                    }else{
                        color = UIColor.redColor()
                        fontName = self.fontName
                    }
                    
                    self.addSubview(drawAlertLabel(titles[i],y: _originY,size: size,color:color,isBold: false,fontName: fontName,width:UIScreen.mainScreen().bounds.width,height: oneBlockHeight))
                    _originY += oneBlockHeight
                    if titles.count >= 3 {
                        if i != (titles.count - 2) {
                            self.layer.addSublayer(drawLine(beginPointX: 0, beginPointY: _originY, endPointX: self.frame.size.width, endPointY: _originY))
                        }else{
                            self.layer.addSublayer(drawRect(beginPointX: 0, beginPointY: _originY, width: self.frame.size.width, height: rectHeight))
                            _originY += rectHeight
                        }
                    }
                }else{
                    self.addSubview(drawAlertLabel(titles[i],y: _originY,size: size,color: UIColor.blackColor(),isBold: true,fontName: fontName,width:UIScreen.mainScreen().bounds.width,height: oneBlockHeight))
                }
            }
            
            isLayedOut = true
        }
    }
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        super.removeFromSuperview()
    }
    

}
