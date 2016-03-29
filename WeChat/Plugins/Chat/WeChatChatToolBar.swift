//
//  WeChatChatToolBar.swift
//  WeChat
//
//  Created by Smile on 16/3/29.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

extension UIColor {
    public func hexStringToColor(hexString: String) -> UIColor{
        var cString: String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if cString.characters.count < 6 {return UIColor.blackColor()}
        if cString.hasPrefix("0X") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(2))}
        if cString.hasPrefix("#") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))}
        if cString.characters.count != 6 {return UIColor.blackColor()}
        
        var range: NSRange = NSMakeRange(0, 2)
        
        let rString = (cString as NSString).substringWithRange(range)
        range.location = 2
        let gString = (cString as NSString).substringWithRange(range)
        range.location = 4
        let bString = (cString as NSString).substringWithRange(range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        NSScanner.init(string: rString).scanHexInt(&r)
        NSScanner.init(string: gString).scanHexInt(&g)
        NSScanner.init(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
        
    }
}

//聊天窗口询问toolbar
class WeChatChatToolBar: UIView {
    var textView: UITextView!
    var voiceButton: UIButton!
    var emotionButton: UIButton!
    var moreButton: UIButton!
    var recordButton: UIButton!
    
    convenience init(taget: UIViewController, voiceSelector: Selector, recordSelector: Selector, emotionSelector: Selector, moreSelector: Selector) {
        self.init()
        //backgroundColor = UIColor().hexStringToColor("D8EBF2")
        backgroundColor = UIColor.whiteColor()
        
        voiceButton = UIButton(type: .Custom)
        voiceButton.setImage(UIImage(named: "ToolViewInputVoice"), forState: .Normal)
        voiceButton.setImage(UIImage(named: "ToolViewInputVoiceHL"), forState: .Highlighted)
        voiceButton.addTarget(taget, action: voiceSelector, forControlEvents: .TouchUpInside)
        self.addSubview(voiceButton)
        
        textView = InputTextView()
        textView.font = UIFont.systemFontOfSize(17)
        textView.layer.borderColor = UIColor().hexStringToColor("DADADA").CGColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5.0
        textView.scrollsToTop = false
        textView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        //textView.backgroundColor = UIColor().hexStringToColor("f8fefb")
        textView.returnKeyType = .Send
        self.addSubview(textView)
        
        emotionButton = UIButton(type: .Custom)
        emotionButton.tag = 1
        emotionButton.setImage(UIImage(named: "ToolViewEmotion"), forState: .Normal)
        emotionButton.setImage(UIImage(named: "ToolViewEmotionHL"), forState: .Highlighted)
        emotionButton.addTarget(taget, action: emotionSelector, forControlEvents: .TouchUpInside)
        self.addSubview(emotionButton)
        
        moreButton = UIButton(type: .Custom)
        moreButton.tag = 2
        moreButton.setImage(UIImage(named: "TypeSelectorBtn_Black"), forState: .Normal)
        moreButton.setImage(UIImage(named: "TypeSelectorBtnHL_Black"), forState: .Highlighted)
        moreButton.addTarget(taget, action: moreSelector, forControlEvents: .TouchUpInside)
        self.addSubview(moreButton)
        
        recordButton = UIButton(type: .Custom)
        recordButton.setTitle("按住 说话", forState: .Normal)
        recordButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        //recordButton.setBackgroundImage(UIImage.imageWithColor(UIColor().hexStringToColor("F6F6F6")), forState: .Normal)
        recordButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        recordButton.addTarget(taget, action: recordSelector, forControlEvents: .TouchDown)
        recordButton.layer.borderColor = UIColor().hexStringToColor("DADADA").CGColor
        recordButton.layer.cornerRadius = 5.0
        recordButton.layer.masksToBounds = true
        recordButton.hidden = true
        self.addSubview(recordButton)
        
        voiceButton.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        emotionButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: voiceButton, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 5))
        self.addConstraint(NSLayoutConstraint(item: voiceButton, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 5))
        
        self.addConstraint(NSLayoutConstraint(item: textView, attribute: .Left, relatedBy: .Equal, toItem: voiceButton, attribute: .Right, multiplier: 1, constant: 5))
        self.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 5))
        textView.addConstraint(NSLayoutConstraint(item: textView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 35.0))
        self.addConstraint(NSLayoutConstraint(item: textView, attribute: .Right, relatedBy: .Equal, toItem: emotionButton, attribute: .Left, multiplier: 1, constant: -5))
        
        self.addConstraint(NSLayoutConstraint(item: emotionButton, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 5))
        self.addConstraint(NSLayoutConstraint(item: emotionButton, attribute: .Right, relatedBy: .Equal, toItem: moreButton, attribute: .Left, multiplier: 1, constant: -5))
        
        self.addConstraint(NSLayoutConstraint(item: moreButton, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -5))
        self.addConstraint(NSLayoutConstraint(item: moreButton, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 5))
        
        createLineOnTop()
    }
    
    //MARKS: 顶部画线
    func createLineOnTop(){
        let shape = WeChatDrawView().drawLine(beginPointX: 0, beginPointY: 0, endPointX: UIScreen.mainScreen().bounds.width, endPointY: 0,color:UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1))
        shape.lineWidth = 0.2
        self.layer.addSublayer(shape)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    internal func showRecord(show: Bool) {
        if show {
            recordButton.hidden = false
            recordButton.frame = textView.frame
            recordButton.layer.borderWidth = 1
            textView.hidden = true
            recordButton.setTitle("按住 说话", forState: .Normal)
            recordButton.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
            recordButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            voiceButton.setImage(UIImage(named: "ToolViewKeyboard"), forState: .Normal)
            voiceButton.setImage(UIImage(named: "ToolViewKeyboardHL"), forState: .Highlighted)
            
            showEmotion(false)
            showMore(false)
        } else {
            recordButton.hidden = true
            textView.hidden = false
            textView.inputView = nil
            voiceButton.setImage(UIImage(named: "ToolViewInputVoice"), forState: .Normal)
            voiceButton.setImage(UIImage(named: "ToolViewInputVoiceHL"), forState: .Highlighted)
        }
    }
    
    
    internal func showEmotion(show: Bool) {
        if show {
            emotionButton.tag = 0
            emotionButton.setImage(UIImage(named: "ToolViewKeyboard"), forState: .Normal)
            emotionButton.setImage(UIImage(named: "ToolViewKeyboardHL"), forState: .Highlighted)
            
            showRecord(false)
            showMore(false)
        } else {
            emotionButton.tag = 1
            textView.inputView = nil
            emotionButton.setImage(UIImage(named: "ToolViewEmotion"), forState: .Normal)
            emotionButton.setImage(UIImage(named: "ToolViewEmotionHL"), forState: .Highlighted)
        }
    }
    
    internal func showMore(show: Bool) {
        if show {
            moreButton.tag = 3
            
            showRecord(false)
            showEmotion(false)
        } else {
            textView.inputView = nil
            moreButton.tag = 2
        }
    }
    
}


// only show copy action when editing textview

class InputTextView: UITextView {
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if (delegate as! WeChatChatViewController).tableView.indexPathForSelectedRow != nil {
            return action == "copyAction:"
        } else {
            return super.canPerformAction(action, withSender: sender)
        }
    }
    
    func copyAction(menuController: UIMenuController) {
        (delegate as! WeChatChatViewController).copyAction(menuController)
    }
}
