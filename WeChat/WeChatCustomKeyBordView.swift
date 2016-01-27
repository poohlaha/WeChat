//
//  WeChatCustomKeyBord.swift
//  WeChat
//
//  Created by Smile on 16/1/27.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义聊天键盘
class WeChatCustomKeyBordView: UIView,UITextViewDelegate {

    var bgColor:UIColor!
    var isLayedOut:Bool = false
    
    var textView:PlaceholderTextView!//多行输入
    let topOrBottomPadding:CGFloat = 7//上边空白
    let leftPadding:CGFloat = 10//左边空白
    let kAnimationDuration:NSTimeInterval = 0.2//动画时间
    
    init(frame: CGRect,bgColor:UIColor?) {
        super.init(frame: frame)
        if bgColor != nil {
            self.bgColor = bgColor!
        }
        
        //定义通知,获取键盘高度
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARKS: 键盘弹起事件
    func keyboardWillAppear(notification: NSNotification) {
        let keyboardInfo = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        let keyboardHeight:CGFloat = (keyboardInfo?.CGRectValue.size.height)!
        /*let keyboardBeginInfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
        let beginY:CGFloat = (keyboardBeginInfo?.CGRectValue.origin.y)!
        
        let keyboardEndInfo = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        let endY:CGFloat = (keyboardEndInfo?.CGRectValue.origin.y)!
        
        let keyboardHeight = endY - beginY*/
        
        animation(self.frame.origin.x, y: self.frame.height + keyboardHeight)
    }
    
    //MARKS: 键盘落下事件
    func keyboardWillDisappear(notification:NSNotification){
        animation(self.frame.origin.x, y: UIScreen.mainScreen().bounds.height - self.frame.height)
    }
    
    //MARKS: 导航行返回
    func navigationBackClick(){
        self.frame.origin = CGPointMake(self.frame.origin.x,UIScreen.mainScreen().bounds.height - self.frame.height)
        self.textView.resignFirstResponder()
    }
    
    //MARKS: TextView动画
    func animation(x:CGFloat,y:CGFloat){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(kAnimationDuration)
        self.frame.origin = CGPointMake(x, y)
        UIView.commitAnimations()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayedOut {
            self.backgroundColor = UIColor.greenColor()
            createLineOnTop()
            createTextView()
            self.textView.resignFirstResponder()
            self.isLayedOut = true
        }
    }
    
    //MARKS: 创建输入框
    func createTextView(){
        let frame = CGRectMake(leftPadding, topOrBottomPadding, UIScreen.mainScreen().bounds.width - leftPadding * 2, self.frame.height - topOrBottomPadding * 2)
        self.textView = PlaceholderTextView(frame: frame,placeholder: "评论",color: nil,font: nil)
        self.textView.layer.borderWidth = 0.5  //边框粗细
        self.textView.layer.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).CGColor //边框颜色
        self.textView.editable = true//是否可编辑
        self.textView.selectable = true//是否可选
        self.textView.dataDetectorTypes = .None//给文字中的电话号码和网址自动加链接,这里不需要添加
        self.textView.returnKeyType = .Send
        self.textView.font = UIFont(name: "AlNile", size: 12)
        //设置圆角
        self.textView.layer.cornerRadius = 4
        self.textView.layer.masksToBounds = true
        self.textView.delegate = self
        self.addSubview(textView)
    }
    
    //MARKS: 顶部画线
    func createLineOnTop(){
        let shape = WeChatDrawView().drawLine(beginPointX: 0, beginPointY: 0, endPointX: self.frame.width, endPointY: 0,color:UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1))
        shape.lineWidth = 0.2
        self.layer.addSublayer(shape)
    }
    
    //MARKS: 自定义选择内容后的菜单
    func addSelectCustomMenu(){
        
    }
    
    /*
    func textViewDidChange(textView: UITextView) {
        let line = textView.caretRectForPosition(textView.selectedTextRange!.start)
        let overflow = line.origin.y + line.size.height
            - ( textView.contentOffset.y + textView.bounds.size.height
                - textView.contentInset.bottom - textView.contentInset.top )
        if ( overflow > 0 ) {
            var offset = textView.contentOffset
            offset.y += overflow + 7; // leave 7 pixels margin
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                textView.setContentOffset(offset, animated: true)
            })
        }
    }*/
    
    //MARSK: 去掉回车
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    //触摸空白处隐藏键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.textView.resignFirstResponder()
    }
    
    
    func textViewDidChange(textView: UITextView) {
        if textView.text.isEmpty {
            //self.textView.resetCur(textView.caretRectForPosition(textView.selectedTextRange!.start))
            self.textView.removeFromSuperview()
            createTextView()
            self.textView.becomeFirstResponder()
        }
    }
}

//自定义TextView Placeholder类
class PlaceholderTextView:UITextView {
    
    var placeholder:String?
    var color:UIColor?
    var fontSize:CGFloat = 14
    
    var placeholderLabel:UILabel?
    var placeholderFont:UIFont?
    var isLayedOut:Bool = false
    
    init(frame:CGRect,placeholder:String?,color:UIColor?,font:UIFont?){
        super.init(frame: frame, textContainer: nil)
        
        if placeholder != nil {
            self.placeholder = placeholder
        }
        
        if color != nil {
            self.color = color
        } else {
            self.color = UIColor.lightGrayColor()
        }
        
        if font != nil {
            self.font = font
        } else {
            self.font = UIFont.systemFontOfSize(fontSize)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initFrame(){
        self.backgroundColor = UIColor.clearColor()
        self.placeholderLabel = UILabel()
        placeholderLabel!.backgroundColor = UIColor.clearColor()
        placeholderLabel!.numberOfLines = 0//多行
        placeholderLabel?.text = self.placeholder
        placeholderLabel?.font = self.font
        placeholderLabel?.textColor = self.color
        self.addSubview(placeholderLabel!)
        
        //监听文字变化
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"textDidChange", name: UITextViewTextDidChangeNotification , object: self)
    }
    
    //MARKS: 文字变化
    func textDidChange(){
        self.placeholderLabel!.hidden = self.hasText()//如果UITextView输入了文字,hasText就是YES,反之就为NO
    }
    
    let labelLeftPadding:CGFloat = 7
    var labelTopPadding:CGFloat = 5
    
    override func layoutSubviews() {
       super.layoutSubviews()
        if !isLayedOut {
            if self.placeholder == nil || self.placeholder!.isEmpty {
                return
            }
            
            initFrame()
            //根据字体的高度,计算上下空白
            var labelHeight:CGFloat = 0
            let labelWidth:CGFloat = self.frame.width - labelLeftPadding * 2
            let maxSize = CGSizeMake(labelWidth,CGFloat(MAXFLOAT))
            
            let options : NSStringDrawingOptions = [.UsesLineFragmentOrigin,.UsesFontLeading]
            labelHeight = self.placeholder!.boundingRectWithSize(maxSize, options: options, attributes: [NSFontAttributeName:self.font!], context: nil).size.height
            
            self.labelTopPadding = (self.frame.height - labelHeight) / 2
            
            self.placeholderLabel!.frame = CGRectMake(labelLeftPadding, labelTopPadding,labelWidth , labelHeight)
            isLayedOut = true
        }
    }
    
    let curTopPadding:CGFloat = 3
    
    //MARKS: 设置光标
    override func caretRectForPosition(position: UITextPosition) -> CGRect {
        let originalRect = super.caretRectForPosition(position)
        return resetCur(originalRect)
    }
    
    //MARKS: 重置光标
    func resetCur(originalRect:CGRect) -> CGRect{
        let rect = originalRect
        let curHeight:CGFloat = self.frame.height - curTopPadding * 2
        return CGRectMake(rect.origin.x, curTopPadding, rect.width, curHeight)
    }
}
