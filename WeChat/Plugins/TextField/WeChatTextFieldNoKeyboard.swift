//
//  WeChatTextFieldNoKeyboard.swift
//  WeChat
//
//  Created by Smile on 16/3/24.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义TextView,去掉键盘
class WeChatTextFieldNoKeyboard: UITextField,UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WeChatTextFieldNoKeyboard.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WeChatTextFieldNoKeyboard.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        return true
    }
    
    //MARKS: 键盘即将升起
    func keyboardWillShow(notification: NSNotification){
        //let keyboardInfo = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        //let keyboardHeight:CGFloat = (keyboardInfo?.CGRectValue.size.height)!

    }
}
