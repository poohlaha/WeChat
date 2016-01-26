//
//  WeChatCustomNavigationView.swift
//  WeChat
//
//  Created by Smile on 16/1/21.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

protocol WeChatCustomNavigationHeaderDelegate{
    func leftBarClick()//左侧事件
    func rightBarClick()//右侧事件
}

//自定义导航条头部
class WeChatCustomNavigationHeaderView: UIView {

    //MARKS: Properties
    var count:Int = 0//导航条上label显示数目
    var totalCount:Int = 0//导航条上label显示的总数
    var backImage:UIImage?//左侧返回图片
    var backTitle:String?//左侧返回图片后的文字
    var rightBtn:UIButton!//右侧按钮图标
    var rightBtnText:String?//右侧按钮文字
    var rightBtnImage:UIImage?//右侧按钮图片
    var centerLabelText:String?//中间显示的文字
    
    var label:UILabel?//中间文字
    var isLayedOut:Bool = false
    var bgColor:UIColor?
    
    let leftOrRightPadding:CGFloat = 7//图片左边空白
    var rightWidth:CGFloat = 30
    var bottomPadding:CGFloat = 5//距离底部空白
    var topPadding:CGFloat = 5
    var rightBtnTextHeight:CGFloat = 0
    var statusFrame:CGRect!
    var leftWidth:CGFloat = 70
    
    var centerLabel:UILabel?
    let fontName:String = "Arial"
    var leftLabelColor:UIColor?
    var rightLabelColor:UIColor?
    
    var delegate:WeChatCustomNavigationHeaderDelegate!
    
    init(frame: CGRect,photoCount count:Int,photoTotalCount totalCount:Int,backImage:UIImage?,backTitle:String?,
        centerLabel centerLabelText:String?,rightButtonText rightBtnText:String?,rightButtonImage rightBtnImage:UIImage?,backgroundColor bgColor:UIColor?) {
        super.init(frame: frame)
            
        //init properties
        self.count = count
        self.totalCount = totalCount
        if backImage != nil {
            self.backImage = backImage
        }
            
        if backTitle != nil {
            self.backTitle = backTitle
        }
            
        if centerLabelText != nil {
            self.centerLabelText = centerLabelText
        }
            
        if rightBtnText != nil {
            self.rightBtnText = rightBtnText
        }
            
        if rightBtnImage != nil {
            self.rightBtnImage = rightBtnImage
        }
            
        if bgColor != nil {
            self.bgColor = bgColor
            self.backgroundColor = self.bgColor
        }else{
            self.backgroundColor = UIColor.blackColor()
        }
        
        self.statusFrame = UIApplication.sharedApplication().statusBarFrame
    }
    
    init(frame: CGRect,backImage:UIImage?,backTitle:String?,
        centerLabel centerLabelText:String?,rightButtonText rightBtnText:String?,
        rightButtonImage rightBtnImage:UIImage?,backgroundColor bgColor:UIColor?,leftLabelColor:UIColor?,rightLabelColor:UIColor?) {
            super.init(frame: frame)
            if backImage != nil {
                self.backImage = backImage
            }
            
            if backTitle != nil {
                self.backTitle = backTitle
            }
            
            if centerLabelText != nil {
                self.centerLabelText = centerLabelText
            }
            
            if rightBtnText != nil {
                self.rightBtnText = rightBtnText
            }
            
            if rightBtnImage != nil {
                self.rightBtnImage = rightBtnImage
            }
            
            if bgColor != nil {
                self.bgColor = bgColor
                self.backgroundColor = self.bgColor
            }else{
                self.backgroundColor = UIColor.blackColor()
            }
            
            if leftLabelColor != nil {
                self.leftLabelColor = leftLabelColor
            }
            
            if rightLabelColor != nil {
                self.rightLabelColor = rightLabelColor
            }
            
            self.statusFrame = UIApplication.sharedApplication().statusBarFrame
    }


    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayedOut {
            createControl()
            isLayedOut = true
        }
    }
    
    //MARKS: 创建组件
    func createControl(){
        //添加左侧View
        let centerHeight = self.bounds.height - bottomPadding - statusFrame.height - topPadding
        let beginY = statusFrame.height + topPadding
        let leftView = LeftView(frame: CGRectMake(self.leftOrRightPadding,beginY,leftWidth,centerHeight), labelText: self.backTitle, backImage: self.backImage,leftLabelColor:self.leftLabelColor)
        leftView.addGestureRecognizer(WeChatUITapGestureRecognizer(target: self, action: "leftTap:"))
        self.addSubview(leftView)
        
        //添加右侧按钮
        var rightBtn:UIButton?
        if rightBtnText != nil || rightBtnImage != nil {
            if rightBtnText != nil {
                if self.rightBtnText == "● ● ●"{
                    rightBtn = UIButton(frame: CGRectMake(self.bounds.width - leftOrRightPadding - rightWidth, beginY, rightWidth, centerHeight))
                    rightBtn?.titleLabel?.font = UIFont(name: self.fontName, size: 10)
                } else {
                    rightBtn = UIButton(frame: CGRectMake(self.bounds.width - leftOrRightPadding - rightWidth - 10, beginY, rightWidth + 10, centerHeight))
                    rightBtn?.titleLabel?.font = UIFont(name: self.fontName, size: 16)
                }
                
                if self.rightLabelColor != nil {
                    rightBtn?.setTitleColor(self.rightLabelColor, forState: .Normal)
                }else{
                    rightBtn?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                }
                
                rightBtn?.setTitle(self.rightBtnText, forState: .Normal)
                rightBtn?.titleLabel?.textAlignment = .Center
            }
            
            if rightBtnImage != nil {
                rightBtn?.setImage(self.rightBtnImage, forState: .Normal)
            }
            
            rightBtn?.addGestureRecognizer(WeChatUITapGestureRecognizer(target: self, action: "rightTap:"))
            self.addSubview(rightBtn!)
        }
        
        //添加中间文字
        if self.centerLabelText != nil {
            let centerLabelWidth = UIScreen.mainScreen().bounds.width - self.leftOrRightPadding * 2 - leftView.bounds.width - rightWidth
            let centerLabelX:CGFloat = leftView.frame.width
            
            if count >= 1 && totalCount > 1 && !self.centerLabelText!.containsString("\n") {
                centerLabel = UILabel(frame: CGRectMake(centerLabelX, statusFrame.height + topPadding, centerLabelWidth, self.bounds.height - self.bottomPadding - statusFrame.height))
                var labelText = self.centerLabelText!
                labelText += "\n"
                labelText += "\(count)/\(totalCount)"
                centerLabel?.text = labelText
                centerLabel?.font = UIFont(name: "Arial-BoldMT", size: 16)
                centerLabel?.numberOfLines = 0//允许换行
            }else{
               if self.centerLabelText!.containsString("\n") {
                    centerLabel = UILabel(frame: CGRectMake(centerLabelX, statusFrame.height + topPadding, centerLabelWidth, self.bounds.height - self.bottomPadding - statusFrame.height))
                    centerLabel?.font = UIFont(name: "Arial-BoldMT", size: 16)
                    centerLabel?.numberOfLines = 0//允许换行
               }else{
                    centerLabel = UILabel(frame: CGRectMake(centerLabelX, beginY, centerLabelWidth, self.bounds.height - self.bottomPadding - statusFrame.height))
                    centerLabel?.font = UIFont(name: "Arial-BoldMT", size: 18)
               }
                
                centerLabel?.text = self.centerLabelText
            }
            
            centerLabel?.textAlignment = .Center
            centerLabel?.textColor = UIColor.whiteColor()
            self.addSubview(centerLabel!)
        }
    }
    
    //MARKS: 重新给导航条标题设值
    func resetTitle(currentCount:Int){
        if self.centerLabelText!.containsString("\n") {
            let strs:[String] = self.centerLabelText!.componentsSeparatedByString("\n")
            let str = strs[0] + "\n\(currentCount)/\(self.totalCount)"
            self.centerLabel!.text = str
            updateConstraints()
        }
    }
    
    //MARKS: 左侧事件
    func leftTap(gestrue: WeChatUITapGestureRecognizer){
        delegate.leftBarClick()
    }
    
    //MARKS: 右侧事件
    func rightTap(gestrue: WeChatUITapGestureRecognizer){
        delegate.rightBarClick()
    }
}

//左侧视图
class LeftView:UIView {
    
    var labelText:String?
    var backImage:UIImage?
    var isLayedOut:Bool = false
    var backImageWidth:CGFloat = 18
    let leftBackTitlePadding:CGFloat = 4//文字左边距离图片空白
    let fontName:String = "Arial"
    var leftLabelColor:UIColor?
    
    init(frame: CGRect,labelText:String?,backImage:UIImage?,leftLabelColor:UIColor?) {
        super.init(frame: frame)
        if labelText != nil {
            if !labelText!.isEmpty {
                self.labelText = labelText
            }
        }
        
        if backImage != nil {
            self.backImage = backImage
        }
        
        if leftLabelColor != nil {
            self.leftLabelColor = leftLabelColor
        }
        
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayedOut {
            createView()
            isLayedOut = true
        }
    }
    
    func createView(){
        var leftBackImageView:UIImageView?
        if self.backImage != nil {
            leftBackImageView = UIImageView(frame: CGRectMake(0, 0, backImageWidth, self.frame.height))
            leftBackImageView!.image = self.backImage!
            self.addSubview(leftBackImageView!)
        }
        
        //添加左侧文字
        var backLabel:UILabel?
        if self.labelText != nil {
            if leftBackImageView != nil {
                backLabel = UILabel(frame: CGRectMake(leftBackImageView!.frame.origin.x + backImageWidth, leftBackImageView!.frame.origin.y, self.frame.width - backImageWidth, self.frame.height))
                backLabel?.font = UIFont(name: self.fontName, size: 16)
            }else{
                backLabel = UILabel()
                backLabel?.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
                backLabel?.font = UIFont(name: self.fontName, size: 16)
            }
            
            if self.leftLabelColor != nil {
                backLabel?.textColor = self.leftLabelColor
            }else{
                backLabel?.textColor = UIColor.whiteColor()
            }
            
            backLabel?.text = self.labelText
            
            self.addSubview(backLabel!)
        }

    }
}
