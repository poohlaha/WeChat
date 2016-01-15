//
//  PersonInfoCell.swift
//  WeChat
//
//  Created by Smile on 16/1/14.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class PersonInfoCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARKS:动态调整tablecell宽度
    func resizeWidth(width:CGFloat){
        self.frame = CGRect(x: self.frame.origin.x,y: self.frame.origin.y,width: width,height: self.frame.height)
        self.updateConstraints()
    }
    
    //MARKS:动态调整tablecell高度
    func resizeHeight(height:CGFloat){
        self.frame = CGRect(x: self.frame.origin.x,y: self.frame.origin.y,width: self.frame.width,height: height)
        self.updateConstraints()
    }
    
    //MARKS:动态调整tablecell宽度和高度
    func resize(width:CGFloat,height:CGFloat){
        self.frame = CGRect(x: self.frame.origin.x,y: self.frame.origin.y,width: self.frame.width,height: self.frame.height)
        self.updateConstraints()
    }
}
