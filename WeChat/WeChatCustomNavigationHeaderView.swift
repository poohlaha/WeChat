//
//  WeChatCustomNavigationView.swift
//  WeChat
//
//  Created by Smile on 16/1/21.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义导航条头部
class WeChatCustomNavigationHeaderView: UIView {

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
    
    let leftOrRightPadding:CGFloat = 7//图片左边空白
    var rightWidth:CGFloat = 30
    var bottomPadding:CGFloat = 5//距离底部空白
    var topPadding:CGFloat = 5
    var rightBtnTextHeight:CGFloat = 0
    var statusFrame:CGRect!
    var navigationController:UINavigationController!
    var leftWidth:CGFloat = 70
    
    let fontName:String = "Arial"
    
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
            self.backgroundColor = UIColor.blackColor()
        }
           
        self.navigationController = navigationController
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
        let leftView = LeftView(frame: CGRectMake(self.leftOrRightPadding,beginY,leftWidth,centerHeight), labelText: self.backTitle, backImage: self.backImage)
        leftView.addGestureRecognizer(WeChatUITapGestureRecognizer(target: self, action: "leftTap:"))
        self.addSubview(leftView)
        
        //添加右侧按钮
        var rightBtn:UIButton?
        if rightBtnText != nil || rightBtnImage != nil {
            rightBtn = UIButton(frame: CGRectMake(self.bounds.width - leftOrRightPadding - rightWidth, beginY, rightWidth, centerHeight))
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
            let centerLabelWidth = UIScreen.mainScreen().bounds.width - self.leftOrRightPadding * 2 - leftView.bounds.width - rightWidth
            let centerLabelX:CGFloat = leftView.frame.width
            
            if count >= 1 && totalCount > 1 && !self.centerLabelText!.containsString("\n") {
                centerLabel = UILabel(frame: CGRectMake(centerLabelX, statusFrame.height + topPadding, centerLabelWidth, self.bounds.height - self.bottomPadding - statusFrame.height))
                var labelText = self.centerLabelText!
                labelText += "\n"
                labelText += "\(count)/\(totalCount)"
                centerLabel?.text = labelText
                centerLabel?.font = UIFont(name: self.fontName, size: 14)
                centerLabel?.numberOfLines = 0//允许换行
            }else{
               if self.centerLabelText!.containsString("\n") {
                    centerLabel = UILabel(frame: CGRectMake(centerLabelX, statusFrame.height + topPadding, centerLabelWidth, self.bounds.height - self.bottomPadding - statusFrame.height))
                    centerLabel?.font = UIFont(name: self.fontName, size: 14)
                    centerLabel?.numberOfLines = 0//允许换行
               }else{
                    centerLabel = UILabel(frame: CGRectMake(centerLabelX, beginY, centerLabelWidth, self.bounds.height - self.bottomPadding - statusFrame.height))
                    centerLabel?.font = UIFont(name: self.fontName, size: 16)
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
        self.navigationController.popViewControllerAnimated(true)
        //显示隐藏的导航条
        //self.navigationController?.navigationBar.hidden = false
    }
    
    //MARKS: 右侧事件
    func rightTap(gestrue: WeChatUITapGestureRecognizer){
        print("right")
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
    
    init(frame: CGRect,labelText:String?,backImage:UIImage?) {
        super.init(frame: frame)
        if labelText != nil {
            if !labelText!.isEmpty {
                self.labelText = labelText
            }
        }
        
        if backImage != nil {
            self.backImage = backImage
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
            }else{
                backLabel = UILabel(frame: self.frame)
            }
            
            backLabel?.textColor = UIColor.whiteColor()
            backLabel?.text = self.labelText
            backLabel?.font = UIFont(name: self.fontName, size: 18)
            self.addSubview(backLabel!)
        }

    }
}
