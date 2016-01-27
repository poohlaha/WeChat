//
//  CommentDetailView.swift
//  WeChat
//
//  Created by Smile on 16/1/26.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class CommentDetailView: UIView {

    let imageWidth:CGFloat = 20
    let imageHeight:CGFloat = 20
    var nameLabel:CGFloat = 0
    var imageBigWidth:CGFloat = 60
    var imageBigHeight:CGFloat = 80
    
    var imageSmallWidth:CGFloat = 40//多张小图宽度
    var imageSmallHeight:CGFloat = 40//多张小图高度
    var smallImagePadding:CGFloat = 5//多张小图间空白
    
    var beforeDayLabel:CGFloat = 0//几天前
    var rightImgWidth:CGFloat = 15//右侧图片宽度
    var rightImgHeight:CGFloat = 7//右侧图片高度
    
    var topPadding:CGFloat = 10//上边空白
    var leftPadding:CGFloat = 15//左边空白
    var rightPadding:CGFloat = 15//右边空白
    var isLayedOut:Bool = false
    
    //要传入的值
    var info:Info!
    
    
    init(frame: CGRect,info:Info) {
        super.init(frame: frame)
        self.info = info
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayedOut {
            
            
            isLayedOut = true
        }
        
    }
    
    //MARKS: 创建页面元素
    func create(){
        
    }
}
