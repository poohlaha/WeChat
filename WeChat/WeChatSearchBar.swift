//
//  WeChatSearchBar.swift
//  WeChat
//
//  Created by Smile on 16/2/2.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

@objc protocol WeChatSearchBarDelegate {
    optional func cancelClick()
    optional func textFieldChange()
}

//自定义SearchBar
class WeChatSearchBar: UIView {
    
    var cancelBtn:UIButton?//取消按钮
    var cancelText:String?
    var textSearchView:TextSearchView!
    var placeholder:String?//placeholder
    var cancelBtnColor:UIColor?
    
    let leftPadding:CGFloat = 7
    let topOrBottomPadding:CGFloat = 5
    let textFieldRightPadding:CGFloat = 25//当没有取消按钮时的padding
    let cancelBtnWidth:CGFloat = 45//取消按钮width
    let cancelBtnHeight:CGFloat = 20
    let cancelTextFontName:String = "AlNile"
    let cancelTextFontSize:CGFloat = 18
    var delegate:WeChatSearchBarDelegate? = nil
    var searchLabelView:WeChatSearchLabelView!
    var statusHeight:CGFloat = 0
    var searchView:UIView!
    
    //MARKS: Init
    init(frame:CGRect,placeholder:String?,cancelBtnText:String?,cancelBtnColor:UIColor?){
        super.init(frame: frame)
        
        if placeholder != nil && !placeholder!.isEmpty {
            self.placeholder = placeholder
        }
        
        if cancelBtnText != nil && !cancelBtnText!.isEmpty {
            self.cancelText = cancelBtnText
        }

        if cancelBtnColor != nil {
            self.cancelBtnColor = cancelBtnColor
        } else {
            self.cancelBtnColor = UIColor.blueColor()//默认蓝色
        }
        
        let statusBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.statusHeight = statusBarFrame.height
        initFrame()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func initFrame(){
        createTextSearchView()
        createSearchButton()
        //self.backgroundColor = UIColor(patternImage: UIImage(named: "searchBar-bg")!)
        self.backgroundColor = UIColor(red: 238/255, green: 240/255, blue: 242/255, alpha: 1)
    }
    
    //MARKS: 创建textSearchView
    func createTextSearchView(){
        var textFieldWidth:CGFloat = 0
        var textFieldHeight:CGFloat = 0
        if self.cancelText != nil {//有取消按钮
            textFieldWidth = self.frame.width - leftPadding * 3 - cancelBtnWidth
            textFieldHeight = self.frame.height - topOrBottomPadding * 2
        } else {//没有取消按钮
            textFieldWidth = self.frame.width - leftPadding - textFieldRightPadding
            textFieldHeight = self.frame.height - topOrBottomPadding * 2
        }
        textSearchView = TextSearchView(frame: CGRectMake(leftPadding, topOrBottomPadding + self.statusHeight, textFieldWidth, textFieldHeight - statusHeight), placeholder: self.placeholder, cancelText: self.cancelText)
        
        self.addSubview(textSearchView)
    }
    
    //MARKS: 设置遮罩层
    func createTextSearchLabelView(statusHeight:CGFloat) -> WeChatSearchLabelView{
        self.textSearchView.textField.resignFirstResponder()
        searchLabelView = WeChatSearchLabelView(frame: CGRectMake(leftPadding, statusHeight + topOrBottomPadding, self.frame.width - leftPadding * 2, self.frame.height - topOrBottomPadding * 2), textSearchView: self.textSearchView)
        return searchLabelView
    }
    
    func createSearchView(frame:CGRect,bgColor:UIColor?) -> UIView{
        self.textSearchView.textField.resignFirstResponder()
        self.searchView = UIView()
        self.searchView.frame = frame
        
        if bgColor != nil {
            self.searchView.backgroundColor = bgColor
        }
        
        searchLabelView = WeChatSearchLabelView(frame: CGRectMake(leftPadding, topOrBottomPadding, self.frame.width - leftPadding * 2, self.frame.height - topOrBottomPadding * 2), textSearchView: self.textSearchView)
        searchView.addSubview(searchLabelView)
        return searchView
    }
    
    //MARKS: 创建searchButton
    func createSearchButton(){
        if self.cancelText == nil {
            return
        }
        
        let beginX:CGFloat = self.textSearchView.frame.origin.x + self.textSearchView.frame.width + leftPadding
        let beginY:CGFloat = (self.frame.height - self.cancelBtnHeight + statusHeight) / 2
        self.cancelBtn = UIButton()
        self.cancelBtn?.frame = CGRectMake(beginX, beginY, cancelBtnWidth, self.textSearchView.frame.height)
        self.cancelBtn?.setTitle(self.cancelText, forState: .Normal)
        self.cancelBtn?.setTitleColor(cancelBtnColor, forState: .Normal)
        self.cancelBtn?.titleLabel?.font = UIFont(name: self.cancelTextFontName, size: self.cancelTextFontSize)
        self.addSubview(self.cancelBtn!)
        
        self.cancelBtn?.addTarget(self, action: "cancelClick", forControlEvents: .TouchDown)
    }
    
    func cancelClick(){
        delegate!.cancelClick!()
    }
    
}

//文本输入框,包含searchImageView,speakImageView,textField
class TextSearchView:UIView,UITextFieldDelegate {
    
    var textField:UITextField!//输入框
    var searchImageView:UIImageView!//搜索
    var speakImageView:UIImageView!
    var placeholder:String?//placeholder
    var cancelText:String?

    let leftOrRightPadding:CGFloat = 7
    let searchImageWidth:CGFloat = 15
    let speakImageWidth:CGFloat = 25
    var textFieldHeight:CGFloat = 0
    let textFieldTopOrBottomPadding:CGFloat = 3
    var delegate:WeChatSearchBarDelegate?
    
    var isLayedOut:Bool = false
    
    init(frame:CGRect,placeholder:String?,cancelText:String?){
        super.init(frame: frame)
        
        if placeholder != nil && !placeholder!.isEmpty {
            self.placeholder = placeholder
        }
        
        if cancelText != nil && !cancelText!.isEmpty {
            self.cancelText = cancelText
        }
        
        initFrame()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initFrame(){
        setLayout()
        
        createSearchImageView()
        createTextField()
        createSpeakImageView()
    }
    
    //MARKS: 设置圆角等属性
    func setLayout(){
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 6
        self.layer.borderColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).CGColor
        self.backgroundColor = UIColor.whiteColor()
    }
    
    //MARKS: 创建textField
    func createTextField(){
        var textFieldWidth:CGFloat = 0
        textFieldHeight = self.frame.height - textFieldTopOrBottomPadding * 2
        
        var beginX:CGFloat = 0
        var beginY:CGFloat = 0
        if self.cancelText != nil {//有取消按钮
            beginX = self.leftOrRightPadding * 2 + searchImageWidth
            beginY = self.textFieldTopOrBottomPadding
            textFieldWidth = self.frame.width - leftOrRightPadding * 4 - searchImageWidth - speakImageWidth
        } else {//没有取消按钮
            textFieldWidth = self.frame.width - leftOrRightPadding * 2 - speakImageWidth
        }
        
        textField = WeChatTextField(frame: CGRectMake(beginX, beginY, textFieldWidth, textFieldHeight), palceholderLeftPadding: 0, font: nil,topPadding: textFieldTopOrBottomPadding)
        textField.tintColor = UIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1)//设置光标颜色
        //textField.textAlignment = .Left//水平对齐
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom//垂直对齐
        textField.borderStyle = .None
        textField.placeholder = self.placeholder
        textField.returnKeyType = .Search
        self.addSubview(textField)
        
        self.textField.delegate = self
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector:"textDidChange", name: UITextFieldTextDidChangeNotification, object: nil)
        textField.addTarget(self, action: "textDidChange", forControlEvents: .EditingChanged)
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    //MARKS: Change事件
    func textDidChange(){
        delegate!.textFieldChange!()
    }
    
    //MARKS: 创建SearchImageView
    func createSearchImageView(){
        self.searchImageView = UIImageView()
        self.searchImageView.image = UIImage(named: "search")!
        
        var beginX:CGFloat = 0
        var beginY:CGFloat = 0
        var topPadding:CGFloat = 0
        if self.cancelText != nil {//有取消按钮,搜索按钮在textField最左边
            beginX = self.leftOrRightPadding
            topPadding = (self.frame.height - self.searchImageWidth) / 2
            beginY = topPadding
        } else {//没有取消按钮,搜索按钮在textField中间
            
        }
        
        self.searchImageView.frame = CGRectMake(beginX, beginY, searchImageWidth, searchImageWidth)
        self.addSubview(self.searchImageView)
    }

    //MARKS: 创建speakImageVuew
    func createSpeakImageView(){
        self.speakImageView = UIImageView()
        self.speakImageView.image = UIImage(named: "speak")!
        
        let beginX:CGFloat = self.frame.width - self.leftOrRightPadding - speakImageWidth
        let beginY:CGFloat = (self.frame.height - self.speakImageWidth) / 2
        
        self.speakImageView.frame = CGRectMake(beginX, beginY, speakImageWidth, speakImageWidth)
        self.addSubview(self.speakImageView)
    }
    
    
    //MARKS: 设置光标位置
    func resetCurForPosition(){
        let range = self.textField.selectedTextRange
        let start = self.textField.positionFromPosition(range!.start, inDirection: .Left, offset: (self.textField.text?.characters.count)!)
        if (start != nil) {
            self.textField.selectedTextRange = self.textField.textRangeFromPosition(start!, toPosition: start!)
        }
    }
    
}
