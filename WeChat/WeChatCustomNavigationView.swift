//
//  WeChatCustomNavigationView.swift
//  WeChat
//
//  Created by Smile on 16/1/21.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义导航条
class WeChatCustomNavigationView: UIView {

    //MARKS: Properties
    var count:Int = 0//导航条上label显示数目
    var totalCount:Int = 0//导航条上label显示的总数
    var backImage:UIImage!//左侧返回图片
    var backTitle:String?//左侧返回图片后的文字
    var rightBtn:UIButton!//右侧按钮图标
    var rightBtnText:String?//右侧按钮文字
    var rightBtnImage:UIImage?//右侧按钮图片
    var centerLabelText:String?//中间显示的文字
    
    var label:UILabel?//中间文字
    var isLayedOut:Bool = false
    var bgColor:UIColor?
    
    let leftBackImagePadding:CGFloat = 15//图片左边空白
    let leftBackTitlePadding:CGFloat = 4//文字左边距离图片空白
    var leftWidth:CGFloat = 50
    var rightWidth:CGFloat = 30
    let rightBtnPadding:CGFloat = 15//按钮右侧空白
    var bottomPadding:CGFloat = 15//距离底部空白
    var topPadding:CGFloat = 5
    var leftOrRightHeight:CGFloat = 25
    var backImageWidth:CGFloat = 15
    var backImageHeight:CGFloat = 15
    var centerLabelWidth:CGFloat = 100
    var rightBtnTextHeight:CGFloat = 0
    var statusFrame:CGRect!
    var navigationController:UINavigationController!
    
    let fontName:String = "Arial-BoldMT"
    
    init(frame: CGRect,photoCount count:Int,photoTotalCount totalCount:Int,backImage:UIImage?,backTitle:String?,
        centerLabel centerLabelText:String?,rightButtonText rightBtnText:String?,rightButtonImage rightBtnImage:UIImage?,backgroundColor bgColor:UIColor?,navigationController:UINavigationController) {
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
            self.backgroundColor = UIColor.darkGrayColor()
        }
           
        self.navigationController = navigationController
        rightBtnTextHeight = self.leftOrRightHeight / 2
        self.statusFrame = UIApplication.sharedApplication().statusBarFrame
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayedOut {
            createControl()
        }
    }
    
    //MARKS: 创建组件
    func createControl(){
        //添加左侧图片
        var leftBackImageView:UIImageView?
        if self.backImage != nil {
            leftBackImageView = UIImageView(frame: CGRectMake(self.leftBackImagePadding, self.bounds.height - self.bottomPadding - self.backImageHeight, backImageWidth, backImageHeight))
            leftBackImageView!.image = self.backImage!
            leftBackImageView?.userInteractionEnabled = true
            leftBackImageView?.addGestureRecognizer(WeChatUITapGestureRecognizer(target: self, action: "leftTap:"))
            self.addSubview(leftBackImageView!)
        }
        
        //添加左侧文字
        var backLabel:UILabel?
        if self.backTitle != nil {
            if leftBackImageView != nil {
                backLabel = UILabel(frame: CGRectMake(leftBackImageView!.frame.origin.x + backImageWidth + leftBackTitlePadding, leftBackImageView!.frame.origin.y, leftWidth - leftBackImageView!.frame.width, backImageHeight))
            }else{
                backLabel = UILabel(frame: CGRectMake(self.leftBackImagePadding, self.bounds.height - self.bottomPadding - self.leftOrRightHeight, leftWidth, leftOrRightHeight))
            }
            
            backLabel?.textColor = UIColor.whiteColor()
            backLabel?.text = self.backTitle
            backLabel?.font = UIFont(name: self.fontName, size: 14)
            backLabel?.userInteractionEnabled = true
            backLabel?.addGestureRecognizer(WeChatUITapGestureRecognizer(target: self, action: "leftTap:"))
            self.addSubview(backLabel!)
        }
        
        //添加右侧按钮
        var rightBtn:UIButton?
        if rightBtnText != nil || rightBtnImage != nil {
            rightBtn = UIButton(frame: CGRectMake(self.bounds.width - rightBtnPadding - rightWidth, self.bounds.height - self.bottomPadding - rightBtnTextHeight, rightWidth, rightBtnTextHeight))
            if rightBtnText != nil {
                rightBtn?.setTitle(self.rightBtnText, forState: .Normal)
                rightBtn?.titleLabel?.font = UIFont(name: self.fontName, size: 10)
                rightBtn?.titleLabel!.tintColor = UIColor.whiteColor()
                rightBtn?.titleLabel?.textAlignment = .Center
            }
            
            if rightBtnImage != nil {
                rightBtn?.setImage(self.rightBtnImage, forState: .Normal)
            }
            
            rightBtn?.addGestureRecognizer(WeChatUITapGestureRecognizer(target: self, action: "rightTap:"))
            self.addSubview(rightBtn!)
        }
        
        //添加中间文字
        var centerLabel:UILabel?
        if self.centerLabelText != nil {
            let centerLabelX:CGFloat = (self.bounds.width - centerLabelWidth)/2
            
            if count >= 1 && totalCount > 1 && !self.centerLabelText!.containsString("\n") {
                centerLabel = UILabel(frame: CGRectMake(centerLabelX, statusFrame.height + topPadding, centerLabelWidth, self.bounds.height - self.bottomPadding - statusFrame.height))
                var labelText = self.centerLabelText!
                labelText += "\n"
                labelText += "\(count)/\(totalCount)"
                centerLabel?.text = labelText
                centerLabel?.font = UIFont(name: self.fontName, size: 12)
                centerLabel?.numberOfLines = 0//允许换行
            }else{
               if self.centerLabelText!.containsString("\n") {
                    centerLabel = UILabel(frame: CGRectMake(centerLabelX, statusFrame.height + topPadding, centerLabelWidth, self.bounds.height - self.bottomPadding - statusFrame.height))
                    centerLabel?.font = UIFont(name: self.fontName, size: 12)
                    centerLabel?.numberOfLines = 0//允许换行
               }else{
                    var begintY:CGFloat = 0
                    if leftBackImageView != nil {
                        begintY = leftBackImageView!.frame.origin.x + leftBackImageView!.frame.height
                    }else{
                        if backLabel != nil {
                            begintY = backLabel!.frame.origin.x + backLabel!.frame.height
                        }else{
                            begintY = statusFrame.height + topPadding
                        }
                    }
                    centerLabel = UILabel(frame: CGRectMake(centerLabelX, begintY, centerLabelWidth, self.bounds.height - self.bottomPadding - statusFrame.height))
                    centerLabel?.font = UIFont(name: self.fontName, size: 14)
               }
                
                centerLabel?.text = self.centerLabelText
            }
            
            centerLabel?.textAlignment = .Center
            centerLabel?.textColor = UIColor.whiteColor()
            self.addSubview(centerLabel!)
        }
    }
    
    //MARKS: 左侧事件
    func leftTap(gestrue: WeChatUITapGestureRecognizer){
        navigationController.popViewControllerAnimated(true)
    }
    
    //MARKS: 右侧事件
    func rightTap(gestrue: WeChatUITapGestureRecognizer){
        print("right")
    }
}
