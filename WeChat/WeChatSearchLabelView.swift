//
//  WeChatSearchLabelView.swift
//  WeChat
//
//  Created by Smile on 16/2/3.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义搜索Label,用于当搜索框失去交点的时候使用
class WeChatSearchLabelView: UIView {
    
    var isLayedOut:Bool = false
    let padding:CGFloat = 7
    var textSearchView:TextSearchView!
    let placeholderWidth:CGFloat = 30

    init(frame: CGRect,textSearchView:TextSearchView) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.textSearchView = textSearchView
        self.setLayout()
    }
    
    func setLayout(){
        self.layer.borderWidth = self.textSearchView.layer.borderWidth
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.textSearchView.layer.cornerRadius
        self.layer.borderColor = self.textSearchView.layer.borderColor
        self.backgroundColor = self.textSearchView.backgroundColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayedOut {
            createView()
        }
    }
    
    func createView(){
        let centerView = UIView()
        let beginX:CGFloat = (self.frame.width - self.placeholderWidth - self.textSearchView.leftOrRightPadding - self.textSearchView.searchImageView.frame.width - self.textSearchView.speakImageWidth - 7) / 2
        let beginY = (self.frame.height - self.textSearchView.searchImageWidth) / 2
        centerView.frame = CGRectMake(beginX, beginY, self.textSearchView.searchImageView.frame.width, self.textSearchView.searchImageView.frame.height)
        
        //searchImageView
        let searchImageView = UIImageView()
        searchImageView.image = self.textSearchView.searchImageView.image
        searchImageView.frame = CGRectMake(0, 0, self.textSearchView.searchImageView.frame.width, self.textSearchView.searchImageView.frame.height)
        centerView.addSubview(searchImageView)
        
        //searchLabel
        let label = UILabel()
        label.frame = CGRectMake(searchImageView.frame.width + self.textSearchView.leftOrRightPadding,0,self.placeholderWidth,self.textSearchView.searchImageView.frame.height + 5)
        label.text = "搜索"
        label.font = self.textSearchView.textField.font
        label.textColor = UIColor.lightGrayColor()
        centerView.addSubview(label)
        
        //speakImageView
        let speakImageView = UIImageView()
        speakImageView.image = self.textSearchView.speakImageView.image
        speakImageView.frame = self.textSearchView.speakImageView.frame
        self.addSubview(speakImageView)
        
        self.addSubview(centerView)
    }
}
