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
    let fontSize:CGFloat = 14
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
    let fontSize:CGFloat = 14
    let labelPadding:CGFloat = 10//文字中间空白
    let topBottomPadding:CGFloat = 10//底部空白
    var height:CGFloat = 30//view总高度
    let padding:CGFloat = 3//右侧两图片中间空白
    
    let likeWidth:CGFloat = 22
    var commentWidth:CGFloat = 22
    var labelHeight:CGFloat = 0//文字的高度和图片一样
    let likeLabelWidth:CGFloat = 15
    var cancelLabelWidth:CGFloat = 28
    let commentLabelWidth:CGFloat = 30
    var leftWidth:CGFloat = 0
    
    var likeImage:UIImage!
    var commentImage:UIImage!
    var isLiked:Bool = false
    var isLeftMove:Bool = false
    
    var leftView:UIView!
    var likeView:UIView!
    var likeImageView:UIImageView!
    var zanLabel:UILabel!
    var lineShape:CALayer!
    var rightView:UIView!
    var commentView:UIView!
    var rightLikeLabel:UILabel!
    var commentImageView:UIImageView!
    var rightLikeLabelWidth:CGFloat = 5
    var rightViewBeginX:CGFloat = 0
    var parentViewController:UIViewController!
    
    var likeCount:Int = 0//点赞数
    
    init(height:CGFloat,parentViewController:UIViewController){
        super.init(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height - height, UIScreen.mainScreen().bounds.width, height))
        self.height = height
        self.likeImage = UIImage(named: "like")
        self.commentImage = UIImage(named: "comment")
        self.labelHeight = self.frame.height - topBottomPadding * 2
        self.parentViewController = parentViewController
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
        //点赞视图
        self.likeView = UIView()
        likeView.frame = CGRectMake(0, topBottomPadding, likeWidth + likeLabelWidth + padding, labelHeight)
        
        //点赞图片
        self.likeImageView = UIImageView(frame: CGRectMake(0,0,likeWidth,likeView.frame.height))
        likeImageView.image = self.likeImage
        likeView.addSubview(likeImageView)
        
        //点赞Label
        self.zanLabel = UILabel()
        zanLabel.frame = CGRectMake(likeImageView.frame.origin.x + likeWidth + padding, 0, likeLabelWidth, likeView.frame.height)
        zanLabel.text = "赞"
        zanLabel.textColor = UIColor.whiteColor()
        zanLabel.font = UIFont(name: self.fontName, size: self.fontSize)
        likeView.addSubview(zanLabel)
        
        //分割线
        let lineBeginX:CGFloat = zanLabel.frame.origin.x + likeLabelWidth + labelPadding
        self.lineShape = WeChatDrawView().drawLine(beginPointX: lineBeginX, beginPointY: likeView.frame.origin.y - 2, endPointX: lineBeginX, endPointY:self.frame.height - topBottomPadding + 2,color:UIColor.lightTextColor())
        
        //评论视图
        self.commentView = UIView()
        commentView.frame = CGRectMake(lineBeginX + labelPadding, likeView.frame.origin.y, commentWidth + padding + commentLabelWidth, labelHeight)
        
        //评论图片
        let commentImageView = UIImageView(frame: CGRectMake(0, 0, commentWidth, labelHeight))
        commentImageView.image = self.commentImage
        commentView.addSubview(commentImageView)
        
        //评论Label
        let commentLabel = UILabel()
        commentLabel.frame = CGRectMake(commentImageView.frame.origin.x + commentWidth + padding, 0, commentLabelWidth, labelHeight)
        commentLabel.text = "评论"
        commentLabel.textColor = UIColor.whiteColor()
        commentLabel.font = UIFont(name: self.fontName, size: self.fontSize)
        commentView.addSubview(commentLabel)
        
        commentView.addGestureRecognizer(WeChatUITapGestureRecognizer(target: self, action: "addCommentView"))
        likeView.addGestureRecognizer(WeChatUITapGestureRecognizer(target: self, action: "likeViewTap:"))
        
        self.leftWidth = likeWidth + padding + likeLabelWidth + labelPadding + 1 + labelPadding + commentWidth + padding + commentLabelWidth
        //左侧视图
        self.leftView = UIView()
        self.leftView.frame = CGRectMake(labelPadding, 0, leftWidth, self.frame.height)
        
        self.leftView.addSubview(likeView)
        self.leftView.layer.addSublayer(lineShape)
        self.leftView.addSubview(commentView)
        self.leftView.bringSubviewToFront(commentView)
        self.addSubview(self.leftView)
    }
    
    func createRight(){
        let likeImageView = UIImageView(frame: CGRectMake(0,0,likeWidth,labelHeight))
        likeImageView.image = self.likeImage
        
        //点赞数量,重新设置其宽度
        let rightLikeWidth = getLikeLabelWidth()
        self.rightLikeLabel = UILabel()
        self.rightLikeLabel.frame = CGRectMake(likeImageView.frame.origin.x + likeWidth + padding, likeImageView.frame.origin.y, rightLikeWidth, likeImageView.frame.height)
        self.rightLikeLabel.textColor = UIColor.whiteColor()
        self.rightLikeLabel.font = UIFont(name: self.fontName, size: self.fontSize)
        
        self.commentImageView = UIImageView()
        if rightLikeWidth > 0 {
            commentImageView.frame =  CGRectMake(rightLikeLabel.frame.origin.x + self.rightLikeLabel.frame.width + padding, rightLikeLabel.frame.origin.y, commentWidth + padding, labelHeight)
        } else {
            commentImageView.frame = CGRectMake(likeImageView.frame.origin.x + likeWidth + padding, likeImageView.frame.origin.y, commentWidth, labelHeight)
        }
        
        commentImageView.image = self.commentImage
        
        //创建右侧视图
        rightView = UIView()
        var rightPadding:CGFloat = 0
        if rightLikeWidth > 0 {
            rightPadding = rightLikeWidth + padding
            isLeftMove = true
        }
        self.rightViewBeginX = self.frame.width - labelPadding - likeWidth - commentWidth - padding - rightPadding
        let rightViewWidth:CGFloat = likeWidth + commentWidth + padding + rightPadding
        rightView.frame = CGRectMake(self.rightViewBeginX, topBottomPadding, rightViewWidth, labelHeight)
        rightView.userInteractionEnabled = true
        
        rightView.addSubview(self.rightLikeLabel)
        rightView.addSubview(likeImageView)
        rightView.addSubview(commentImageView)
        
        //添加点击事件
        rightView.addGestureRecognizer(WeChatUITapGestureRecognizer(target: self, action: "rightTap:"))
        self.addSubview(rightView)
    }
    
    //MARKS: 获取点赞数量Label宽度
    func getLikeLabelWidth() -> CGFloat {
        var rightLikeWidth:CGFloat = 0
        if likeCount > 0 {
            if likeCount < 10 {
                rightLikeWidth = rightLikeLabelWidth
            }else if likeCount >= 10 && likeCount < 100 {
                rightLikeWidth = rightLikeLabelWidth * 2
            }else {
                rightLikeWidth = rightLikeLabelWidth * 3
            }
        }
        
        return rightLikeWidth
    }
    
    //MARKS: 重绘框架
    func reDrawLeftView(_leftPadding:CGFloat,cancelPadding:CGFloat,text:String,zanCancelLabelPadding:CGFloat){
        //leftView.frame = CGRectMake(_leftPadding, 0, likeWidth + likeLabelWidth + padding + cancelPadding, self.frame.height)
        
        self.zanLabel.text = text
        self.zanLabel.frame = CGRectMake(likeImageView.frame.origin.x + likeWidth + padding, 0, likeLabelWidth + zanCancelLabelPadding, likeView.frame.height)
        
        self.lineShape.removeFromSuperlayer()
        let lineBeginX:CGFloat = zanLabel.frame.origin.x + likeLabelWidth + labelPadding + cancelPadding
        self.lineShape = WeChatDrawView().drawLine(beginPointX: lineBeginX, beginPointY: likeView.frame.origin.y - 2, endPointX: lineBeginX, endPointY:self.frame.height - topBottomPadding + 2,color:UIColor.lightTextColor())
        leftView.layer.addSublayer(lineShape)
        self.commentView.frame.origin = CGPointMake(lineBeginX + labelPadding, self.commentView.frame.origin.y)
    }
    
    //MARKS: 重绘右边视图
    func reDrawRightView(rightPadding:CGFloat){
        let rightLikeWidth = self.getLikeLabelWidth()
        self.rightView.frame = CGRectMake(self.rightViewBeginX - rightPadding, self.rightView.frame.origin.y, self.rightView.frame.width + rightPadding, self.rightView.frame.height)
        self.isLeftMove = true
        
        if rightLikeWidth > 0 {
            self.rightLikeLabel.frame.size = CGSize(width: rightLikeWidth, height: self.rightLikeLabel.frame.height)
            self.commentImageView.frame =  CGRectMake(self.rightLikeLabel.frame.origin.x + rightLikeWidth + self.padding * 2, self.rightLikeLabel.frame.origin.y, self.commentWidth, self.labelHeight)
            self.rightLikeLabel.text = "\(self.likeCount)"
        } else {
            self.rightLikeLabel.frame.size = CGSize(width: 0, height: self.rightLikeLabel.frame.height)
            self.commentImageView.frame =  CGRectMake(likeImageView.frame.origin.x + likeWidth + padding, self.likeImageView.frame.origin.y, self.commentWidth, self.labelHeight)
            self.rightLikeLabel.text = ""
        }
    }
    
    //MARKS: 赞点击效果
    func likeViewTap(gestrue: WeChatUITapGestureRecognizer){
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.likeImageView.image = UIImage(named: "like-hl")
            self.likeImageView.transform = CGAffineTransformMakeScale(2.2, 2.2)//CGAffineTransformMakeScale两个参数，代表x和y方向缩放倍数。
        }) { (Bool) -> Void in
            self.likeImageView.image = UIImage(named: "like")
            self.likeImageView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            if !self.isLiked {//没有点赞
                let cancelPadding:CGFloat = self.cancelLabelWidth - self.likeLabelWidth
                self.reDrawLeftView(self.labelPadding/2, cancelPadding: cancelPadding, text: "取消", zanCancelLabelPadding: self.cancelLabelWidth - self.likeLabelWidth)
                self.isLiked = true
                self.likeCount++
            } else {
                self.leftView.frame = CGRectMake(self.labelPadding, 0, self.leftWidth, self.frame.height)
                self.reDrawLeftView(self.labelPadding, cancelPadding: 0, text: "赞", zanCancelLabelPadding: 0)
                self.isLiked = false
                self.likeCount--
            }
            
            let rightLikeWidth = self.getLikeLabelWidth()
            if !self.isLeftMove {//向左移动rightLikeWidth + padding的距离
                var rightPadding:CGFloat = 0
                if rightLikeWidth > 0 {
                    rightPadding = rightLikeWidth + self.padding
                }
                
                self.reDrawRightView(rightPadding)
                self.isLeftMove = true
            } else {
                self.reDrawRightView(0)
                self.isLeftMove = false
            }
            
        }
    }
 
    //MARKS: 右侧事件
    func rightTap(gestrue: WeChatUITapGestureRecognizer){
        print("rightTap")
    }
    
    //MARKS: 添加评论
    func addCommentView(){
        self.parentViewController.presentViewController(AddCommentViewController(), animated: true) { () -> Void in
            
        }
    }
}