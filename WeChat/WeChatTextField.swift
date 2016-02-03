//
//  WeChatTextField.swift
//  WeChat
//
//  Created by Smile on 16/2/3.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义textField
class WeChatTextField:UITextField {
    
    var palceholderLeftPadding:CGFloat = 0
    var textFont:UIFont!
    var defaultFontName:String = "AlNile"
    var defaultFontSize:CGFloat = 14
    var textHeight:CGFloat = 0
    var beginY:CGFloat = 0
    var topPadding:CGFloat = 0
    let curTopPadding:CGFloat = 3
    
    init(frame: CGRect,palceholderLeftPadding:CGFloat?,font:UIFont?,topPadding:CGFloat) {
        super.init(frame: frame)
        
        if palceholderLeftPadding != nil {
            self.palceholderLeftPadding = palceholderLeftPadding!
        }
        
        if font != nil {
            self.font = font
        } else {
            self.font = UIFont(name: self.defaultFontName, size: self.defaultFontSize)
        }
        
        self.topPadding = topPadding
        self.textHeight = getTextViewTextBoundingHeight("我")
        
        beginY = (self.frame.height - self.textHeight) / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARKS: 获取文字高度
    func getTextViewTextBoundingHeight(text:String) -> CGFloat{
        let contentSize = CGSizeMake(self.frame.width,0)
        let options : NSStringDrawingOptions = [.UsesLineFragmentOrigin,.UsesFontLeading]
        let labelHeight = text.boundingRectWithSize(contentSize, options: options, attributes: [NSFontAttributeName:self.font!], context: nil).size.height
        return labelHeight
    }
    
    //MARKS: 改变绘文字属性
    override func drawTextInRect(rect: CGRect) {
    }
    
    //MARKS: 重置占位符区域
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(bounds.origin.x + palceholderLeftPadding, beginY - curTopPadding / 2, bounds.size.width, self.textHeight + curTopPadding)
    }
    
    //MARKS: 重置文字区域
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return super.textRectForBounds(bounds)
    }
    
    //MARKS: 重置边缘区域
    override func borderRectForBounds(bounds: CGRect) -> CGRect {
        return super.borderRectForBounds(bounds)
    }
    
    //MARKS: 重置编辑区域,设置文字位置
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectMake(bounds.origin.x, beginY - curTopPadding / 2, bounds.size.width, self.textHeight)
    }
    
    //MARKS: 重置clearButton位置,改变size可能导致button的图片失真
    override func clearButtonRectForBounds(bounds: CGRect) -> CGRect {
        return super.clearButtonRectForBounds(bounds)
    }
    
    
}
