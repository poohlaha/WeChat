//
//  WeChatToolsBottomAlert.swift
//  WeChat
//
//  Created by Smile on 16/3/7.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class ToolsBottom {
    var image:UIImage!
    var label:UILabel?
    var bgColor:UIColor = UIColor.whiteColor()
    var font = UIFont(name: "Arial", size: 8)
    var textColor:UIColor = UIColor.lightGrayColor()
    
    init(image:UIImage,label:UILabel,bgColor:UIColor,textColor:UIColor){
        self.image = image
        self.label = label
        self.bgColor = bgColor
        self.textColor = textColor
    }
    
    init(image:UIImage,bgColor:UIColor,textColor:UIColor){
        self.image = image
        self.bgColor = bgColor
        self.textColor = textColor
    }
    
    init(image:UIImage,label:UILabel){
        self.image = image
        self.label = label
    }
    
    init(image:UIImage){
        self.image = image
    }
}

//底部按钮
class ToolBottomButton {
    var text:String
    var bgColor:UIColor = UIColor.whiteColor()
    var textColor:UIColor = UIColor.blackColor()
    var font = UIFont(name: "Arial", size: 16)
    
    init(text:String){
        self.text = text
    }
    
    init(text:String,bgColor:UIColor,textColor:UIColor,font:UIFont){
        self.text = text
        self.bgColor = bgColor
        self.textColor = textColor
        self.font = font
    }
}


class WeChatToolsBottomAlert: WeChatDrawView,UITableViewDelegate {

    var title:String?//标题
    var data:[[ToolsBottom]] = []//tableView组数
    var buttons:[ToolBottomButton] = []
    var bgColor:UIColor?
    
    //MARKS: title properties
    var titleColor:UIColor = UIColor.lightGrayColor()
    var titleFont:UIFont = UIFont(name: "Arial", size: 9)!
    var titleTopPadding:CGFloat = 5
    var titleBottomPadding:CGFloat = 10
    var titleHeight:CGFloat = 10
    
    var viewMaxHeight:CGFloat = 0//视图最大高度,为屏幕高度的一半
    var tableViewHeight:CGFloat = 0
    var tableViewTopPadding:CGFloat = 10
    var tableViewBottomPadding:CGFloat = 20
    
    var buttonHeight:CGFloat = 30
    
    
    init(frame: CGRect,backgroundColor bgColor:UIColor?,title:String?,data:[[ToolsBottom]],buttons:[ToolBottomButton]) {
        viewMaxHeight = UIScreen.mainScreen().bounds.height / 2
        
        var height:CGFloat = frame.height
        //计算tableView的高度
        if data.count > 1 {
            height = viewMaxHeight
        }
        
        //计算tableViewHeight,如果有两个以上tableView需要添加scrollView
        tableViewHeight = height - (titleTopPadding + titleHeight + titleBottomPadding) - (tableViewTopPadding + tableViewBottomPadding) * 2 - CGFloat(buttonHeight * CGFloat(buttons.count)) / 2
        
        
        let viewFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.width, height)
        super.init(frame: viewFrame)
        
        if title != nil {
            self.title  = title
        }
        
        self.buttons = buttons
        self.data = data
        
        drawView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARKS: 绘制view
    func drawView(){
        if self.data.count == 0 {
            return
        }
        
        //绘制标题
        if self.title != nil {
            let titleLabel = drawLabel(self.title!, font: self.titleFont, contentMode: .Center, textColor: self.titleColor, originX: 0, originY: self.titleTopPadding, labelWidth: self.frame.width, labelHeight: self.titleHeight)
            self.addSubview(titleLabel)
        }
        
        drawTableView()
    }
    
    //MARKS: 绘制tableView
    func drawTableView(){
        for(var i = 0;i < self.data.count;i++){
            let bottoms:[ToolsBottom] = self.data[i]
            if bottoms.count <= 0 {
                continue
            }
            
            for(var j = 0;j < bottoms.count;j++){
                
            }
        }
    }
    
    //MARKS: 绘制图片
    func drawImageView(image:UIImage,originX:CGFloat,originY:CGFloat,imageWidth:CGFloat,imageHeight:CGFloat) -> UIImageView{
        let imageView = UIImageView()
        imageView.frame = CGRectMake(originX, originY, imageWidth, imageHeight)
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .Center
        
        return imageView
    }
    
    //MARKS:绘制Label
    func drawLabel(text:String,font:UIFont,contentMode:UIViewContentMode,textColor:UIColor,originX:CGFloat,originY:CGFloat,
        labelWidth:CGFloat,labelHeight:CGFloat) -> UILabel{
        let label = UILabel()
        label.frame = CGRectMake(originX, originY, labelWidth, labelHeight)
        label.text = text
        label.font = font
        label.contentMode = contentMode
        label.textColor = textColor
        
        return label
    }
    
}
