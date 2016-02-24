//
//  PersonImageView.swift
//  WeChat
//
//  Created by Smile on 16/1/16.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义小头像
class PersonImageView:WeChatDrawView{
    
    //MARKS: Properties
    var image:UIImage?
    var color:UIColor = UIColor.whiteColor()
    var spacePadding:CGFloat = 3
    var isLayedOut:Bool = false
    
    
    init(frame: CGRect,image:UIImage,spacePadding:CGFloat,color:UIColor) {
        super.init(frame: frame)
        self.image = image
        self.color = color
        self.spacePadding = spacePadding
        self.backgroundColor = color
    }
    
    init(frame: CGRect,image:UIImage,spacePadding:CGFloat) {
        super.init(frame: frame)
        self.image = image
        self.backgroundColor = UIColor.whiteColor()
    }

    init(frame: CGRect,image:UIImage) {
        super.init(frame: frame)
        self.image = image
        self.backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayedOut {
            let shape = drawRect(beginPointX: 0, beginPointY: 0, width: self.frame.width, height: self.frame.height, color: UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 238/255))
            self.layer.addSublayer(shape)
            
            let imageView = UIImageView(image: image)
            imageView.userInteractionEnabled = true// 使图片视图支持交互
            imageView.frame = CGRectMake(spacePadding, spacePadding, self.frame.width - spacePadding * 2, self.frame.height - spacePadding * 2)
            self.addSubview(imageView)
        }
    }
    
    override func drawRect(beginPointX x:CGFloat,beginPointY y:CGFloat,width:CGFloat,height:CGFloat,color:UIColor) -> CAShapeLayer{
        let path = UIBezierPath(roundedRect: CGRectMake(x, y, width, height), cornerRadius: 0)
        //path.fill()
        let shape = CAShapeLayer()
        shape.path = path.CGPath
        shape.strokeColor = color.CGColor
        shape.fillColor = UIColor.whiteColor().CGColor
        shape.lineWidth = 1
        path.closePath()
        return shape
    }
}
