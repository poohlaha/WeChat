//
//  WeChat.swift
//  WeChat
//
//  Created by Smile on 16/1/5.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class WeChat {
    
    //MARK: Properties
    var title:String
    var content:String
    var photo:UIImage?
    var time:String
    
    init?(title:String,content:String,photo:UIImage?){
        self.title = title
        self.content = content
        self.photo = photo
        
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yy/MM/dd"
        let strNowTime = timeFormatter.stringFromDate(date) as String
        self.time = strNowTime
        
        if(title.isEmpty || content.isEmpty) {
            return nil
        }
    }
}
