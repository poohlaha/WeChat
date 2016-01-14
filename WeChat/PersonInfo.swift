//
//  PersonInfo.swift
//  WeChat
//
//  Created by Smile on 16/1/14.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class PersonInfo {
    
    //MARKS: Properties
    var date:String = "" //日期
    var infos:[Info] = [Info]()
    
    init(date:String,infos:[Info]){
        self.date = date
        self.infos = infos
    }
   
}


class Info{
    
    //MARKS: Properties
    var title:String = "" //标题
    var photoImage:UIImage? //图片
    var content:String = "" //内容
    
    init(title:String,photoImage:UIImage?,content:String){
        self.title = title
        self.photoImage = photoImage
        self.content = content
    }
    
    init(photoImage:UIImage?,content:String){
        self.photoImage = photoImage
        self.content = content
    }
}
