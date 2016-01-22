//
//  WeChatNavigationBottomLabelView.swift
//  WeChat
//
//  Created by Smile on 16/1/21.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class WeChatNavigationBottomLabelView: UIView {

    var isLayedOut:Bool = false
    var text:String!
    var bgColor:UIColor!
    let fontName:String = "Arial"
    let fontSize:CGFloat = 12
    let labelPadding:CGFloat = 10
    let labelTopBottomPadding:CGFloat = 10
    let maxHeight:CGFloat = 100
    var bottomHeight:CGFloat = 0
    
    init(frame: CGRect,text:String,bgColor:UIColor,bottomHeight:CGFloat) {
        super.init(frame: frame)
        if !text.isEmpty {
            self.text = text
        }
        self.bgColor = bgColor
        self.bottomHeight = bottomHeight
    }
    
    init(frame: CGRect,text:String,bottomHeight:CGFloat) {
        super.init(frame: frame)
        if !text.isEmpty {
            self.text = text
        }
        
        self.bgColor = UIColor.blackColor()
        self.bottomHeight = bottomHeight
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayedOut {
            createLabel()
            isLayedOut = true
        }
    }
    
    //MARKS: Label高度自适应
    func createLabel(){
        if self.text != nil {
            if !self.text.isEmpty {
                let label = UILabel(frame: CGRectMake(0,labelTopBottomPadding,UIScreen.mainScreen().bounds.width - labelPadding * 2,0))
                label.lineBreakMode = .ByTruncatingTail
                label.numberOfLines = 0
                label.font = UIFont(name: fontName, size: fontSize)
                label.textColor = UIColor.whiteColor()
                label.text = self.text
                let options : NSStringDrawingOptions = [.UsesLineFragmentOrigin,.UsesFontLeading]
                let boundingRect = self.text!.boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.width - labelPadding * 2, 0), options: options, attributes: [NSFontAttributeName:label.font], context: nil)
                //var size = label.text!.sizeWithAttributes([NSFontAttributeName:label.font])
                
                var labelHeight:CGFloat = boundingRect.size.height
                if labelHeight > maxHeight {
                    labelHeight = maxHeight - labelTopBottomPadding * 2
                    label.numberOfLines = 0
                }
                
                label.frame = CGRectMake(labelPadding, labelTopBottomPadding, boundingRect.size.width, labelHeight)
                //重新调整view的高度
                let frameHeight:CGFloat = labelHeight + labelTopBottomPadding * 2
                let frameY = UIScreen.mainScreen().bounds.height - frameHeight - bottomHeight
                self.frame = CGRectMake(self.frame.origin.x, frameY, self.frame.width, frameHeight)
                
                self.addSubview(label)
            }
        }
        
        self.backgroundColor = self.bgColor
    }
}

class WeChatNavigationBottomLabelBottomView:UIView {
    
    var isLayedOut:Bool = false
    let fontName:String = "Arial"
    let fontSize:CGFloat = 12
    let labelPadding:CGFloat = 10//文字中间空白
    let topBottomPadding:CGFloat = 10//底部空白
    var height:CGFloat = 30//view总高度
    let padding:CGFloat = 3//右侧两图片中间空白
    
    let likeWidth:CGFloat = 22
    var commentWidth:CGFloat = 22
    var labelHeight:CGFloat = 0//文字的高度和图片一样
    let likeLabelWidth:CGFloat = 15
    let commentLabelWidth:CGFloat = 30
    
    var likeImage:UIImage!
    var commentImage:UIImage!
    
    init(height:CGFloat){
        super.init(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height - height, UIScreen.mainScreen().bounds.width, height))
        self.height = height
        self.likeImage = UIImage(named: "like")
        self.commentImage = UIImage(named: "comment")
        self.labelHeight = self.frame.height - topBottomPadding * 2
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.darkGrayColor()
        if !isLayedOut {
            createLeft()
            createRight()
            isLayedOut = true
        }
    }

    func createLeft(){
        let leftWidth = likeWidth + padding + likeLabelWidth + labelPadding + 1 + labelPadding + commentWidth + padding + commentLabelWidth
        let leftView = UIView()
        leftView.frame = CGRectMake(labelPadding, 0, leftWidth, self.frame.height)
        
        let likeImageView = UIImageView(frame: CGRectMake(0,topBottomPadding,likeWidth,labelHeight))
        likeImageView.image = self.likeImage
        leftView.addSubview(likeImageView)
        
        let zanLabel = UILabel()
        zanLabel.frame = CGRectMake(likeImageView.frame.origin.x + likeWidth + padding, likeImageView.frame.origin.y, likeLabelWidth, likeImageView.frame.height)
        zanLabel.text = "赞"
        zanLabel.textColor = UIColor.whiteColor()
        zanLabel.font = UIFont(name: self.fontName, size: self.fontSize)
        leftView.addSubview(zanLabel)
        
        let lineBeginX:CGFloat = zanLabel.frame.origin.x + likeLabelWidth + labelPadding
        let line1Shape = WeChatDrawView().drawLine(beginPointX: lineBeginX, beginPointY: likeImageView.frame.origin.y - 2, endPointX: lineBeginX, endPointY:self.frame.height - topBottomPadding + 2,color:UIColor.lightTextColor())
        leftView.layer.addSublayer(line1Shape)
        
        let commentImageView = UIImageView(frame: CGRectMake(lineBeginX + labelPadding, likeImageView.frame.origin.y, commentWidth, labelHeight))
        commentImageView.image = self.commentImage
        leftView.addSubview(commentImageView)
        
        let commentLabel = UILabel()
        commentLabel.frame = CGRectMake(commentImageView.frame.origin.x + commentWidth + padding, commentImageView.frame.origin.y, commentLabelWidth, labelHeight)
        commentLabel.text = "评论"
        commentLabel.textColor = UIColor.whiteColor()
        commentLabel.font = UIFont(name: self.fontName, size: self.fontSize)
        leftView.addSubview(commentLabel)
        self.addSubview(leftView)
    }
    
    func createRight(){
        let rightView = UIView()
        rightView.frame = CGRectMake(self.frame.width - labelPadding - likeWidth - commentWidth - padding, topBottomPadding, likeWidth + commentWidth + padding, labelHeight)
        
        rightView.userInteractionEnabled = true
        
        let likeImageView = UIImageView(frame: CGRectMake(0,0,likeWidth,labelHeight))
        likeImageView.image = self.likeImage
        
        let commentImageView = UIImageView(frame: CGRectMake(likeImageView.frame.origin.x + likeWidth + padding, likeImageView.frame.origin.y, commentWidth, labelHeight))
        commentImageView.image = self.commentImage
        rightView.addSubview(likeImageView)
        rightView.addSubview(commentImageView)
        
        rightView.addGestureRecognizer(WeChatUITapGestureRecognizer(target: self, action: "rightTap:"))
        self.addSubview(rightView)
    }
 
    //MARKS: 右侧事件
    func rightTap(gestrue: WeChatUITapGestureRecognizer){
        print("rightTap")
    }
}