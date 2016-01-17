//
//  PersonInfo.swift
//  WeChat
//
//  Created by Smile on 16/1/14.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class PersonInfo:InfoNormal {
    
    //MARKS: Properties
    var date:String = "" //日期
    var day:String = ""//当天
    var place:String = ""//地点
    var infos:[Info] = [Info]()
    
    init(date:String,day:String,place:String,infos:[Info]){
        self.date = date
        self.day = day
        self.place = place
        self.infos = infos
    }
    
    init(date:String,day:String,infos:[Info]){
        self.date = date
        self.day = day
        self.infos = infos
    }
   
    override init(){
        
    }
}


class Info{
    
    //MARKS: Properties
    var title:Title?
    var photo:[Photo]?
    var content:Content?
    
    init(title:Title?,photo:[Photo]?,content:Content){
        self.title = title
        self.photo = photo
        self.content = content
    }
    
    init(photo:[Photo]?,content:Content){
        self.photo = photo
        self.content = content
    }
    
    init(photo:[Photo]?){
        self.photo = photo
    }
    
    init(content:Content){
        self.content = content
    }
}

//图片
class Photo:InfoNormal{
    var photoImage:UIImage? //图片
    var width:CGFloat = 50
    var height:CGFloat = 50
    var isBigPic:Bool = false
    
    init(photoImage:UIImage?,width:CGFloat,height:CGFloat){
        self.photoImage = photoImage
        self.width = width
        self.height = height
    }
    
    init(photoImage:UIImage?){
        self.photoImage = photoImage
    }
    
    init(photoImage:UIImage?,width:CGFloat,height:CGFloat,isBigPic:Bool){
        self.photoImage = photoImage
        self.width = width
        self.height = height
        self.isBigPic = isBigPic
    }
    
    init(photoImage:UIImage?,isBigPic:Bool){
        self.photoImage = photoImage
        self.isBigPic = isBigPic
    }
    
    init(width:CGFloat,height:CGFloat){
        self.width = width
        self.height = height
    }
}

//标题
class Title:InfoNormal{
    var title:String = "" //标题
    
    init(title:String){
        self.title = title
    }
}

//内容
class Content:InfoNormal{
    var content:String = "" //内容
    
    init(content:String){
        self.content = content
    }
}

class InfoNormal {
    var fontSize:CGFloat = 14//字体大小
    var color = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
    
    init(){
        
    }
    
    func initFontSizeAndColor(fontSize:CGFloat,color:UIColor){
        self.fontSize = fontSize
        self.color = color
    }
    
    func initFontSize(fontSize:CGFloat){
        self.fontSize = fontSize
    }
    
    func initColor(color:UIColor){
        self.color = color
    }
}
