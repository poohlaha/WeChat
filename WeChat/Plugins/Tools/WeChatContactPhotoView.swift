//
//  WeChatContactPhotoView.swift
//  WeChat
//
//  Created by Smile on 16/1/13.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

//自定义联系人图片
class WeChatContactPhotoView: WeChatDrawView {

    //MARKS: Properties
    var isLayedOut:Bool = false//是否初始化view
    var images:[UIImage] = [UIImage]()//图片数组
    var imageWidth:CGFloat = 40//默认图片宽度
    var imageHeight:CGFloat = 40//默认图片高度
    var paddingTopOrBottom:CGFloat = 5
    var paddingLeftOrRight:CGFloat = 5
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARKS:Init Frame
    init(frame: CGRect,images:[UIImage]) {
        super.init(frame: frame)
        
        //设置一些属性
        self.images = images
        self.backgroundColor = UIColor.clearColor()
        getPicWidth()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if images.count == 0 {
            return
        }
        
        if !isLayedOut {
            addImages()
        }
        
    }
    
    //MARKS: 添加图片
    func addImages(){
        var originX:CGFloat = 0
        for(var i = 0;i < images.count;i++){
            let y = self.paddingTopOrBottom
            imageRectForContentRect(originX, y: y, image: images[i])
            if i != (images.count - 1) {
                originX += (paddingLeftOrRight + self.imageWidth)
            }
        }
    }
    
    //MARKS: 图片成正比
    func getPicWidth(){
        let width = self.frame.width
        let picWidth = width - paddingLeftOrRight * 3
        self.imageWidth = picWidth / 4
        self.imageHeight = self.frame.height
        if self.imageHeight > self.imageWidth {
            self.imageHeight = self.imageWidth
        }
        
        if self.imageWidth > self.imageHeight {
            self.imageWidth = self.imageHeight
        }
        
        //重新计算上边距或左边距
        self.paddingLeftOrRight = (width - self.imageWidth * 4) / 3
        self.paddingTopOrBottom = (self.frame.height - self.imageHeight) / 2
    }
    
    //MARKS: 改变图片位置
    func imageRectForContentRect(x:CGFloat,y:CGFloat,image:UIImage){
        let imageView = UIImageView(image: image)
        imageView.userInteractionEnabled = true// 使图片视图支持交互
        imageView.frame = CGRectMake(x, y, self.imageWidth, self.imageHeight)
        self.addSubview(imageView)
    }
    
}
