//
//  ContactTableViewCell.swift
//  WeChat
//
//  Created by Smile on 16/1/8.
//  Copyright © 2016年 smile.love.tao@gmail.com. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    //MARKS: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARKS: 解决最后一行分割线消失的问题
    override func layoutSubviews() {
        for subView in self.contentView.superview!.subviews {
            subView.hidden = false
            /*var frame = subView.frame
            frame.origin.x += self.separatorInset.left;
            frame.size.width -= self.separatorInset.right;
            subView.frame = frame;*/
        }
        
        //super.layoutSubviews()
    }
    
    func resize(width:CGFloat){
        self.frame = CGRect(x: self.frame.origin.x,y: self.frame.origin.y,width: width,height: self.frame.height)
        self.updateConstraints()
    }
}
